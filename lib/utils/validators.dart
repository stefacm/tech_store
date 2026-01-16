class Validators {
  static String? validateSKU(String? value) {
    if (value == null || value.isEmpty) {
      return 'El código SKU es obligatorio';
    }

    /// Ejemplo: MON-001
    final skuRegex = RegExp(r'^[A-Z]{3}-\d{3}$');
    if (!skuRegex.hasMatch(value)) {
      return 'El SKU debe tener formato XXX-### (3 letras mayúsculas, guion y 3 números)';
    }

    return null;
  }

  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre del producto es obligatorio';
    }

    if (value.length < 5) {
      return 'El nombre debe tener al menos 5 caracteres';
    }

    if (RegExp(r'^\d+$').hasMatch(value)) {
      return 'El nombre no puede contener solo números';
    }

    return null;
  }

  static String? validateStock(String? value) {
    if (value == null || value.isEmpty) {
      return 'El stock inicial es obligatorio';
    }

    try {
      final stock = int.parse(value);
      if (stock <= 0) {
        return 'El stock debe ser mayor a 0';
      }
    } catch (e) {
      return 'El stock debe ser un número entero';
    }

    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'El precio unitario es obligatorio';
    }

    try {
      double.parse(value);
    } catch (e) {
      return 'El precio debe ser un número válido';
    }

    return null;
  }

  static bool isHighEndProduct(String? value) {
    if (value == null || value.isEmpty) return false;

    try {
      final price = double.parse(value);
      return price > 1000000;
    } catch (e) {
      return false;
    }
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre completo es obligatorio';
    }

    if (value.trim().split(' ').length < 2) {
      return 'Ingrese al menos nombre y apellido';
    }

    return null;
  }

  static String? validateCorporateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo corporativo es obligatorio';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo válido';
    }

    if (!value.endsWith('@techstore.com') && !value.endsWith('@partner.com')) {
      return 'Solo se aceptan correos @techstore.com o @partner.com';
    }

    return null;
  }

  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número de tarjeta es obligatorio';
    }

    final cardNumber = value.replaceAll(' ', '');

    if (!RegExp(r'^\d{16}$').hasMatch(cardNumber)) {
      return 'La tarjeta debe tener exactamente 16 dígitos';
    }

    if (!_isValidCardFranchise(cardNumber)) {
      return 'Solo aceptamos Visa o MasterCard';
    }

    return null;
  }

  static String? getCardFranchise(String? value) {
    if (value == null || value.isEmpty) return null;

    final cardNumber = value.replaceAll(' ', '');

    if (cardNumber.startsWith('4')) {
      return 'Visa';
    } else if (cardNumber.startsWith('51') ||
        cardNumber.startsWith('52') ||
        cardNumber.startsWith('53') ||
        cardNumber.startsWith('54') ||
        cardNumber.startsWith('55')) {
      return 'MasterCard';
    }

    return null;
  }

  static bool _isValidCardFranchise(String cardNumber) {
    if (cardNumber.startsWith('4')) return true;

    if (cardNumber.startsWith('51') ||
        cardNumber.startsWith('52') ||
        cardNumber.startsWith('53') ||
        cardNumber.startsWith('54') ||
        cardNumber.startsWith('55')) {
      return true;
    }

    return false;
  }

  static String? validateDiscountCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'El código de descuento es obligatorio';
    }

    const validCodes = ['DESCUENTO10', 'PROMO2025', 'VIPUSER'];

    if (!validCodes.contains(value.toUpperCase())) {
      return 'Cupón expirado o inexistente';
    }

    return null;
  }

  static String? validateDeliveryDate(DateTime? date) {
    if (date == null) {
      return 'La fecha de entrega es obligatoria';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (date.isBefore(today)) {
      return 'No se puede seleccionar una fecha en el pasado';
    }

    return null;
  }

  static String? validateNotWeekend(DateTime? date) {
    if (date == null) {
      return 'La fecha de entrega es obligatoria';
    }

    // weekday: 1-7 (lunes a domingo), donde 6=sábado y 7=domingo
    if (date.weekday == 6 || date.weekday == 7) {
      return 'No hay despachos en fines de semana';
    }

    return null;
  }

  static String? validateDeliveryDateTime(DateTime? date) {
    String? result = validateDeliveryDate(date);
    if (result != null) return result;

    result = validateNotWeekend(date);
    if (result != null) return result;

    return null;
  }
}
