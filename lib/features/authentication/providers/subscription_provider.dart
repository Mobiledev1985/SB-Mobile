import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/features/authentication/ui/views/sb_purchased_screen.dart';

class SubscriptionProvider extends ChangeNotifier {
  final bool kAutoConsume = Platform.isIOS || true;

  final SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  bool isFromBanner = false;
  String email = '';

  final List<String> _kProductIds = <String>[
    "sb_plus_4.99_1m",
    "sb_plus_49.99_1y",
    "sb_plus_pro_6.99_1m",
    "sb_plus_pro_59.99_1y",
  ];

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final List<String> _notFoundIds = <String>[];
  final List<ProductDetails> products = <ProductDetails>[];
  final List<PurchaseDetails> purchases = <PurchaseDetails>[];
  bool isAvailable = false;
  bool loading = true;
  bool purchasePending = false;
  bool isProSelect = false;

  String? userId;

  void onInit(BuildContext context) {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList, context);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {});
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      this.isAvailable = isAvailable;
      products.clear();
      purchases.clear();
      _notFoundIds.clear();
      purchasePending = false;
      loading = false;
      notifyListeners();
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    // var transactions = await SKPaymentQueueWrapper().transactions();
    // for (var skPaymentTransactionWrapper in transactions) {
    //   SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
    // }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null ||
        productDetailResponse.productDetails.isEmpty) {
      this.isAvailable = isAvailable;
      products.addAll(productDetailResponse.productDetails);
      purchases.clear();
      _notFoundIds.addAll(productDetailResponse.notFoundIDs);
      purchasePending = false;
      loading = false;
      notifyListeners();
      return;
    }

    this.isAvailable = isAvailable;
    products.addAll(productDetailResponse.productDetails);
    purchases.clear();
    _notFoundIds.addAll(productDetailResponse.notFoundIDs);
    purchasePending = false;
    loading = false;
    notifyListeners();
    return;
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList, BuildContext context) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        onCanceled();
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        handleError(purchaseDetails.error!);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        final (bool, String?) valid = await _verifyPurchase(purchaseDetails);

        if (valid.$1) {
          unawaited(deliverProduct(purchaseDetails));
          isFromBanner = false;
          // ignore: use_build_context_synchronously
          // ignore: use_build_context_synchronously
          SBPurchasedScreen.navigateTo(context, isProSelect ? 'PRO' : 'PLUS');
          // // ignore: use_build_context_synchronously
          // BottomBarProvider.of(context).selectedBottomBarItem.value = 0;
          // // ignore: use_build_context_synchronously
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const BottomBarScreen(),
          //   ),
          //   (route) => false,
          // );
        } else if (valid.$2 != null) {
          showAlert(valid.$2 ?? 'Verification Failed');
        } else {
          _handleInvalidPurchase(purchaseDetails);
          return;
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> onPurchasePlan(
      String subscriptionId, bool isProSelect, String email) async {
    this.isProSelect = isProSelect;
    showPendingUI();
    try {
      userId = await apiProvider.registerNewSubscriber(email: email);

      this.email = email;
      if (userId != null) {
        await _inAppPurchase.buyNonConsumable(
          purchaseParam: PurchaseParam(
            productDetails: products.firstWhere(
              (element) => element.id == subscriptionId,
            ),
          ),
        );
      }
    } catch (e) {
      stopPurchaseLoading();
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    if (purchasePending) {
      showAlert('Verification Failed');
    }
    stopPurchaseLoading();
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchasePending) {
      showAlert('Successfully Purchased');
    }
    stopPurchaseLoading();
  }

  Future<(bool, String?)> _verifyPurchase(
      PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.

    return await apiProvider.verifyPurchase(
      purchaseDetails.verificationData.source,
      purchaseDetails.productID,
      purchaseDetails.verificationData.serverVerificationData,
      email,
    );
  }

  void handleError(IAPError error) {
    if (purchasePending) {
      if (Platform.isAndroid) {
        showAlert(
            'This Google Play ID is associated with a different swimbooker account... Please log in to your other account to access Plus features or log in to a different Google Play ID on this device');
      } else {
        showAlert('Failed to Purchase');
      }
    }
    stopPurchaseLoading();
  }

  void showPendingUI() {
    purchasePending = true;
    notifyListeners();
  }

  void onCanceled() {
    if (purchasePending) {
      showAlert('Cancelled. Please Try Again.');
    }
    stopPurchaseLoading();
  }

  void stopPurchaseLoading() async {
    if (purchasePending) {
      purchasePending = false;
      notifyListeners();
    }
  }

  Future<void> onDispose() async {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
