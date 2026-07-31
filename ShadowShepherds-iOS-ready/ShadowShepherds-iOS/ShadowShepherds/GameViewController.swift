import UIKit
import WebKit

final class GameViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!

    override var prefersHomeIndicatorAutoHidden: Bool { true }
    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { .landscapeRight }

    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.043, green: 0.051, blue: 0.094, alpha: 1.0)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = false

        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBundledGame()
    }

    private func loadBundledGame() {
        guard
            let htmlURL = Bundle.main.url(
                forResource: "shadow-shepherds",
                withExtension: "html",
                subdirectory: "Web"
            ),
            let webDirectory = Bundle.main.url(forResource: "Web", withExtension: nil)
        else {
            showFatalLoadError()
            return
        }

        webView.loadFileURL(htmlURL, allowingReadAccessTo: webDirectory)
    }

    private func showFatalLoadError() {
        let html = """
        <!doctype html>
        <html>
        <head><meta name="viewport" content="width=device-width, initial-scale=1"></head>
        <body style="background:#0b0d18;color:#ffcc66;font-family:-apple-system;padding:24px;">
        <h1>Shadow Shepherds failed to load</h1>
        <p>The bundled game files are missing from the app target resources.</p>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        // Keep the game self-contained. Block unexpected external navigation.
        if navigationAction.navigationType == .other || navigationAction.request.url?.isFileURL == true {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
}
