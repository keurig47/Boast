//
//  HighlightJSView.swift
//  Boast
//
//  Created by David Keimig on 9/24/20.
//

import Foundation
import SwiftUI
import UIKit
import JavaScriptCore

class CAViewContainer: UIView {
    var onUpdate: ((_ time: Double) -> ())?
    let editor = CACodeEditor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(editor)
        self.editor._update = self._update
    }
        
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        self.editor.frame = self.frame
        CATransaction.commit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func _update(time: Double) {
        if self.onUpdate != nil {
            self.onUpdate!(time)
        }
    }
    
    func setAttributed(_ string: NSAttributedString) {
        self.editor.setAttributed(string)
    }
    
    func pause() {
        self.editor.pause()
    }
    
}

class Highlighter: ObservableObject {
    var jscontext: JSContext
    var theme: Theme?
    var currentCSS: String = ""
    @Published var attributedString: NSAttributedString = NSAttributedString()
    
    init() {
        self.jscontext = JSContext()!
        guard let url = Bundle.main.url(forResource: "main", withExtension: "js", subdirectory: "dist") else {
            fatalError("missing resource highlight.js")
        }
        do {
            jscontext.evaluateScript(try String(contentsOf: url),
                                   withSourceURL: url)
            let css = jscontext.objectForKeyedSubscript("hljsCSS")
                                .forProperty("css")
            self.currentCSS = css?.toString() ?? ""
            self.setTheme(to: "monokai")
        } catch {
            print("Error starting highlighter")
        }
    }

    private func safeMainSync(_ block: @escaping ()->()) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync { block() }
        }
    }
    
    func setTheme(to name: String) {
        guard let defTheme = Bundle.main.path(forResource: name+".min", ofType: "css", inDirectory: "highlightr/styles") else { return }
        let themeString = try! String.init(contentsOfFile: defTheme)
        self.theme = Theme(themeString: themeString)
    }
    
    func highlight(text: String, theme: String? = nil, language: String? = nil) -> NSAttributedString {
        let currentLanguage = language != nil ? language : "swift"
        if (theme != nil) {
            self.setTheme(to: theme!)
        } else {
            self.setTheme(to: "monokai")
        }
        let html = jscontext.objectForKeyedSubscript("hljs")
                            .objectForKeyedSubscript("highlight")
                            .call(withArguments: [currentLanguage!, text])?
                            .forProperty("value")
        if html != nil {
            let currentText = html?.toString()
            let themeString: String = (self.theme!.lightTheme ?? "")
            let formattedString = "<style type=\"text/css\">"+themeString+"</style><pre><code class=\"hljs\">"+currentText!+"</code></pre>"
            let data = formattedString.data(using: .utf8)
            if !data!.isEmpty {
                do {
                    return try NSMutableAttributedString(data: data!, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
                } catch {
                    print("Error getting value")
                }
            }
        }
        return NSAttributedString()
    }
    
    @objc
    func languages() -> [String] {
        let res = jscontext
            .objectForKeyedSubscript("hljs")
            .objectForKeyedSubscript("listLanguages")
            .call(withArguments: [])
        return res!.toArray() as! [String]
    }
    
    func themes() -> [Theme] {
        let fileManager = FileManager.default
        let stylesUrl = Bundle.main.resourcePath! + "/highlightr/styles"
        do {
            let fileURLs = try fileManager.contentsOfDirectory(atPath: stylesUrl)
            return fileURLs.map { value in
                let themeName = value.components(separatedBy: ".min.css")[0]
                let defTheme = Bundle.main.path(forResource: themeName+".min", ofType: "css", inDirectory: "highlightr/styles")
                let themeString = try! String.init(contentsOfFile: defTheme!)
                return Theme(themeString: themeString, themeName: themeName)
            }
        } catch {
            print("Error while enumerating files")
        }
        return []
    }
}

struct HighlightJSView: UIViewRepresentable {
    var defaultValue: String?
    let textView = UITextView()
    @Binding var currString: String
    
