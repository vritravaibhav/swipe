import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SenderRowView extends StatelessWidget {
  const SenderRowView({Key? key, required this.senderMessage})
      : super(key: key);

  final Map<String, dynamic> senderMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          flex: 15,
          fit: FlexFit.tight,
          child: Container(
            width: 50.0,
          ),
        ),
        Flexible(
          flex: 72,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 8.0, right: 5.0, top: 8.0, bottom: 2.0),
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 9.0, bottom: 9.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.blue,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0))
                                .copyWith(topRight: Radius.zero)),
                    child: Text(
                      senderMessage['chatData'],
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 10.0, bottom: 8.0),
                child: Text(
                  DateFormat.jm().format(senderMessage["datetime"].toDate()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.0,
                  ),
                ),
              ),
            ],
          ),
          //
        ),
      ],
    );
  }
}
