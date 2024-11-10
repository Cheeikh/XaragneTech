import 'package:flutter/material.dart';

class ContactService {
  static final ContactService _instance = ContactService._internal();
  factory ContactService() => _instance;
  ContactService._internal();

  final List<Contact> _contacts = [
    Contact(
      id: '1',
      name: 'Marie Dupont',
      phoneNumber: '0612345678',
      email: 'marie.dupont@email.com',
      avatar: 'MD',
      color: Colors.blue,
      isFavorite: true,
    ),
    Contact(
      id: '2',
      name: 'Pierre Martin',
      phoneNumber: '0698765432',
      email: 'pierre.martin@email.com',
      avatar: 'PM',
      color: Colors.green,
      isFavorite: true,
    ),
    Contact(
      id: '3',
      name: 'Sophie Bernard',
      phoneNumber: '0611223344',
      email: 'sophie.bernard@email.com',
      avatar: 'SB',
      color: Colors.purple,
      isFavorite: false,
    ),
  ];

  Future<List<Contact>> getContacts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_contacts);
  }

  Future<List<Contact>> getFavoriteContacts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _contacts.where((contact) => contact.isFavorite).toList();
  }

  Future<Contact?> getContactByPhone(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _contacts
          .firstWhere((contact) => contact.phoneNumber == phoneNumber);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addContact(Contact contact) async {
    await Future.delayed(const Duration(seconds: 1));
    _contacts.add(contact);
    return true;
  }

  Future<bool> updateContact(Contact contact) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
      return true;
    }
    return false;
  }

  Future<bool> deleteContact(String contactId) async {
    await Future.delayed(const Duration(seconds: 1));
    _contacts.removeWhere((contact) => contact.id == contactId);
    return true;
  }

  Future<bool> toggleFavorite(String contactId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _contacts.indexWhere((contact) => contact.id == contactId);
    if (index != -1) {
      _contacts[index].isFavorite = !_contacts[index].isFavorite;
      return true;
    }
    return false;
  }

  Future<List<Transaction>> getTransactionsWithContact(String contactId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Transaction(
        id: '1',
        amount: -50.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        note: 'Restaurant',
        type: TransactionType.sent,
      ),
      Transaction(
        id: '2',
        amount: 25.0,
        date: DateTime.now().subtract(const Duration(days: 5)),
        note: 'Cinéma',
        type: TransactionType.received,
      ),
    ];
  }
}

class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String avatar;
  final Color color;
  bool isFavorite;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    required this.avatar,
    required this.color,
    this.isFavorite = false,
  });

  String get firstName => name.split(' ').first;
  String get lastName => name.split(' ').last;
  String get initials => avatar;
}

class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final String? note;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    this.note,
    required this.type,
  });

  String get formattedAmount =>
      '${type == TransactionType.sent ? '-' : '+'}${amount.toStringAsFixed(2)} €';
  String get formattedDate => '${date.day}/${date.month}/${date.year}';
}

enum TransactionType { sent, received }
