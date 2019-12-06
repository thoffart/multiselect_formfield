import 'package:flutter/material.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog(
      {Key key, this.items, this.initialSelectedValues, this.title, this.okButtonLabel, this.cancelButtonLabel, this.enableSearchBar})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final List<V> initialSelectedValues;
  final String title;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final bool enableSearchBar;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = List<V>();
  String _filterText;

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  void filterSearchResults(String text) {
    setState(() {
    _filterText = text;
    });
  }

  Widget _searchBar() => Padding(
    padding: EdgeInsets.all(16),
    child: TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        prefixIcon: Icon(Icons.search),
        focusedBorder: new OutlineInputBorder(
          borderRadius:BorderRadius.circular(50.0),
          borderSide: new BorderSide(
            color: Colors.blue
          )
        ),
        border: new OutlineInputBorder(
          borderRadius:BorderRadius.circular(50.0),
          borderSide: new BorderSide(
            color: Colors.blue
          )
        ),
        hintText: 'Pesquisar...',
      ),
      style: TextStyle(
        fontSize: 16.0,
        fontFamily: "Hind",
        decoration: TextDecoration.none,
      ),
      onChanged: (value) => filterSearchResults(value),
    )
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if(widget.enableSearchBar)
              _searchBar(),
            Expanded(
              child: SingleChildScrollView(
                child: ListTileTheme(
                  contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
                  child: ListBody(
                    children: (_filterText == null || _filterText == "") 
                    ? widget.items.map(_buildItem).toList()
                    : _filterItens(widget.items),
                  ),             
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(widget.cancelButtonLabel),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text(widget.okButtonLabel),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  List<Widget> _filterItens(List<MultiSelectDialogItem<V>> items) {
    final List filteredItems = items.map(_buildItemWithFilter).toList()..removeWhere((value) => value == null);
    return (filteredItems.length != 0)
      ? filteredItems
      : List.from([SizedBox(height: 40,),Center(child: Text('Nada encontrado!'),)]);
    
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    return CheckboxListTile(
      value: _selectedValues.contains(item.value),
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }

  Widget _buildItemWithFilter(MultiSelectDialogItem<V> item) {
     return item.label.toLowerCase().contains(_filterText.toLowerCase()) 
     ? CheckboxListTile(
        value: _selectedValues.contains(item.value),
        title: Text(item.label),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (checked) => _onItemCheckedChange(item.value, checked),
      )
     : null;
  }
}
