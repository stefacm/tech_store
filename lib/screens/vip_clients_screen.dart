import 'package:flutter/material.dart';
import '../utils/validators.dart';

class VIPClientsScreen extends StatefulWidget {
  const VIPClientsScreen({super.key});

  @override
  State<VIPClientsScreen> createState() => _VIPClientsScreenState();
}

class _VIPClientsScreenState extends State<VIPClientsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _creditCardController = TextEditingController();

  String? _detectedCardFranchise;

  @override
  void initState() {
    super.initState();
    _creditCardController.addListener(_updateCardFranchise);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _creditCardController.dispose();
    super.dispose();
  }

  void _updateCardFranchise() {
    setState(() {
      _detectedCardFranchise = Validators.getCardFranchise(
        _creditCardController.text,
      );
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Cliente VIP registrado exitosamente')),
            ],
          ),
          backgroundColor: Colors.purple.shade600,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      _fullNameController.clear();
      _emailController.clear();
      _creditCardController.clear();
      _formKey.currentState!.reset();
    }
  }

  String _formatCardNumber(String value) {
    final cleaned = value.replaceAll(' ', '').substring(0, 16);

    if (cleaned.length <= 4) return cleaned;
    if (cleaned.length <= 8) {
      return '${cleaned.substring(0, 4)} ${cleaned.substring(4)}';
    }
    if (cleaned.length <= 12) {
      return '${cleaned.substring(0, 4)} ${cleaned.substring(4, 8)} ${cleaned.substring(8)}';
    }
    return '${cleaned.substring(0, 4)} ${cleaned.substring(4, 8)} ${cleaned.substring(8, 12)} ${cleaned.substring(12)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header con icono
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF7C3AED),
                      Color(0xFF7C3AED).withAlpha(204),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.credit_card,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Nuevo Cliente VIP',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Registro de clientes corporativos',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Campo Nombre Completo
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                  hintText: 'Ej: Juan Pérez García',
                  prefixIcon: const Icon(Icons.person_outline),
                  helperText: 'Nombre y apellido requeridos',
                ),
                validator: Validators.validateFullName,
              ),
              const SizedBox(height: 20),

              // Campo Correo Corporativo
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo Corporativo',
                  hintText: 'usuario@techstore.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  helperText: '@techstore.com o @partner.com',
                ),
                validator: Validators.validateCorporateEmail,
              ),
              const SizedBox(height: 20),

              // Campo Tarjeta de Crédito
              TextFormField(
                controller: _creditCardController,
                keyboardType: TextInputType.number,
                maxLength: 19,
                decoration: InputDecoration(
                  labelText: 'Tarjeta de Crédito',
                  hintText: '4111 1111 1111 1111',
                  prefixIcon: const Icon(Icons.credit_card_outlined),
                  counterText: '',
                  suffixIcon: _detectedCardFranchise != null
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: _buildCardIcon(_detectedCardFranchise!),
                        )
                      : null,
                  helperText: '16 dígitos',
                ),
                onChanged: (value) {
                  final cleaned = value.replaceAll(' ', '');
                  if (cleaned.length <= 16) {
                    _creditCardController.value = TextEditingValue(
                      text: _formatCardNumber(cleaned),
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: _formatCardNumber(cleaned).length),
                      ),
                    );
                  }
                },
                validator: Validators.validateCreditCard,
              ),
              const SizedBox(height: 12),

              // Indicador de franquicia
              if (_detectedCardFranchise != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border.all(color: Colors.green.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Franquicia: $_detectedCardFranchise',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Botón Registrar
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 4,
                ),
                onPressed: _submitForm,
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: const Text(
                  'Registrar Cliente VIP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardIcon(String franchise) {
    if (franchise == 'Visa') {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.credit_card, color: Colors.blue.shade700, size: 20),
      );
    } else if (franchise == 'MasterCard') {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.credit_card, color: Colors.red.shade700, size: 20),
      );
    }
    return const SizedBox.shrink();
  }
}
