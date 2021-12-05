import 'package:Sunny/src/models/credit_card_model.dart';
import 'package:flutter/material.dart';
import 'package:Sunny/src/models/credit_card_model.dart';
import 'package:Sunny/src/models/payment_model.dart';
import 'package:Sunny/src/models/user_model.dart';

List<CreditCardModel> getCreditCards() {
  List<CreditCardModel> creditCards = [];
  creditCards.add(CreditCardModel(
      "4616900007729988",
      "https://resources.mynewsdesk.com/image/upload/ojf8ed4taaxccncp6pcp.png",
      "06/23",
      "192"));
  creditCards.add(CreditCardModel(
      "3015788947523652",
      "https://resources.mynewsdesk.com/image/upload/ojf8ed4taaxccncp6pcp.png",
      "04/25",
      "217"));
  return creditCards;
}

List<UserModel> getUsersCard() {
  List<UserModel> userCards = [
    UserModel("zahry", "assets/images/users/zahry.jpg"),
    UserModel("zaghdoudi", "assets/images/users/zaghdoudi.jpg"),
    UserModel("chams", "assets/images/users/chams.jpg"),
    UserModel("komti", "assets/images/users/komti.jpg"),
    UserModel("farah", "assets/images/users/farah.jpg"),
    UserModel("manel", "assets/images/users/manel.jpg"),

  ];

  return userCards;
}

List<PaymentModel> getPaymentsCard() {
  List<PaymentModel> paymentCards = [
    PaymentModel(Icons.monetization_on, Colors.black54, "*********347ee868d3c1",
        "07-23", "20.04", 251.00, -1),
    PaymentModel(Icons.monetization_on, Colors.black54, "*********347ee868d3c1",
        "07-23", "14.01", 64.00, -1),
    PaymentModel(Icons.monetization_on, Colors.black54, "*******347ee868d3c1",
        "07-23", "10.04", 1151.00, -1),
    PaymentModel(Icons.monetization_on, Colors.black54, "*******347ee868d3c1", "07-23",
        "09.04", 37.00, -1),
  ];

  return paymentCards;
}
