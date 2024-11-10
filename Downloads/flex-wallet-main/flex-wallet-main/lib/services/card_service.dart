import 'package:flutter/material.dart';

class CardService {
  static final CardService _instance = CardService._internal();
  factory CardService() => _instance;
  CardService._internal();

  final List<BankCard> _cards = [
    BankCard(
      id: '1',
      number: '**** **** **** 1234',
      holder: 'JOHN DOE',
      expiryDate: '12/25',
      type: CardType.visa,
      color: const Color(0xFF1E88E5),
      isDefault: true,
    ),
    BankCard(
      id: '2',
      number: '**** **** **** 5678',
      holder: 'JOHN DOE',
      expiryDate: '09/24',
      type: CardType.mastercard,
      color: const Color(0xFF43A047),
      isDefault: false,
    ),
  ];

  Future<List<BankCard>> getCards() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_cards);
  }

  Future<BankCard?> getDefaultCard() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _cards.firstWhere((card) => card.isDefault);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addCard(BankCard card) async {
    await Future.delayed(const Duration(seconds: 1));
    _cards.add(card);
    return true;
  }

  Future<bool> removeCard(String cardId) async {
    await Future.delayed(const Duration(seconds: 1));
    _cards.removeWhere((card) => card.id == cardId);
    return true;
  }

  Future<bool> setDefaultCard(String cardId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    for (var card in _cards) {
      card.isDefault = card.id == cardId;
    }
    return true;
  }

  Future<bool> updateCard(BankCard card) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _cards.indexWhere((c) => c.id == card.id);
    if (index != -1) {
      _cards[index] = card;
      return true;
    }
    return false;
  }
}

enum CardType { visa, mastercard, amex }

class BankCard {
  final String id;
  final String number;
  final String holder;
  final String expiryDate;
  final CardType type;
  final Color color;
  bool isDefault;

  BankCard({
    required this.id,
    required this.number,
    required this.holder,
    required this.expiryDate,
    required this.type,
    required this.color,
    this.isDefault = false,
  });

  String get typeString {
    switch (type) {
      case CardType.visa:
        return 'VISA';
      case CardType.mastercard:
        return 'MASTERCARD';
      case CardType.amex:
        return 'AMEX';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case CardType.visa:
        return Icons.credit_card;
      case CardType.mastercard:
        return Icons.credit_card;
      case CardType.amex:
        return Icons.credit_card;
    }
  }

  String get maskedNumber {
    return number.replaceAll(RegExp(r'\d(?=\d{4})'), '*');
  }

  String get last4Digits {
    return number.substring(number.length - 4);
  }
}
