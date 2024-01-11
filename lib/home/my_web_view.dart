import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:government_services/home/home_provider.dart';
import 'package:provider/provider.dart';

class MyWebView extends StatefulWidget {
  final String url;

  const MyWebView({super.key, required this.url});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
          pullToRefreshController?.endRefreshing();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Web View")),
      body: Column(
        children: [
          Consumer<NetProvider>(
            builder: (context, value, child) => OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                if (value.canGoBack)
                  IconButton(
                      onPressed: () {
                        webViewController?.goBack();
                      },
                      icon: Icon(Icons.arrow_left)),
                if (!value.canGoBack) SizedBox(),
                if (value.canGoForward)
                  IconButton(
                      onPressed: () {
                        webViewController?.goForward();
                      },
                      icon: Icon(Icons.arrow_right)),
              ],
            ),
          ),
          Consumer<NetProvider>(
            builder: (context, netProvider, child) {
              if (netProvider.progress >= 1) {
                return SizedBox.shrink();
              }
              return LinearProgressIndicator(
                minHeight: 8,
                value: netProvider.progress,
                color: Colors.yellow,
              );
            },
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              pullToRefreshController: pullToRefreshController,
              onLoadStop: (controller, url) async {
                var canGoBack = await controller.canGoBack();
                var canGoForward = await controller.canGoForward();
                print("mounted $mounted");

                if (mounted) {
                  Provider.of<NetProvider>(context, listen: false).backForwardStatus(canGoBack, canGoForward);
                }

                print("canGoBack $canGoBack");
              },
              onProgressChanged: (controller, progress) {
                Provider.of<NetProvider>(context, listen: false).changeProgress(progress / 100);
                print("progress => $progress");
              },
            ),
          ),
          Container(
            child: TextFormField(
              decoration: InputDecoration(hintText: "Search"),
              onFieldSubmitted: (value) {
                var searchText = "https://www.google.com/search?q=$value";
                webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(searchText)));
                print("Entered Text $value");
              },
            ),
          )
        ],
      ),
    );
  }
}
