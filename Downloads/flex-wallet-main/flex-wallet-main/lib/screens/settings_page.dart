import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _selectedLanguage = 'Français';
  String _selectedTheme = 'Clair';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Préférences',
              [
                _buildSwitchTile(
                  'Notifications',
                  'Recevoir des notifications',
                  _notificationsEnabled,
                  (value) {
                    setState(() => _notificationsEnabled = value);
                    CustomSnackbar.show(
                      context: context,
                      message: value
                          ? 'Notifications activées'
                          : 'Notifications désactivées',
                    );
                  },
                ),
                _buildSwitchTile(
                  'Authentification biométrique',
                  'Utiliser l\'empreinte digitale',
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
                ),
                _buildDropdownTile(
                  'Langue',
                  'Choisir la langue de l\'application',
                  _selectedLanguage,
                  ['Français', 'English', 'Español'],
                  (value) {
                    setState(() => _selectedLanguage = value!);
                    CustomSnackbar.show(
                      context: context,
                      message: 'Langue changée en $value',
                    );
                  },
                ),
                _buildDropdownTile(
                  'Thème',
                  'Choisir le thème de l\'application',
                  _selectedTheme,
                  ['Clair', 'Sombre', 'Système'],
                  (value) {
                    setState(() => _selectedTheme = value!);
                    CustomSnackbar.show(
                      context: context,
                      message: 'Thème changé en $value',
                    );
                  },
                ),
              ],
            ),
            _buildSection(
              'Sécurité',
              [
                _buildActionTile(
                  'Changer le code PIN',
                  'Modifier votre code PIN',
                  Icons.lock_outline,
                  () => CustomSnackbar.show(
                    context: context,
                    message: 'Changement de PIN à venir',
                  ),
                ),
                _buildActionTile(
                  'Appareils connectés',
                  'Gérer les appareils connectés',
                  Icons.devices_outlined,
                  () => CustomSnackbar.show(
                    context: context,
                    message: 'Gestion des appareils à venir',
                  ),
                ),
              ],
            ),
            _buildSection(
              'Données',
              [
                _buildActionTile(
                  'Exporter les données',
                  'Télécharger vos données',
                  Icons.download_outlined,
                  () => CustomSnackbar.show(
                    context: context,
                    message: 'Export des données à venir',
                  ),
                ),
                _buildActionTile(
                  'Supprimer le compte',
                  'Supprimer définitivement votre compte',
                  Icons.delete_outline,
                  () => _showDeleteAccountDialog(),
                  isDestructive: true,
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
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              CustomSnackbar.show(
                context: context,
                message: 'Suppression du compte simulée',
                isError: true,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
