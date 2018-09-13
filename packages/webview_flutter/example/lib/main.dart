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
        title: GestureDetector(
            onLongPress: (){
              print("long pressed.");
            },
            child: const Text('Flutter WebView Demo')),
        bottom: new TabBar(
          controller: tabController,
          tabs: tabs.map((String url) => new Tab(text: url)).toList(),
        ),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          InfoButton(),
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
  List<Widget> web_views = <Widget>[];

  @override
  void initState() {
    if (widget.url2 != null) {
      web_views.addAll([
        FadeWebView(
          url: widget.url2,
          opacityLevel: 1.0,
        ),
        FadeWebView(
          url: widget.url1,
          opacityLevel: 1.0,
        ),
      ]);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.url2 != null) {
      return Stack(
        children: web_views,
      );
    } else {
      return MyWebView(url: widget.url1);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class MyWebView extends StatelessWidget {
  MyWebView({Key key, this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
      javaScriptMode: JavaScriptMode.unrestricted,
      gestureRecognizers: <OneSequenceGestureRecognizer>[
        new VerticalDragGestureRecognizer(),
        new TapGestureRecognizer()
      ],
    );
  }
}

class FadeWebView extends StatefulWidget {
  FadeWebView({Key key, this.url, this.opacityLevel}) : super(key: key);

  final String url;
  final double opacityLevel;

  @override
  _FadeWebViewState createState() => _FadeWebViewState();
}

class _FadeWebViewState extends State<FadeWebView> {
  double opacityLevel;

  @override
  void initState() {
    opacityLevel = widget.opacityLevel;
    super.initState();
  }

  void _changeOpacity(ScaleEndDetails s) {

    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleEnd: _changeOpacity,
      child: AnimatedOpacity(
        opacity: opacityLevel,
        duration: new Duration(seconds: 3),
        child: MyWebView(url: widget.url),
      ),
    );
  }
}

class InfoButton extends StatefulWidget {
  @override
  InfoButtonState createState() {
    return new InfoButtonState();
  }
}

class InfoButtonState extends State<InfoButton> {
  bool bookmarked = false;
  String message = "";

  @override
  Widget build(BuildContext context) {

    return IconButton(
      icon: Icon(Icons.info),
      onPressed: _showDialog,
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Flutter WebView Demo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("这个对话框是Flutter的组件。"),
              FlutterLogo(style: FlutterLogoStyle.horizontal, size: 80.0,),
              Text("下面这个WebView是安卓自带的。"),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
