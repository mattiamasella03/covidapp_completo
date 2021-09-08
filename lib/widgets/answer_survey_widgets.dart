import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  final String option, description;
  final bool optionSelected;
  OptionTile(
      {@required this.optionSelected,
      @required this.description,
      @required this.option});
  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
                border: Border.all(
                    color: widget.optionSelected == true
                        ? Colors.red
                        : Colors.grey,
                    width: 2),
                borderRadius: BorderRadius.circular(30)),
            alignment: Alignment.center,
            child: Text(
              "${widget.option}",
              style: TextStyle(
                color: widget.optionSelected == true ? Colors.red : Colors.grey,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            widget.description,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
