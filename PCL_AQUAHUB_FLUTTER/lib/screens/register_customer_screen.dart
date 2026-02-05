import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registration_provider.dart';

class RegisterCustomerScreen extends StatefulWidget {
  const RegisterCustomerScreen({Key? key}) : super(key: key);

  @override
  _RegisterCustomerScreenState createState() => _RegisterCustomerScreenState();
}

class _RegisterCustomerScreenState extends State<RegisterCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _data = {};

  @override
  Widget build(BuildContext context) {
    final reg = Provider.of<RegistrationProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Register Customer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => _data['email'] = v?.trim(),
                validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (v) => _data['password'] = v,
                validator: (v) => (v == null || v.length < 6) ? 'Password min 6 chars' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'First Name'),
                onSaved: (v) => _data['firstName'] = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Name'),
                onSaved: (v) => _data['lastName'] = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onSaved: (v) => _data['phone'] = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (v) => _data['address'] = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'City'),
                onSaved: (v) => _data['city'] = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'State'),
                onSaved: (v) => _data['state'] = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Postal Code'),
                onSaved: (v) => _data['postalCode'] = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              if (reg.isLoading) const Center(child: CircularProgressIndicator()),
              ElevatedButton(
                onPressed: reg.isLoading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();
                        final success = await reg.registerCustomer(_data);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registered: ${reg.lastUserId}')));
                          _formKey.currentState!.reset();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${reg.error}')));
                        }
                      },
                child: const Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
