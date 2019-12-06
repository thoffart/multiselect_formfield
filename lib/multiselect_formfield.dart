library multiselect_formfield;

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_dialog.dart';

class MultiSelectFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final IconData icon;
  final String valueField;
  final Function change;
  final Function clear;
  final Function open;
  final Function close;
  final Widget leading;
  final Widget trailing;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final bool enableSearchBar;

  MultiSelectFormField({
    FormFieldSetter<dynamic> onSaved,
    FormFieldValidator<dynamic> validator,
    int initialValue,
    bool autovalidate = false,
    this.titleText = 'Title',
    this.hintText = 'Tap to select one or more',
    this.errorText = 'Please select one or more options',
    this.value,
    this.leading,
    this.dataSource,
    this.textField,
    this.icon,
    this.valueField,
    this.change,
    this.clear,
    this.open,
    this.close,
    this.okButtonLabel = 'OK',
    this.cancelButtonLabel = 'CANCEL',
    this.trailing,
    this.enableSearchBar = false,
  }) : super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue,
    autovalidate: autovalidate,
    builder: (FormFieldState<dynamic> state) {
      List<Widget> _buildSelectedOptions(List<dynamic> values, state) => (value != null)
      ? values
        .map((item) => dataSource.singleWhere((itm) => itm[valueField] == item, orElse: () => null))
        .map((item) => Chip(
          label: Text(item[textField], overflow: TextOverflow.ellipsis),
          backgroundColor: Colors.white,
          shape:  RoundedRectangleBorder(
            side: BorderSide(color: Color.fromRGBO(3, 78, 162, 1), width: 1),
            borderRadius: BorderRadius.circular(40.0),
          ),
        )).toList()
      : null;
      return InkWell(
        onTap: () async {
          final List selectedValues = await showDialog<List>(
            context: state.context,
            builder: (BuildContext context) {
              return MultiSelectDialog(
                title: titleText,
                okButtonLabel: okButtonLabel,
                cancelButtonLabel: cancelButtonLabel,
                items: dataSource.map((item) => MultiSelectDialogItem(item[valueField], item[textField])).toList(),
                initialSelectedValues: value ?? List(),
                enableSearchBar: enableSearchBar,
              );
            },
          );
          if (selectedValues != null) {
            state.didChange(selectedValues);
            state.save();
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            filled: false,
            errorText: state.hasError ? state.errorText : null,
            errorMaxLines: 4,
            icon: icon == null ? null : Icon(icon, color: Colors.grey),
            suffixIcon: (clear != null && value != null && value.length > 0)
              ? InkWell(
                onTap:() {
                  clear();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 25.0,                            
                ),
              )
              : Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
                size: 25.0,                            
              )
          ),
          isEmpty: state.value == null || state.value == '',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    value != null && value.length > 0
                    ? Expanded(
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 0.0,
                        children: _buildSelectedOptions(value, state),
                      )
                    )
                    : Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 4, left: 12),
                        child: Text(
                          hintText,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
