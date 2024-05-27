class WalletModel {
  String? currency;
  String? userId;
  bool? isActive;
  String? id;
  String? lastTransactionDate;
  int? balanceInPence;
  String? createdAt;

  WalletModel(
      {this.currency,
      this.userId,
      this.isActive,
      this.id,
      this.lastTransactionDate,
      this.balanceInPence,
      this.createdAt});

  WalletModel.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    userId = json['user_id'];
    isActive = json['is_active'];
    id = json['id'];
    lastTransactionDate = json['last_transaction_date'];
    balanceInPence = json['balance_in_pence'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency'] = currency;
    data['user_id'] = userId;
    data['is_active'] = isActive;
    data['id'] = id;
    data['last_transaction_date'] = lastTransactionDate;
    data['balance_in_pence'] = balanceInPence;
    data['created_at'] = createdAt;
    return data;
  }
}
