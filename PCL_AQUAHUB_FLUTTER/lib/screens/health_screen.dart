import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AquaHub — Health')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Check Health'),
              onPressed: api.isLoading ? null : () => api.fetchHealth(),
            ),
            const SizedBox(height: 20),
            if (api.isLoading) const Center(child: CircularProgressIndicator()),
            if (!api.isLoading && api.health != null) ...[
              Text('Status: ${api.health!.status}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('DB: ${api.health!.db ?? 'unknown'}'),
              if (api.health!.error != null) ...[
                const SizedBox(height: 8),
                Text('Error: ${api.health!.error}', style: const TextStyle(color: Colors.red)),
              ]
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/register'),
              child: const Text('Go to Register (Customer)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/vendor-login'),
              child: const Text('Vendor Login'),
            ),
            const SizedBox(height: 20),
            const Text('Tips:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('- If running on Android emulator, ensure backend is reachable at 10.0.2.2:5000'),
            const Text('- Set backend base URL in `lib/constants/api.dart` or pass via --dart-define'),
          ],
        ),
      ),
    );
  }
}
