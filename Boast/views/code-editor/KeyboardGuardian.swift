//
//  KeyboardGuardian.swift
//  Boast
//
//  Created by David Keimig on 8/28/20.
//

import SwiftUI
import Combine
import WebKit

class KeyboardGuardian: ObservableObject {
    @Published public var keyboardRect: CGRect = CGRect()
    @Published public var keyboardIsHidden = true
    private var webview: WKWebView?
    
    func registerWebView(view: WKWebView) {
        webview = view
    }
    
    func unregisterWebView() {
        webview = nil
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardDidHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if keyboardIsHidden {
            keyboardIsHidden = false
            if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
                keyboardRect = rect
            }
        }
    }

    @objc func keyBoardDidHide(notification: Notification) {
        keyboardIsHidden = true
    }
    
    func onThemeChanged(theme: String, save: Bool?) {
        let defaults = UserDefaults.standard
        if webview != nil {
            webview!.evaluateJavaScript("window.onThemeChanged('\(theme)')", completionHandler: nil)
            if save ?? false {
                defaults.set(theme, forKey: Constants.defaultsKey.theme)
            }
        }
    }
    
    func onSyntaxChanged(syntax: String, save: Bool?) {
        let defaults = UserDefaults.standard
        if webview != nil {
            webview!.evaluateJavaScript("window.onSyntaxChanged('\(syntax)')", completionHandler: nil)
            if save ?? false {
                defaults.set(syntax, forKey: Constants.defaultsKey.syntax)
            }
        }
    }
    
    func getValue() {
        if webview != nil {
            webview!.evaluateJavaScript("window.getValue()", completionHandler: nil)
        }
    }
}

struct KeyboardGuardian_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
