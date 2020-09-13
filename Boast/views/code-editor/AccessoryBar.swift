//
//  AccessoryBar.swift
//  Boast
//
//  Created by David Keimig on 8/28/20.
//

import SwiftUI
import QuartzCore

class Chooser: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerData: [String] = []
    var onSelection: (String, Bool?) -> () = {_,_  in }
    var picker: UIPickerView
    
    override init(frame: CGRect) {
        self.picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 1, height: 343))
        super.init(frame: frame)
        self.picker.dataSource = self
        self.picker.delegate = self
        self.inputView = picker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIcon(systemName: String) {
        self.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        imageView.contentMode = .center
        let image = UIImage(systemName: systemName)
        imageView.image = image
        self.leftView = imageView
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DispatchQueue.main.async {
            self.onSelection(self.pickerData[row], true)
            self.text = self.pickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let result = pickerData[row]
        return result
    }
    
    func setData(data: [String]) {
        self.pickerData = data
    }
    
    func setDefault(defaultValue: String) {
        guard let index = pickerData.firstIndex(of: defaultValue) else { return }
        self.picker.selectRow(index, inComponent: 0, animated: false)
        let selection = pickerData[index]
        self.text = selection
    }
}

struct AccessoryBar: UIViewRepresentable {
    
    var geometry: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    @Binding var keyboardRect: CGRect
    var kguard: KeyboardGuardian
    var bar: UIToolbar = UIToolbar()
    var themeChooser: Chooser = Chooser(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
    var syntaxChooser: Chooser = Chooser(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
    
    func makeUIView(context: Context) -> UIToolbar {
        themeChooser.setData(data: Constants.themes)
        themeChooser.setIcon(systemName: "paintpalette")
        themeChooser.onSelection = kguard.onThemeChanged
 
        syntaxChooser.setData(data: Constants.languages)
        syntaxChooser.setIcon(systemName: "quote.bubble")
        syntaxChooser.onSelection = kguard.onSyntaxChanged
        
        let defaults = UserDefaults.standard
        if let theme = defaults.string(forKey: Constants.defaultsKey.theme) {
            themeChooser.setDefault(defaultValue: theme)
        }
        if let syntax = defaults.string(forKey: Constants.defaultsKey.syntax) {
            syntaxChooser.setDefault(defaultValue: syntax)
        }
        
        bar.isUserInteractionEnabled = true
        bar.setItems([
            UIBarButtonItem(customView: themeChooser),
            UIBarButtonItem(customView: syntaxChooser),
        ], animated: true)
                
        return bar
    }
    
    func updateUIView(_ uiView: UIToolbar, context: Context) {
        bar.sizeToFit()
        self.themeChooser.frame = CGRect(x: 0, y: 0, width: geometry.width/2, height: 44)
        self.themeChooser.picker.frame = CGRect(x: 0, y: 0, width: keyboardRect.width, height: keyboardRect.height)
        self.syntaxChooser.frame = CGRect(x: 0, y: 0, width: geometry
                                            .width/2, height: 44)
        self.syntaxChooser.picker.frame = CGRect(x: 0, y: 0, width: keyboardRect.width, height: keyboardRect.height)
    }
    
}

//struct AccessoryBar_Previews: PreviewProvider {
//    static var previews: some View {
//        AccessoryBar(kguard: KeyboardGuardian())
//    }
//}
