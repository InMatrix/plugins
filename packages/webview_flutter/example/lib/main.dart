// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(home: new WebViewExample()));

class WebViewExample extends StatefulWidget {
  @override
  State createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  final List<String> tabs = <String>[
    'https://www.google.cn/intl/cn/events/developerdays2018/',
    'https://flutter.io',
  ];

  static const String flutter_cn_url = 'https://flutter-io.cn';

  List<String> bookmarks = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        bottom: new TabBar(
          controller: tabController,
          tabs: tabs.map((String url) => new Tab(text: url)).toList(),
        ),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          BookmarkButton(),
        ],
      ),
      body: new TabBarView(
        controller: tabController,
        children: <Widget>[
          AnimatedWebViewTab(url1: tabs[0]),
          AnimatedWebViewTab(url1: tabs[1], url2: flutter_cn_url),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: tabs.length, vsync: this);
  }
}

class AnimatedWebViewTab extends StatefulWidget {
  AnimatedWebViewTab({Key key, this.url1, this.url2}) : super(key: key);

  final String url1;
  final String url2;

  @override
  _AnimatedWebViewTabState createState() => _AnimatedWebViewTabState();
}

class _AnimatedWebViewTabState extends State<AnimatedWebViewTab>
    with AutomaticKeepAliveClientMixin {
  bool _first = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(widget.url2 != null) {
      return GestureDetector(
        onDoubleTap: () {
          setState(() {
            _first = !_first;
          });
        },
        child: AnimatedCrossFade(
          duration: const Duration(seconds: 3),
          firstChild: getWebView(widget.url1),
          secondChild: getWebView(widget.url2),
          crossFadeState:
          _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      );
    } else {
      return getWebView(widget.url1);
    }
  }

  Widget getWebView(String url){
    return WebView(
      initialUrl: url,
      javaScriptMode: JavaScriptMode.unrestricted,
      gestureRecognizers: <OneSequenceGestureRecognizer>[
        new VerticalDragGestureRecognizer()
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BookmarkButton extends StatefulWidget {
  @override
  BookmarkButtonState createState() {
    return new BookmarkButtonState();
  }
}

class BookmarkButtonState extends State<BookmarkButton> {
  bool bookmarked = false;
  String message = "";

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(bookmarked ? Icons.favorite : Icons.favorite_border),
      onPressed: () {
        if (bookmarked) {
          setState(() {
            message = "Unbookmarked";
            bookmarked = false;
          });
        } else {
          setState(() {
            message = "Bookmarked";
            bookmarked = true;
          });
        }
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }
}
