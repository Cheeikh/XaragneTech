import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';

class ConnectedDevicesPage extends StatelessWidget {
  final List<Map<String, dynamic>> devices = [
    {
      'name': 'iPhone 13',
      'type': 'iOS',
      'location': 'Paris, France',
      'lastAccess': 'Actuellement connecté',
      'icon': Icons.phone_iphone,
      'isCurrentDevice': true,
    },
    {
      'name': 'MacBook Pro',
      'type': 'macOS',
      'location': 'Paris, France',
      'lastAccess': 'Dernière connexion il y a 2 heures',
      'icon': Icons.laptop_mac,
      'isCurrentDevice': false,
    },
    {
      'name': 'Samsung Galaxy S21',
      'type': 'Android',
      'location': 'Lyon, France',
      'lastAccess': 'Dernière connexion hier',
      'icon': Icons.phone_android,
      'isCurrentDevice': false,
    },
    {
      'name': 'iPad Air',
      'type': 'iOS',
      'location': 'Marseille, France',
      'lastAccess': 'Dernière connexion il y a 5 jours',
      'icon': Icons.tablet_mac,
      'isCurrentDevice': false,
    },
  ];

  const ConnectedDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appareils connectés'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildDevicesList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appareils actifs',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gérez les appareils connectés à votre compte',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Si vous ne reconnaissez pas un appareil, déconnectez-le immédiatement',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return _buildDeviceItem(context, device);
      },
    );
  }

  Widget _buildDeviceItem(BuildContext context, Map<String, dynamic> device) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            device['icon'],
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Row(
          children: [
            Text(
              device['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (device['isCurrentDevice']) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Actuel',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(device['location']),
            Text(
              device['lastAccess'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: device['isCurrentDevice']
            ? null
            : IconButton(
                icon: const Icon(Icons.logout),
                color: Colors.red,
                onPressed: () => _showDisconnectDialog(context, device),
              ),
      ),
    );
  }

  void _showDisconnectDialog(
      BuildContext context, Map<String, dynamic> device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnecter l\'appareil'),
        content: Text(
          'Êtes-vous sûr de vouloir déconnecter "${device['name']}" ?\nCet appareil devra se reconnecter pour accéder à votre compte.',
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
                message: '${device['name']} a été déconnecté',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Déconnecter'),
          ),
        ],
      ),
    );
  }
}
