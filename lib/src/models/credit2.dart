class CreditCardModel{
  final String _cardNo,_expiryDate,_cvv,_logo;
  CreditCardModel(this._cardNo,
      this._logo,
      this._expiryDate,
      this._cvv):
      assert(_cardNo.length==16);

  String get cardNo
  {
    return "200 Coins";
  }


  String get logo => _logo;

  String get cvv => _cvv;

  String get expiryDate => _expiryDate;

}