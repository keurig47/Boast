//
//  WebView.swift
//  Boast
//
//  Created by David Keimig on 8/25/20.
//


import SwiftUI
import WebKit
import SwiftyJSON

class NotificationScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    var kguard: KeyboardGuardian
    var defaultValue: String
    var options: [String: Any]
    var theme: String?
    var syntax: String?
    var editorState: EditorState
    
    init(kguard: KeyboardGuardian, defaultValue: String, options: [String: Any], theme: String?, syntax: String?, editorState: EditorState) {
        self.kguard = kguard
        self.options = options
        self.editorState = editorState
        self.defaultValue = defaultValue
        self.theme = theme
        self.syntax = syntax
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let dataFromString = (message.body as! String).data(using: .utf8, allowLossyConversion: false) {
            do {
                let jsonMessage = try JSON(data: dataFromString)
                if jsonMessage["type"].stringValue == "LOADED" {
                    self._load(jsonMessage: jsonMessage, message: message)
                }
                else if jsonMessage["type"].stringValue == "VALUE" {
                    self._setValue(jsonMessage: jsonMessage, message: message)
                }
                else if jsonMessage["type"].stringValue == "THEME" {
                    self._theme(jsonMessage: jsonMessage)
                }
            }
            catch {
                print("Error decoding json from web server")
            }
        }
    }
    
    func _load(jsonMessage: JSON, message: WKScriptMessage) {
        let defaults = UserDefaults.standard
        
        if var restoredTheme = defaults.string(forKey: Constants.defaultsKey.theme) {
            if theme != nil {
                restoredTheme = theme ?? restoredTheme
            }
            editorState.theme = restoredTheme
            kguard.onThemeChanged(theme: restoredTheme, save: false)
        }

        if var restoredSynatx = defaults.string(forKey: Constants.defaultsKey.syntax) {
            if syntax != nil {
                restoredSynatx = syntax ?? restoredSynatx
            }
            editorState.syntax = restoredSynatx
            kguard.onSyntaxChanged(syntax: restoredSynatx, save: false)
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: options, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            guard let json = try? JSONEncoder().encode(defaultValue),
                  let jsonDefaultValue = String(data: json, encoding: .utf8) else {
                return
            }
            message.webView?.evaluateJavaScript("window.setDefaultValue(\(jsonDefaultValue))", completionHandler: nil)
            message.webView?.evaluateJavaScript("window.onOptionsChanged(\(jsonString))", completionHandler: nil)
        } catch {
            print("Error, failed to encode options data")
        }
    }
    
    func _setValue(jsonMessage: JSON, message: WKScriptMessage) {
        editorState.editorValue = jsonMessage["value"].stringValue
    }
    
    func _theme(jsonMessage: JSON) {
        let bgColor = jsonMessage["backgroundColor"].stringValue
        let color = jsonMessage["color"].stringValue
        editorState.backgroundColor = self.color2UIColor(color: bgColor)
        editorState.color = self.color2UIColor(color: color)
    }
    
    func color2UIColor(color: String) -> UIColor {
        var tempColor = color.replacingOccurrences(of: "rgb(", with: "")
        tempColor = tempColor.replacingOccurrences(of: ")", with: "")
        let colorParts = tempColor.split(separator: ",")
        let r = CGFloat(Float(colorParts[0].trimmingCharacters(in: .whitespaces))! / 255.0)
        let g = CGFloat(Float(colorParts[1].trimmingCharacters(in: .whitespaces))! / 255.0)
        let b = CGFloat(Float(colorParts[2].trimmingCharacters(in: .whitespaces))! / 255.0)
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}

struct WebView: UIViewRepresentable {
    
    var kguard: KeyboardGuardian
    var defaultValue: String
    var options: [String: Any] = [:]
    var isUserInteractionEnabled: Bool = true
    var theme: String?
    var syntax: String?

    @Binding var loading: Bool
    @EnvironmentObject var editorState: EditorState
    
    func _setup(wkwebview: WKWebView) {
        wkwebview.scrollView.isScrollEnabled = true
        wkwebview.scrollView.bounces = false
        wkwebview.allowsBackForwardNavigationGestures = false
        wkwebview.contentMode = .scaleToFill
        wkwebview.isOpaque = false
        wkwebview.backgroundColor = UIColor.clear
        wkwebview.scrollView.backgroundColor = UIColor.clear
        wkwebview.scrollView.showsHorizontalScrollIndicator = false
        wkwebview.scrollView.showsVerticalScrollIndicator = false
        wkwebview.isUserInteractionEnabled = self.isUserInteractionEnabled
    }
    
    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        coordinator.parent.kguard.unregisterWebView()
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        let controller = WKUserContentController()
        editorState.register(kguard: kguard)
        let handler = NotificationScriptMessageHandler(
            kguard: kguard,
            defaultValue: defaultValue,
            options: options,
            theme: theme,
            syntax: syntax,
            editorState: editorState
        )
        controller.add(handler, name: "default")
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        let wkwebview = WKWebView(frame: CGRect.zero, configuration: config)
        self._setup(wkwebview: wkwebview)
        wkwebview.navigationDelegate = context.coordinator
        var dirUrl = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "build")
        dirUrl?.deleteLastPathComponent()
        let fileUrl = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "build")!
        wkwebview.loadFileURL(fileUrl, allowingReadAccessTo: dirUrl!)
        kguard.registerWebView(view: wkwebview)
        print("MAKING WEB VIEW")
        return wkwebview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ webView: WebView) {
            self.parent = webView
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.parent.loading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            self.parent.loading = false
        }
    }
    
}

struct WebView_Previews: PreviewProvider {
    
    static var previews: some View {
        WebView(kguard: KeyboardGuardian(), defaultValue: "", options: [:], loading: .constant(true))
    }
}
