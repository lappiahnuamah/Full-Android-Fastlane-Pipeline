import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/app_utils.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SavvyWebView extends StatefulWidget {
  const SavvyWebView(
      {super.key, required this.initialURL, required this.pageTitle});

  final String initialURL;
  final String pageTitle;
  @override
  State<SavvyWebView> createState() => _SavvyWebViewState();
}

class _SavvyWebViewState extends State<SavvyWebView> {
  WebViewController? webViewController;
  late String initialURL;
  double loadingProgress = 0.0;
  late String pageTitle;
  String textFieldInitValue = '';
  @override
  void initState() {
    initWebView();
    super.initState();
  }

  initWebView() {
    pageTitle = "Loading page...";
    initialURL = widget.initialURL;
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            lg("Loading Progress: $progress");
            if (mounted) {
              setState(() {
                loadingProgress = progress / 100;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                pageTitle = "Loading page...";
              });
            }
          },
          onUrlChange: (url) {},
          onPageFinished: (String url) async {
            pageTitle = await webViewController?.getTitle() ?? url;
            if (mounted) {
              setState(() {});
            }
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              loadingProgress = 1.0;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            bool isURLValid = (AppUtils.ipRegex.hasMatch(request.url) ||
                AppUtils.websiteRegex1.hasMatch(request.url) ||
                AppUtils.websiteRegex2.hasMatch(request.url));
            if (!isURLValid) {
              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(initialURL));
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);
    return PageTemplate(
      pageTitle: widget.pageTitle,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: d.pSH(5),
            ),
            if (loadingProgress != 1.0)
              LinearProgressIndicator(
                minHeight: d.pSH(2),
                value: loadingProgress,
                color: AppColors.kPrimaryColor,
                backgroundColor: Colors.transparent,
              ),
            Expanded(
              flex: 7,
              child: webViewController != null
                  ? WebViewWidget(controller: webViewController!)
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  submitRequest(String url, [Map<String, dynamic>? options]) {
    setState(() {
      pageTitle = "Loading page...";
      loadingProgress = 0.0;
    });
    webViewController?.loadRequest(Uri.parse(formatURLRequest(url)));
  }

  String formatURLRequest(String url) {
    if (url.startsWith("https://") || url.startsWith("http://")) {
      return url;
    } else {
      return "https://$url";
    }
  }
}
