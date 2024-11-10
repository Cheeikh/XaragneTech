import 'package:flutter/material.dart';
import '../widgets/pin_keyboard.dart';
import '../widgets/pin_dots.dart';
import 'registration_details_page.dart';
import 'dashboard_page.dart';

class PinPage extends StatefulWidget {
  final String phoneNumber;
  final bool isRegistration;

  const PinPage({super.key, 
    required this.phoneNumber,
    required this.isRegistration,
  });

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  String _pin = '';
  bool _isLoading = false;
  bool _showError = false;

  void _handleKeyPress(String key) {
    setState(() {
      if (_pin.length < 4) {
        _pin += key;
        _showError = false;
        if (_pin.length == 4) {
          _verifyPin();
        }
      }
    });
  }

  void _handleDelete() {
    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
        _showError = false;
      }
    });
  }

  Future<void> _verifyPin() async {
    if (_pin == '1234') {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.isRegistration
              ? RegistrationDetailsPage(phoneNumber: widget.phoneNumber)
              : const DashboardPage(),
        ),
      );
    } else {
      setState(() {
        _showError = true;
        _pin = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Code PIN incorrect'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isRegistration ? 'Créer un PIN' : 'Entrer votre PIN'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.isRegistration
                              ? Icons.lock_outline
                              : Icons.lock_open_outlined,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        widget.isRegistration
                            ? 'Créez votre code PIN'
                            : 'Entrez votre code PIN',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.isRegistration
                            ? 'Choisissez un code à 4 chiffres'
                            : 'Utilisez votre code à 4 chiffres',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : PinDots(
                              length: 4,
                              filledCount: _pin.length,
                            ),
                      if (_showError) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Code PIN incorrect',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              PinKeyboard(
                onKeyPressed: _handleKeyPress,
                onDelete: _handleDelete,
                showBiometric: !widget.isRegistration,
                onBiometricPressed: widget.isRegistration
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text('Authentification biométrique simulée'),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        );
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
