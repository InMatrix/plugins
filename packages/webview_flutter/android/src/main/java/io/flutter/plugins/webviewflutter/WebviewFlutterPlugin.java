package io.flutter.plugins.webviewflutter;

import io.flutter.plugin.common.PluginRegistry.Registrar;

/** WebviewFlutterPlugin */
public class WebviewFlutterPlugin {
  public static void registerWith(Registrar registrar) {
    registrar.platformViewRegistry().registerViewFactory("webview", new WebViewFactory(registrar.messenger(), registrar.view()));
  }
}
