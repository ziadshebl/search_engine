import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:search_engine/Constants/Colors.dart';
import 'package:search_engine/Screens/WebViewScreen.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' hide Text;
import 'package:shimmer/shimmer.dart';

class ResultWidget extends StatefulWidget {
  final String url;
  final String word;

  const ResultWidget({Key key, this.url, this.word}) : super(key: key);

  @override
  _ResultWidgetState createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget>
    with AutomaticKeepAliveClientMixin {
  Metadata metadata;
  bool isLoaded = false;
  String body;
  bool found = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    Future.microtask(() async {
      metadata = await extract(widget.url);

      http.Response response = await http.get(widget.url);

      Document document = parse(response.body);

      document.querySelectorAll('p').forEach((value) {
        if (!found &&
            value.innerHtml.toLowerCase().contains(widget.word.toLowerCase())) {
          body = value.text;
          found = true;
        }
      });

      if (!found) {
        body = metadata.description;
      }

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
        ? SizedBox(
            height: 140.0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    height: 30,
                    width: deviceSize.width * 0.3,
                    color: Colors.grey[100],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    height: 30,
                    width: deviceSize.width * 0.4,
                    color: Colors.grey[100],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    height: 60,
                    width: deviceSize.width * 0.9,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(url: widget.url),
                )),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                width: deviceSize.width * 0.95,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: deviceSize.width * 0.9,
                      child: Row(
                        children: [
                          metadata.image != null
                              ? Image.network(
                                  metadata.image,
                                  height: 30,
                                )
                              : Container(),
                          Expanded(
                            // margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            // width: deviceSize.width * 0.7,
                            child: Text(
                              widget.url,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 14),
                            ),
                          )
                        ],
                      ),
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
                            alignment: Alignment.topLeft,
                            width: deviceSize.width * 0.9,
                            child: Text(
                              body,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          )
                        : Container(
                            height: 30,
                          )
                  ],
                ),
              ),
            ),
          );
  }
}
