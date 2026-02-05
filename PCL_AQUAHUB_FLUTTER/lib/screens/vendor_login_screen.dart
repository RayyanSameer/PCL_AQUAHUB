import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vendor_auth_provider.dart';
import '../utils/form_validators.dart';
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
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<VendorAuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Login')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineSmall,
                    semanticsLabel: 'Welcome Back to Vendor Portal',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to manage your orders',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 32),
                  // Email Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'vendor@example.com',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorMaxLines: 2,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: FormValidators.validateEmail,
                    onSaved: (v) => _email = v?.trim(),
                    textInputAction: TextInputAction.next,
                    enabled: !auth.isLoading,
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                        tooltip: _showPassword ? 'Hide password' : 'Show password',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorMaxLines: 2,
                    ),
                    obscureText: !_showPassword,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Password is required';
                      }
                      if (v.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    onSaved: (v) => _password = v,
                    textInputAction: TextInputAction.done,
                    enabled: !auth.isLoading,
                  ),
                  const SizedBox(height: 24),
                  // Error Message
                  if (auth.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                auth.error ?? 'Login failed',
                                style: TextStyle(color: Colors.red.shade900),
                                semanticsLabel: 'Error: ${auth.error}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: auth.isLoading ? null : _handleLogin,
                      icon: auth.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColorLight,
                                ),
                              ),
                            )
                          : Icon(Icons.login),
                      label: Text(
                        auth.isLoading ? 'Signing in...' : 'Sign In',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Support Link
                  TextButton(
                    onPressed: auth.isLoading ? null : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Contact support for password reset')),
                      );
                    },
                    child: const Text('Forgot your password?'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final auth = Provider.of<VendorAuthProvider>(context, listen: false);
    final success = await auth.login(_email!, _password!);
    if (success && auth.vendor != null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => VendorDashboardScreen(
            vendorProfileId: auth.vendor!.vendorProfileId,
          ),
        ),
      );
    } else if (mounted) {
      // Error message is shown via auth.error in UI
    }
  }
}
