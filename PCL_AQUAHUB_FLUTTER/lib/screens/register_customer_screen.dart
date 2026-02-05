import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registration_provider.dart';
import '../utils/form_validators.dart';

class RegisterCustomerScreen extends StatefulWidget {
  const RegisterCustomerScreen({Key? key}) : super(key: key);

  @override
  _RegisterCustomerScreenState createState() => _RegisterCustomerScreenState();
}

class _RegisterCustomerScreenState extends State<RegisterCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _data = {};
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reg = Provider.of<RegistrationProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Register as Customer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Email
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'your.email@example.com',
                  border: OutlineInputBorder(),
                  errorMaxLines: 2,
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => _data['email'] = v?.trim(),
                validator: FormValidators.validateEmail,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'At least 8 characters with uppercase and digit',
                  border: OutlineInputBorder(),
                  errorMaxLines: 2,
                ),
                obscureText: true,
                onSaved: (v) => _data['password'] = v,
                validator: FormValidators.validatePassword,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // Confirm Password
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  errorMaxLines: 2,
                ),
                obscureText: true,
                validator: (v) => FormValidators.validatePasswordConfirm(v, _passwordController.text),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // First Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => _data['firstName'] = v?.trim(),
                validator: (v) => FormValidators.validateRequired(v, fieldName: 'First name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // Last Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => _data['lastName'] = v?.trim(),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // Phone
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone',
                  hintText: '(123) 456-7890',
                  border: OutlineInputBorder(),
                  errorMaxLines: 2,
                ),
                keyboardType: TextInputType.phone,
                onSaved: (v) => _data['phone'] = v?.replaceAll(RegExp(r'\D'), ''),
                validator: FormValidators.validatePhone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // Address
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => _data['address'] = v?.trim(),
                validator: (v) => FormValidators.validateRequired(v, fieldName: 'Address'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // City
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => _data['city'] = v?.trim(),
                validator: (v) => FormValidators.validateRequired(v, fieldName: 'City'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // State
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'State / Province',
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => _data['state'] = v?.trim(),
                validator: (v) => FormValidators.validateRequired(v, fieldName: 'State'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // Postal Code
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Postal Code',
                  border: OutlineInputBorder(),
                  errorMaxLines: 2,
                ),
                onSaved: (v) => _data['postalCode'] = v?.trim(),
                validator: FormValidators.validatePostalCode,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
              // Error message
              if (reg.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Text(
                      reg.error!,
                      style: TextStyle(color: Colors.red.shade900),
                      semanticsLabel: 'Error: ${reg.error}',
                    ),
                  ),
                ),
              // Register Button
              ElevatedButton.icon(
                onPressed: reg.isLoading ? null : _handleRegister,
                icon: reg.isLoading ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ) : Icon(Icons.check),
                label: Text(reg.isLoading ? 'Registering...' : 'Register'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final reg = Provider.of<RegistrationProvider>(context, listen: false);
    final success = await reg.registerCustomer(_data);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully registered! User ID: ${reg.lastUserId}'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      _formKey.currentState!.reset();
      _passwordController.clear();
      // Optionally navigate or pop after a delay
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
    } else if (mounted) {
      // Error handled by error message display above
    }
  }
}
