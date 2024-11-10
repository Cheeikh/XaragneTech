import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';
import 'connected_devices_page.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _biometricEnabled = false;
  bool _smsAuthEnabled = true;
  bool _notifyNewDevice = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sécurité'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Authentification',
              [
                _buildSwitchTile(
                  'Authentification biométrique',
                  'Utiliser votre empreinte digitale',
                  _biometricEnabled,
                  (value) {
                    setState(() => _biometricEnabled = value);
                    CustomSnackbar.show(
                      context: context,
                      message: value
                          ? 'Authentification biométrique activée'
                          : 'Authentification biométrique désactivée',
                    );
                  },
                  icon: Icons.fingerprint,
                ),
                _buildSwitchTile(
                  'Authentification SMS',
                  'Recevoir un code par SMS',
                  _smsAuthEnabled,
                  (value) {
                    setState(() => _smsAuthEnabled = value);
                    CustomSnackbar.show(
                      context: context,
                      message: value
                          ? 'Authentification SMS activée'
                          : 'Authentification SMS désactivée',
                    );
                  },
                  icon: Icons.message_outlined,
                ),
                _buildActionTile(
                  'Changer le code PIN',
                  'Modifier votre code PIN',
                  Icons.lock_outline,
                  () {
                    CustomSnackbar.show(
                      context: context,
                      message: 'Changement de PIN à venir',
                    );
                  },
                ),
              ],
            ),
            _buildSection(
              'Appareils',
              [
                _buildSwitchTile(
                  'Notification nouvel appareil',
                  'Être notifié lors d\'une nouvelle connexion',
                  _notifyNewDevice,
                  (value) {
                    setState(() => _notifyNewDevice = value);
                    CustomSnackbar.show(
                      context: context,
                      message: value
                          ? 'Notifications activées'
                          : 'Notifications désactivées',
                    );
                  },
                  icon: Icons.devices_outlined,
                ),
                _buildActionTile(
                  'Appareils connectés',
                  'Gérer les appareils connectés',
                  Icons.phone_iphone,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConnectedDevicesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            _buildSection(
              'Confidentialité',
              [
                _buildActionTile(
                  'Historique des connexions',
                  'Voir l\'historique des connexions',
                  Icons.history,
                  () {
                    CustomSnackbar.show(
                      context: context,
                      message: 'Historique à venir',
                    );
                  },
                ),
                _buildActionTile(
                  'Données personnelles',
                  'Gérer vos données personnelles',
                  Icons.privacy_tip_outlined,
                  () {
                    CustomSnackbar.show(
                      context: context,
                      message: 'Gestion des données à venir',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    required IconData icon,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
