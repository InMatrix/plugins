import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class WebController {
  void loadUrl(String url);
}

class WebControllerCompleter {
  factory WebControllerCompleter() {
    final Completer<WebController> completer = new Completer<WebController>();
    return new WebControllerCompleter._(completer , completer.future);
  }

  WebControllerCompleter._(this._completer, this.future);

  Completer<WebController> _completer;
  final Future<WebController> future;
}

class WebView extends StatefulWidget {

  const WebView({
    Key key,
    this.initialUrl,
    this.webController
  }) : super(key: key);

  final String initialUrl;
  final WebControllerCompleter webController;

  @override
  State createState() => _WebWidgetState();

}

class _WebWidgetState extends State<WebView> implements WebController {

  int viewId;
  MethodChannel methodChannel;
  String loadUrlTarget;

  @override
  Widget build(BuildContext context) {
    return PlatformView(
      id: viewId,
      viewType: 'webview',
      platformViewCreated: onPlatformViewCreated,
    );
  }

  @override
  void initState() {
    super.initState();
    viewId = platformViewRegistry.getNextPlatformViewId();
    methodChannel = new MethodChannel('webview_flutter/$viewId');
  }

  void onPlatformViewCreated(int id) {
    assert(id == viewId);
    widget?.webController?._completer?.complete(this);
    if (loadUrlTarget != null || widget.initialUrl != null)
      methodChannel.invokeMethod('loadUrl', loadUrlTarget ?? widget.initialUrl);
  }

  @override
  void loadUrl(String url) {
    loadUrlTarget = url;
    if (methodChannel == null) {
      return;
    }
    methodChannel.invokeMethod('loadUrl', url);
  }
}
