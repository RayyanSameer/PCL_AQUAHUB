import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vendor_auth_provider.dart';
import 'vendor_dashboard_screen.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({Key? key}) : super(key: key);

  @override
  _VendorLoginScreenState createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<VendorAuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                onSaved: (v) => _email = v?.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (v) => _password = v,
                validator: (v) => (v == null || v.length < 6) ? 'Password min 6 chars' : null,
              ),
              const SizedBox(height: 16),
              if (auth.isLoading) const CircularProgressIndicator(),
              ElevatedButton(
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();
                        final ok = await auth.login(_email!, _password!);
                        if (ok && auth.vendor != null) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => VendorDashboardScreen(vendorProfileId: auth.vendor!.vendorProfileId)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${auth.error}')));
                        }
                      },
                child: const Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
