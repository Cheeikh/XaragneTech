import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _recentContacts = [
    {
      'name': 'Marie Dupont',
      'phone': '06 12 34 56 78',
      'avatar': 'MD',
      'color': Colors.blue,
    },
    {
      'name': 'Pierre Martin',
      'phone': '06 98 76 54 32',
      'avatar': 'PM',
      'color': Colors.green,
    },
    {
      'name': 'Sophie Bernard',
      'phone': '06 11 22 33 44',
      'avatar': 'SB',
      'color': Colors.purple,
    },
  ];

  void _handleTransfer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simuler un transfert
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      CustomSnackbar.show(
        context: context,
        message: 'Transfert effectué avec succès',
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfert'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contacts récents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recentContacts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildAddContactButton();
                      }
                      final contact = _recentContacts[index - 1];
                      return _buildContactItem(contact);
                    },
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _recipientController,
                  decoration: const InputDecoration(
                    labelText: 'Destinataire',
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: 'Numéro de téléphone',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un destinataire';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Montant',
                    prefixIcon: Icon(Icons.euro),
                    hintText: '0.00',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un montant';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Veuillez entrer un montant valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note (facultatif)',
                    prefixIcon: Icon(Icons.note_outlined),
                    hintText: 'Ex: Remboursement restaurant',
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleTransfer,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Transférer'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddContactButton() {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                CustomSnackbar.show(
                  context: context,
                  message: 'Ajout de contact à venir',
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ajouter',
            style: TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(Map<String, dynamic> contact) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          _recipientController.text = contact['phone'];
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: contact['color'],
              child: Text(
                contact['avatar'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              contact['name'].split(' ')[0],
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
