class CreditHistory {
  String? id;
  String? walletId;
  num? amountInPence;
  String? description;
  TransactionType? transactionType;
  String? currency;
  String? transactionDate;

  CreditHistory(
      {this.id,
      this.walletId,
      this.amountInPence,
      this.description,
      this.transactionType,
      this.currency,
      this.transactionDate});

  CreditHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    walletId = json['wallet_id'];
    amountInPence = json['amount_in_pence'];
    description = json['description'];
    transactionType = json['transaction_type'] != null
        ? TransactionType.fromJson(json['transaction_type'])
        : null;
    currency = json['currency'];
    transactionDate = json['transaction_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wallet_id'] = walletId;
    data['amount_in_pence'] = amountInPence;
    data['description'] = description;
    if (transactionType != null) {
      data['transaction_type'] = transactionType!.toJson();
    }
    data['currency'] = currency;
    data['transaction_date'] = transactionDate;
    return data;
  }
}

class TransactionType {
  String? code;
  String? value;

  TransactionType({this.code, this.value});

  TransactionType.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['value'] = value;
    return data;
  }
}
