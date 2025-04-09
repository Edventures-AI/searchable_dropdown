import 'package:async/async.dart';
import 'package:flutter/material.dart';

import 'package:searchable_paginated_dropdown/src/utils/custom_inkwell.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.onChangeComplete,
    this.changeCompletionDelay = const Duration(milliseconds: 800),
    this.hintText,
    this.hintStyle,
    this.leadingIcon,
    this.isOutlined = false,
    this.focusNode,
    this.controller,
    this.style,
  });

  /// Klavyeden değer girme işlemi bittikten kaç milisaniye sonra on change complete fonksiyonunun tetikleneceğini belirler.
  final bool isOutlined;
  final Duration changeCompletionDelay;
  final FocusNode? focusNode;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final TextStyle? style;

  /// Cancelable operation ile klavyeden değer girme işlemi kontrol edilir.
  /// Verilen delay içerisinde klavyeden yeni bir giriş olmaz ise bu fonksiyon tetiklenir.
  final void Function(String value)? onChangeComplete;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final myFocusNode = focusNode ?? FocusNode();

    return isOutlined
        ? _SearchBarTextField(
      onChangeComplete: onChangeComplete,
      changeCompletionDelay: changeCompletionDelay,
      hintText: hintText,
      hintStyle: hintStyle,
      leadingIcon: leadingIcon,
      focusNode: focusNode,
      controller: controller,
      style: style,
    )
        : _SearchBarTextField(
      onChangeComplete: onChangeComplete,
      changeCompletionDelay: changeCompletionDelay,
      hintText: hintText,
      hintStyle: hintStyle,
      leadingIcon: leadingIcon,
      focusNode: focusNode,
      controller: controller,
      style: style,
    );
  }
}

class _SearchBarTextField extends StatelessWidget {
  const _SearchBarTextField({
    this.onChangeComplete,
    this.changeCompletionDelay = const Duration(milliseconds: 800),
    this.hintText,
    this.hintStyle,
    this.leadingIcon,
    this.focusNode,
    this.controller,
    this.style,
  });

  final Duration changeCompletionDelay;
  final FocusNode? focusNode;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final TextStyle? style;
  final void Function(String value)? onChangeComplete;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    // Future.delayed return Future<dynamic>
    //ignore: avoid-dynamic
    CancelableOperation<dynamic>? cancelableOperation;

    void startCancelableOperation() {
      cancelableOperation = CancelableOperation.fromFuture(
        Future.delayed(changeCompletionDelay),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8, right: 12, left: 12),
      height: 70,
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onChanged: (value) async {
          await cancelableOperation?.cancel();
          startCancelableOperation();
          await cancelableOperation?.value.whenComplete(() {
            onChangeComplete?.call(value);
          });
        },
        style: style,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          hintStyle: hintStyle,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: Colors.grey[300]!, width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
