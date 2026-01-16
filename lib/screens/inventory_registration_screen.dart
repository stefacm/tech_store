import 'package:flutter/material.dart';
import '../utils/validators.dart';

class InventoryRegistrationScreen extends StatefulWidget {
  const InventoryRegistrationScreen({super.key});

  @override
  State<InventoryRegistrationScreen> createState() =>
      _InventoryRegistrationScreenState();
}

class _InventoryRegistrationScreenState
    extends State<InventoryRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skuController = TextEditingController();
  final _productNameController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isHighEndProduct = false;

  @override
  void initState() {
    super.initState();
    _priceController.addListener(_updateHighEndStatus);
  }

  @override
  void dispose() {
    _skuController.dispose();
    _productNameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateHighEndStatus() {
    setState(() {
      _isHighEndProduct = Validators.isHighEndProduct(_priceController.text);
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
              Expanded(child: Text('Producto registrado exitosamente')),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      _skuController.clear();
      _productNameController.clear();
      _stockController.clear();
      _priceController.clear();
      _formKey.currentState!.reset();
    }
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
                      Color(0xFF1F77E8),
                      Color(0xFF1F77E8).withAlpha(204),
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
                        Icons.inventory_2,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Nuevo Producto',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Campo SKU
              TextFormField(
                controller: _skuController,
                decoration: InputDecoration(
                  labelText: 'Código SKU',
                  hintText: 'MON-001',
                  prefixIcon: const Icon(Icons.qr_code_2),
                  helperText: 'Formato: 3 letras + guion + 3 números',
                ),
                validator: Validators.validateSKU,
              ),
              const SizedBox(height: 20),

              // Campo Nombre del Producto
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Producto',
                  hintText: 'Ej: Monitor Samsung 27"',
                  prefixIcon: const Icon(Icons.label_outline),
                  helperText: 'Mínimo 5 caracteres',
                ),
                validator: Validators.validateProductName,
              ),
              const SizedBox(height: 20),

              // Campo Stock
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock Inicial',
                  hintText: 'Ej: 50',
                  prefixIcon: const Icon(Icons.warehouse_outlined),
                  helperText: 'Debe ser mayor a 0',
                ),
                validator: Validators.validateStock,
              ),
              const SizedBox(height: 20),

              // Campo Precio
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Precio Unitario (\$)',
                  hintText: 'Ej: 1500000.50',
                  prefixIcon: const Icon(Icons.attach_money),
                  helperText: 'Acepta decimales',
                ),
                validator: Validators.validatePrice,
              ),
              const SizedBox(height: 12),

              // Alerta de producto de alta gama
              if (_isHighEndProduct)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    border: Border.all(color: Colors.amber.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade700, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Este producto será marcado como Alta Gama',
                          style: TextStyle(
                            color: Colors.amber.shade900,
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
                  backgroundColor: const Color(0xFF1F77E8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 4,
                ),
                onPressed: _submitForm,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text(
                  'Registrar Producto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
