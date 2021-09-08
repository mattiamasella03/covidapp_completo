import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 28),
      children: <TextSpan>[
        TextSpan(
            text: 'Covid',
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
        TextSpan(
            text: 'Survey',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
      ],
    ),
  );
}

Widget appBarAdmin(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 28),
      children: <TextSpan>[
        TextSpan(
            text: 'Covid',
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
        TextSpan(
            text: 'Survey',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
        TextSpan(
            text: 'ADMIN',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green))
      ],
    ),
  );
}

Widget appBarRegistration(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 27),
      children: <TextSpan>[
        TextSpan(
            text: 'Covid',
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
        TextSpan(
            text: 'Survey',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
        TextSpan(
            text: 'Registration',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue))
      ],
    ),
  );
}

Widget appBarResults(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 28),
      children: <TextSpan>[
        TextSpan(
            text: 'Covid',
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
        TextSpan(
            text: 'Survey',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
        TextSpan(
            text: 'Results',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.yellow.shade800))
      ],
    ),
  );
}

Widget blueButton({BuildContext context, String label, buttonWidth}) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(30)),
      alignment: Alignment.center,
      width: buttonWidth != null
          ? buttonWidth
          : MediaQuery.of(context).size.width - 48,
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ));
}
