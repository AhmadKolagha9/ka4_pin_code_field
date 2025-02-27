import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pin_theme.dart';

class Ka4PinCodeField extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final bool autofocus;
  final TextInputType keyboardType;
  final PinTheme pinTheme;

  const Ka4PinCodeField({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.autofocus = true,
    this.keyboardType = TextInputType.number,
    this.pinTheme = const PinTheme(),
  });

  @override
  State<Ka4PinCodeField> createState() => _Ka4PinCodeFieldState();
}

class _Ka4PinCodeFieldState extends State<Ka4PinCodeField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  final List<String> _code = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    _controllers = List.generate(
      widget.length,
          (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
          (index) => FocusNode(),
    );
    _code.addAll(List.filled(widget.length, ''));
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus(); // Keep focus on last field
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _code[index] = value;
    final fullCode = _code.join();

    if (fullCode.length == widget.length) {
      widget.onCompleted?.call(fullCode);
    }
  }

  void _handlePaste(String pastedText) {
    if (pastedText.length == widget.length) {
      for (int i = 0; i < widget.length; i++) {
        _controllers[i].text = pastedText[i];
        _code[i] = pastedText[i];
      }
      widget.onCompleted?.call(pastedText);
      setState(() {}); // Force UI update
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.length,
            (index) => _buildDigitField(index),
      ),
    );
  }

  Widget _buildDigitField(int index) {
    return SizedBox(
      width: widget.pinTheme.fieldWidth,
      height: widget.pinTheme.fieldHeight,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        autofocus: widget.autofocus && index == 0,
        textAlign: TextAlign.center,
        keyboardType: widget.keyboardType,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _Ka4PinCodeInputFormatter(
            onPaste: _handlePaste,
            length: widget.length,
          ),
        ],
        decoration: InputDecoration(
          counterText: '',
          border: widget.pinTheme.border,
          enabledBorder: widget.pinTheme.enabledBorder,
          focusedBorder: widget.pinTheme.focusedBorder,
          fillColor: widget.pinTheme.fieldBackgroundColor,
          filled: widget.pinTheme.hasBackground,
        ),
        onChanged: (value) => _onTextChanged(index, value),
        onTap: () => _controllers[index].selection =
            TextSelection.collapsed(offset: 0),
      ),
    );
  }
}

class _Ka4PinCodeInputFormatter extends TextInputFormatter {
  final Function(String) onPaste;
  final int length;

  _Ka4PinCodeInputFormatter({
    required this.onPaste,
    required this.length,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.length == length) {
      onPaste(newValue.text);
      return oldValue; // Prevent clearing the current field
    } else if (newValue.text.length > 1) {
      return oldValue; // Block invalid input
    }
    return newValue;
  }
}