import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField<T> extends FormField<T> {
  final T? Function(String)? stringToValue;
  final String Function(T?)? valueToString;

  AppTextFormField({
    super.key,
    required String label,
    super.initialValue,
    super.validator,
    super.onSaved,
    ValueChanged<T?>? onChanged,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    InputDecoration? decoration,
    TextStyle? style,
    FocusNode? focusNode,
    bool? enabled,
    bool readOnly = false,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    TextDirection? textDirection,
    bool autofocus = false,
    bool expands = false,
    int? maxLines,
    int? minLines,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    this.stringToValue,
    this.valueToString,
  }) : super(
          enabled: enabled ?? true,
          builder: (FormFieldState<T> field) {
            final _AppFormFieldState state = field as _AppFormFieldState;
            return TextField(
              controller: state._effectiveController,
              obscureText: obscureText,
              keyboardType: keyboardType,
              focusNode: focusNode,
              textInputAction: textInputAction,
              textCapitalization: textCapitalization,
              style: style,
              enabled: enabled,
              readOnly: readOnly,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              textDirection: textDirection,
              autofocus: autofocus,
              maxLength: maxLength,
              minLines: minLines,
              maxLines: maxLines,
              inputFormatters: inputFormatters,
              decoration: (decoration ?? const InputDecoration()).copyWith(
                labelText: label,
                errorText: field.errorText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                floatingLabelStyle: const TextStyle(
                  fontSize: 18,
                ),
              ),
              onChanged: (value) {
                T? v =
                    stringToValue == null ? value as T? : stringToValue(value);
                field.didChange(v);
                if (onChanged != null) {
                  onChanged(v);
                }
              },
            );
          },
        );

  @override
  FormFieldState<T> createState() => _AppFormFieldState<T>();
}

class _AppFormFieldState<T> extends FormFieldState<T> {
  TextEditingController? _controller;

  TextEditingController get _effectiveController =>
      (_controller ??= TextEditingController(
          text: widget.valueToString != null
              ? widget.valueToString!(widget.initialValue)
              : '${widget.initialValue}'));

  @override
  AppTextFormField<T> get widget => super.widget as AppTextFormField<T>;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
