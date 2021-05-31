import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:search_engine/Constants/Colors.dart';

class ResultWidget extends StatefulWidget {
  final String url;

  const ResultWidget({Key key, this.url}) : super(key: key);

  @override
  _ResultWidgetState createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  Metadata metadata;
  bool isLoaded = false;
  @override
  void initState() {
    Future.microtask(() async {
      metadata = await extract(widget.url);
      setState(() {
        isLoaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return !isLoaded
        ? Container()
        : Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
              width: deviceSize.width * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      metadata.image != null
                          ? Image.network(
                              metadata.image,
                              height: 30,
                            )
                          : Container(),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        width: deviceSize.width * 0.7,
                        child: Text(
                          widget.url,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  metadata.title != null
                      ? Container(
                          width: deviceSize.width * 0.7,
                          child: Text(
                            metadata.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: ConstantColors.blue, fontSize: 16),
                          ),
                        )
                      : Container(
                          height: 30,
                        ),
                  metadata.description != null
                      ? Container(
                          width: deviceSize.width * 0.9,
                          child: Text(
                            metadata.description,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        )
                      : Container(
                          height: 30,
                        )
                ],
              ),
            ),
          );
  }
}
