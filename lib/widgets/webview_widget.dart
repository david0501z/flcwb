import 'package:fl_clash/common/proxy.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebViewWidget extends ConsumerStatefulWidget {
  final String initialUrl;
  final Function(String)? onPageStarted;
  final Function(String)? onPageFinished;
  final Function(String)? onUrlChanged;
  final bool enableProxy;

  const WebViewWidget({
    super.key,
    required this.initialUrl,
    this.onPageStarted,
    this.onPageFinished,
    this.onUrlChanged,
    this.enableProxy = true,
  });

  @override
  ConsumerState<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends ConsumerState<WebViewWidget> {
  late String _currentUrl;
  late String _loadingUrl;
  bool _isLoading = false;
  final TextEditingController _urlController = TextEditingController();
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl;
    _loadingUrl = widget.initialUrl;
    _urlController.text = widget.initialUrl;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _loadUrl(String url) {
    String formattedUrl = url;
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }

    setState(() {
      _loadingUrl = formattedUrl;
    });

    if (_webViewController != null) {
      _webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(formattedUrl)));
      widget.onUrlChanged?.call(formattedUrl);
    }
  }

  void _goBack() {
    if (_webViewController != null) {
      _webViewController!.goBack();
    }
  }

  void _goForward() {
    if (_webViewController != null) {
      _webViewController!.goForward();
    }
  }

  void _refresh() {
    if (_webViewController != null) {
      _webViewController!.reload();
    }
  }

  // 获取当前代理状态
  bool _isProxyEnabled() {
    final proxyState = ref.read(proxyStateProvider);
    return proxyState.isStart && proxyState.systemProxy;
  }

  // 获取代理端口
  int _getProxyPort() {
    final proxyState = ref.read(proxyStateProvider);
    return proxyState.port;
  }

  @override
  Widget build(BuildContext context) {
    final proxyState = ref.watch(proxyStateProvider);
    final isProxyEnabled = proxyState.isStart && proxyState.systemProxy;
    final proxyPort = proxyState.port;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBack,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _goForward,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refresh,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _urlController,
                    onSubmitted: _loadUrl,
                    decoration: const InputDecoration(
                      hintText: '输入网址',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.navigate_next),
                onPressed: () => _loadUrl(_urlController.text),
              ),
            ],
          ),
        ),
        Expanded(
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _loadingUrl = url.toString();
                _isLoading = true;
              });
              widget.onPageStarted?.call(url.toString());
              widget.onUrlChanged?.call(url.toString());
            },
            onLoadStop: (controller, url) async {
              setState(() {
                _currentUrl = url.toString();
                _isLoading = false;
              });
              widget.onPageFinished?.call(url.toString());
              
              // 更新地址栏URL
              _urlController.text = url.toString();
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                _isLoading = false;
              });
              print('WebView error: $message');
            },
            onProgressChanged: (controller, progress) {
              // 可以添加进度条显示
            },
            initialOptions: InAppWebViewGroupOptions(
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
              ),
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}