    func makeUIView(context: UIViewRepresentableContext<HighlightJSView>) -> UITextView {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        let segmentItems = ["Keyboard", "Languages", "Themes", "Settings"]
        let control = UISegmentedControl(items: segmentItems)
        control.addUnderlineForSelectedSegment()
        control.frame = CGRect(x: 0, y: 0, width: 50, height: 35)
        control.addTarget(context.coordinator, action: #selector(Coordinator.segmentControl(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        let maximize = UIImage(systemName: "rectangle.expand.vertical")
        button.setImage(maximize, for: .normal)
        button.addTarget(context.coordinator, action: #selector(Coordinator.onToggle(_:)), for: .touchDown)
        bar.items = [UIBarButtonItem(customView: control), UIBarButtonItem(customView: button)]
        bar.sizeToFit()
        if self.defaultValue != nil {
            textView.attributedText = highlighterTool.highlight(text: self.defaultValue!)
        }
        textView.inputAccessoryView = bar
        textView.isUserInteractionEnabled = true
        textView.isEditable = true
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.backgroundColor = .secondarySystemBackground
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {

    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var keyboardSize: CGRect = CGRect.zero
        var parent: HighlightJSView
        var currentText: String = ""
        var keyboardView = UIView()
        var currentKeyboardView: UIHostingController<KeyboardRoot>
        let keyboardDelegate: KeyboardDelegate
        var theme: String?
        var language: String?

        init(_ parent: HighlightJSView) {
            let delegate = KeyboardDelegate()
            self.parent = parent
            self.keyboardDelegate = delegate
            self.currentKeyboardView = UIHostingController(rootView: KeyboardRoot(delegate: delegate))
            super.init()
            keyboardDelegate.onThemeChanged = self.onThemeChanged
            keyboardDelegate.onLanguageChanged = self.onLanguageChanged
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        
        @objc func keyBoardWillShow(notification: Notification) {
            if var keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.keyboardSize == CGRect.zero {
                    keyboardSize.size.height = keyboardSize.height - (UIApplication.shared.windows.first?.safeAreaInsets.top)!
                    self.keyboardSize = keyboardSize
                }
            }
        }
        
        func changeView() {
            if (self.currentKeyboardView.view != nil) {
                self.currentKeyboardView.view.removeFromSuperview()
            }
            self.currentKeyboardView = UIHostingController(rootView: KeyboardRoot(delegate: self.keyboardDelegate))
            self.keyboardView = UIView()
            self.keyboardView.frame = self.keyboardSize
            self.currentKeyboardView.view.frame = CGRect(x: 0, y: 0, width: self.keyboardSize.width, height: self.keyboardSize.height)
            self.keyboardView.addSubview(self.currentKeyboardView.view)
            self.parent.textView.inputView = self.keyboardView
            self.parent.textView.reloadInputViews()
        }
        
        @objc func onToggle(_: Any) {
            self.keyboardView = UIView()
            self.keyboardDelegate.fullscreen = !self.keyboardDelegate.fullscreen
            if self.keyboardDelegate.fullscreen {
                let window = UIApplication.shared.windows.first
                let fullHeight = (UIScreen.main.bounds.height - (window?.safeAreaInsets.top)!) - 35
                self.keyboardView.frame = CGRect(x: 0, y: 0, width: self.keyboardSize.width, height: fullHeight)
                self.currentKeyboardView.view.frame = CGRect(x: 0, y: 0, width: self.keyboardSize.width, height: fullHeight)
            } else {
                self.keyboardView.frame = CGRect(x: 0, y: 0, width: self.keyboardSize.width, height: self.keyboardSize.height)
                self.currentKeyboardView.view.frame = CGRect(x: 0, y: 0, width: self.keyboardSize.width, height: self.keyboardSize.height)
            }
            self.keyboardView.addSubview(self.currentKeyboardView.view)
            self.parent.textView.inputView = self.keyboardView
            self.parent.textView.reloadInputViews()
        }
        
        func onThemeChanged(theme: String) {
            let textView = self.parent.textView
            self.theme = theme
            let currentText = textView.text
            let attributedText = highlighterTool.highlight(text: currentText!, theme: theme, language: self.language)
            guard let defTheme = Bundle.main.path(forResource: theme+".min", ofType: "css", inDirectory: "highlightr/styles") else { return }
            let themeString = try! String.init(contentsOfFile: defTheme)
            let currTheme = Theme(themeString: themeString)
            let selectedRange = textView.selectedRange
            textView.isScrollEnabled = false
            textView.attributedText = attributedText
            textView.backgroundColor = currTheme.themeBackgroundColor
            textView.selectedRange = selectedRange
            textView.isScrollEnabled = true
        }
        
        func onLanguageChanged(language: String) {
            let textView = self.parent.textView
            let currentText = textView.text
            self.language = language
            textView.attributedText = highlighterTool.highlight(text: currentText!, theme: self.theme, language: language)
        }
        
        @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
            segmentedControl.changeUnderlinePosition()
            switch (segmentedControl.selectedSegmentIndex) {
                case 0:
                    self.parent.textView.inputView = nil
                    self.parent.textView.reloadInputViews()
                break
                case 1:
                    self.keyboardDelegate.view = "languages"
                    self.changeView()
                break
                case 2:
                    self.keyboardDelegate.view = "themes"
                    self.changeView()
                break
                case 3:
                    self.keyboardDelegate.view = "settings"
                    self.changeView()
                break
                default:
                break
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let selectedRange = textView.selectedRange
            let attrStr = highlighterTool.highlight(text: textView.text)
            textView.isScrollEnabled = false
            textView.attributedText = attrStr
            textView.selectedRange = selectedRange
            textView.isScrollEnabled = true
            self.parent.currString = attrStr.string
        }
    }
}

extension NSAttributedString {

    var trailingNewlineChopped: NSAttributedString {
        if string.hasSuffix("\n") {
            return self.attributedSubstring(from: NSRange(location: 0, length: length - 1))
        } else {
            return self
        }
    }
    
}

extension UISegmentedControl{
    
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.clear.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.clear.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)], for: .selected)
    }

    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineFrame = CGRect(x: 0, y: 30, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(Color.accentColor)
        underline.tag = 1
        underline.layer.zPosition = 999
        self.layer.zPosition = 999
        self.bringSubviewToFront(underline)
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage{

    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
