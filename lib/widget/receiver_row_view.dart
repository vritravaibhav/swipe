import 'package:flutter/material.dart';
import 'package:instagramclone/models/user.dart';
import 'package:intl/intl.dart';

class ReceiverRowView extends StatelessWidget {
  const ReceiverRowView({Key? key, required this.receiverMessage})
      : super(key: key);

  final Map<String, dynamic> receiverMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        StreamBuilder<User>(
            stream: null,
            builder: (context, snapshot) {
              return const Flexible(
                flex: 13,
                fit: FlexFit.tight,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 1.0, bottom: 9.0),
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF90C953),
                    child: Text('X',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ),
              );
            }),
        Flexible(
          flex: 72,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 5.0, right: 8.0, top: 8.0, bottom: 2.0),
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 9.0, bottom: 9.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.blue,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0))
                                .copyWith(topLeft: Radius.zero)),
                    child: Text(
                      receiverMessage['chatData'],
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 8.0),
                child: Text(
                  DateFormat.jm().format(receiverMessage["datetime"].toDate()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 7.0,
                  ),
                ),
              ),
            ],
          ),
          //
        ),
        Flexible(
          flex: 15,
          fit: FlexFit.tight,
          child: Container(
            width: 50.0,
          ),
        ),
      ],
    );
  }
}
