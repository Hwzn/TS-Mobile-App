class BankAccount {
  String accountNumber;
  String bankName;
  String accountHolderName;
  String oId;

  BankAccount(
      {this.accountNumber, this.bankName, this.accountHolderName, this.oId});
  BankAccount.fromString(String id) {
    accountNumber = id;
    bankName = id;
    accountHolderName = id;
    oId = id;
  }
  BankAccount.fromJson(Map<String, dynamic> json) {
    accountNumber = json['accountNumber'];
    bankName = json['bankName'];
    accountHolderName = json['accountHolderName'];
    oId = json['oId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountNumber'] = this.accountNumber;
    data['bankName'] = this.bankName;
    data['accountHolderName'] = this.accountHolderName;
    data['oId'] = this.oId;
    return data;
  }
}
