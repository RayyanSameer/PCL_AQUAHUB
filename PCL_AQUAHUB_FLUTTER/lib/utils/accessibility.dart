/// Accessibility helpers and utilities to improve app usability for all users.
/// Includes semantic labeling, focus management, and screen reader support.
import 'package:flutter/material.dart';

/// Utility for consistent semantic labels and accessibility hints.
class A11yLabels {
  /// Label for a loading state indicator.
  static String loadingLabel(String action) => 'Loading, $action in progress';

  /// Label for an error message.
  static String errorLabel(String message) => 'Error: $message';

  /// Label for success feedback.
  static String successLabel(String message) => 'Success: $message';

  /// Label for a form field.
  static String formFieldLabel(String fieldName, {bool required = false}) {
    return required ? '$fieldName, required field' : fieldName;
  }

  /// Label for a button or action.
  static String buttonLabel(String action, {String? context}) {
    return context != null ? '$action, $context' : action;
  }

  /// Label for list item count.
  static String itemCountLabel(int count, String itemName) {
    final plural = count == 1 ? itemName : '${itemName}s';
    return '$count $plural';
  }
}

/// Widget to improve focus management and navigation in forms.
class AccessibleFormField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final bool obscureText;
  final bool required;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AccessibleFormField({
    Key? key,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.obscureText = false,
    this.required = false,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<AccessibleFormField> createState() => _AccessibleFormFieldState();
}

class _AccessibleFormFieldState extends State<AccessibleFormField> {
  late FocusNode _focusNode;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        errorMaxLines: 2,
      ),
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      validator: (value) {
        final error = widget.validator?.call(value);
        setState(() => _hasError = error != null);
        return error;
      },
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      semanticFormatterCallback: (value) {
        if (_hasError) {
          return '${widget.label}, error';
        }
        return widget.label;
      },
    );
  }
}

/// Widget to provide semantic context for loading indicators.
class AccessibleLoadingIndicator extends StatelessWidget {
  final String label;
  final double size;

  const AccessibleLoadingIndicator({
    Key? key,
    required this.label,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: A11yLabels.loadingLabel(label),
      enabled: true,
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}

/// Widget to display error messages with accessible semantics.
class AccessibleErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AccessibleErrorMessage({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: A11yLabels.errorLabel(message),
      enabled: true,
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
                message,
                style: TextStyle(color: Colors.red.shade900),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display success messages with accessible semantics.
class AccessibleSuccessMessage extends StatelessWidget {
  final String message;
  final Duration duration;

  const AccessibleSuccessMessage({
    Key? key,
    required this.message,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: A11yLabels.successLabel(message),
      enabled: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.green.shade900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
