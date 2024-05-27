import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/wallet/money_widget.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/wallet/wallet_work_dialog.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key, this.profile});

  final AnglerProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 20,
            right: 12,
          ),
          child: Row(
            children: [
              const BackButtonWidget(),
              const Spacer(),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const WalletWorkDialog(),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'How does it work?',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xff6F6F6F),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SpaceHorizontal(4),
                    const Icon(
                      CupertinoIcons.info,
                      size: 16,
                      color: Color(0xff6F6F6F),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 22,
            right: 16,
          ),
          child: Row(
            children: [
              Text(
                'Wallet',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              CoinWidget(
                value: profile!.walletAmount,
                fontSize: 22,
                profile: profile,
                isFromWallet: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
