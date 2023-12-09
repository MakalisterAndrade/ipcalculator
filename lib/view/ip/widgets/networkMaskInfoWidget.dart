import 'dart:core';

import 'package:flutter/material.dart';
import 'package:ipcalculator/controller/data/NetworkMask.dart';

class NetworkMaskInfoWidget extends StatefulWidget {
  NetworkMaskInfoWidget(this.networkMaskStream);

  final Stream<NetworkMask?> networkMaskStream;

  final _NetworkMaskInfoWidgetState currentNetworkMaskInfoWidgetState =
      _NetworkMaskInfoWidgetState();

  @override
  _NetworkMaskInfoWidgetState createState() {
    return _NetworkMaskInfoWidgetState();
  }
}

class _NetworkMaskInfoWidgetState extends State<NetworkMaskInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetworkMask?>(
        stream: widget.networkMaskStream,
        builder: (BuildContext context, AsyncSnapshot<NetworkMask?> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          final NetworkMask networkMask = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Resultados',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              SelectionArea(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.75,
                      color: Colors.black26
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Table(

                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: networkMask
                          .printNetworkMask()
                          .map((List<String> data) => TableRow(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(2.5),
                                    child: Text(data[0],
                                        maxLines: 1, textScaleFactor: 1.1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.5),
                                    child: Text(data[1],
                                        maxLines: 1, textScaleFactor: 1.1),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
