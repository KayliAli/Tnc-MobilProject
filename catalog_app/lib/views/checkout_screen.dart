import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catalog_app/services/cart_manager.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cardholderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _securityCodeController = TextEditingController();

  String _country = 'United States';
  bool _isSubmitting = false;

  static const _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Turkiye',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _apartmentController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _postalCodeController.dispose();
    _cardholderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _securityCodeController.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty ? 'Required' : null;
  }

  String? _validateEmail(String? value) {
    if (_required(value) != null) return 'Required';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value!.trim())
        ? null
        : 'Enter a valid email address';
  }

  String? _validatePhone(String? value) {
    if (_required(value) != null) return 'Required';
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 7 ? null : 'Enter a valid phone number';
  }

  String? _validateCardNumber(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    return digits.length >= 12 && digits.length <= 19
        ? null
        : 'Enter a valid card number';
  }

  String? _validateExpiry(String? value) {
    if (value == null || !RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'Use MM/YY';
    }
    final month = int.parse(value.substring(0, 2));
    final year = 2000 + int.parse(value.substring(3, 5));
    final now = DateTime.now();
    if (month < 1 || month > 12 || year < now.year) {
      return 'Card has expired';
    }
    if (year == now.year && month < now.month) return 'Card has expired';
    return null;
  }

  String? _validateSecurityCode(String? value) {
    return value != null && RegExp(r'^\d{3,4}$').hasMatch(value)
        ? null
        : 'Enter a valid security code';
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter> inputFormatters = const [],
    IconData? icon,
    int maxLines = 1,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
      ),
    );
  }

  Widget _sectionHeading(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.black : Colors.grey.shade700,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? Colors.blue : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (CartManager.cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await CartManager.clearCart();
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to place the demo order')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = CartManager.total;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _sectionHeading(
                  Icons.local_shipping_outlined,
                  'Contact and delivery',
                ),
                const SizedBox(height: 16),
                _textField(
                  label: 'Full name',
                  controller: _nameController,
                  validator: _required,
                  icon: Icons.person_outline,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                _textField(
                  label: 'Email address',
                  controller: _emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 12),
                _textField(
                  label: 'Phone number',
                  controller: _phoneController,
                  validator: _validatePhone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+()\- ]')),
                    LengthLimitingTextInputFormatter(20),
                  ],
                  icon: Icons.phone_outlined,
                ),
                const SizedBox(height: 12),
                _textField(
                  label: 'Street address',
                  controller: _addressController,
                  validator: _required,
                  icon: Icons.home_outlined,
                ),
                const SizedBox(height: 12),
                _textField(
                  label: 'Apartment, suite, etc. (optional)',
                  controller: _apartmentController,
                  validator: (_) => null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        label: 'City',
                        controller: _cityController,
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(
                        label: 'State / region',
                        controller: _regionController,
                        validator: _required,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        label: 'Postal code',
                        controller: _postalCodeController,
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _country,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 15,
                          ),
                        ),
                        items: _countries
                            .map(
                              (country) => DropdownMenuItem(
                                value: country,
                                child: Text(
                                  country,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (country) {
                          if (country != null)
                            setState(() => _country = country);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _sectionHeading(Icons.credit_card_outlined, 'Payment details'),
                const SizedBox(height: 16),
                _textField(
                  label: 'Name on card',
                  controller: _cardholderController,
                  validator: _required,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _textField(
                  label: 'Card number',
                  controller: _cardNumberController,
                  validator: _validateCardNumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _CardNumberFormatter(),
                  ],
                  icon: Icons.credit_card,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        label: 'Expiry (MM/YY)',
                        controller: _expiryController,
                        validator: _validateExpiry,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_ExpiryFormatter()],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(
                        label: 'Security code',
                        controller: _securityCodeController,
                        validator: _validateSecurityCode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _sectionHeading(Icons.receipt_long_outlined, 'Order summary'),
                const SizedBox(height: 12),
                ...CartManager.cartItems.map(
                  (product) => _summaryRow(
                    product.name ?? 'Product',
                    product.price ?? '\$0.00',
                  ),
                ),
                const Divider(height: 20),
                _summaryRow('Shipping', 'Free'),
                _summaryRow(
                  'Total',
                  '\$${total.toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Demo checkout. Card data is not submitted or stored.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submitOrder,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Place order - \$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digits.length > 19 ? digits.substring(0, 19) : digits;
    final groups = <String>[];
    for (var index = 0; index < limitedDigits.length; index += 4) {
      final end = index + 4 > limitedDigits.length
          ? limitedDigits.length
          : index + 4;
      groups.add(limitedDigits.substring(index, end));
    }
    final formatted = groups.join(' ');
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digits.length > 4 ? digits.substring(0, 4) : digits;
    final formatted = limitedDigits.length > 2
        ? '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2)}'
        : limitedDigits;
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
