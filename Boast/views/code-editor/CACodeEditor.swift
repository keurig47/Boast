//
//  CACodeEditor.swift
//  Boast
//
//  Created by David Keimig on 10/2/20.
//

import UIKit

let DURATION = 0.015

class CACodeEditor: CATextLayer, CAAnimationDelegate {
    var _update: ((_ time: Double) -> Void)?
    var currentString: NSAttributedString?
    var currentCharCount: Int = 0
    var linePosition: Int = 0
    var bodyPosition: Int = 0
    var charMask = CAShapeLayer()
    var lineMask = CAShapeLayer()
    var playing: Bool = false
    let lineMaxHeight = 0
    var currCharX: CGFloat = 0
    
    override init() {
        super.init()
        self.frame = CGRect.zero
        self.drawsAsynchronously = true
        self.contentsScale = UIScreen.main.scale
        self.backgroundColor = UIColor.secondarySystemBackground.cgColor
        self.charMask.backgroundColor = UIColor.secondarySystemBackground.cgColor
        self.lineMask.backgroundColor = UIColor.secondarySystemBackground.cgColor
        
        self.addSublayer(self.charMask)
        self.addSublayer(self.lineMask)
        //        self.isWrapped = true
    }
    
    override init(layer: Any) {
        super.init()
        self.frame = CGRect.zero
        self.drawsAsynchronously = true
        self.contentsScale = UIScreen.main.scale
        self.backgroundColor = UIColor.secondarySystemBackground.cgColor
        self.charMask.backgroundColor = UIColor.secondarySystemBackground.cgColor
        self.lineMask.backgroundColor = UIColor.secondarySystemBackground.cgColor
        
        self.addSublayer(self.charMask)
        self.addSublayer(self.lineMask)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSubsubstring() -> NSAttributedString? {
        return self.currentString?.attributedSubstring(from: NSRange(location: 0, length: self.currentCharCount))
    }
    
    func measureCurrentChar() -> CGSize? {
        if (self.currentString?.length)! > (self.currentCharCount + 1) {
            let charRange = NSRange(location: self.currentCharCount, length: 1)
            let char = (self.currentString?.attributedSubstring(from: charRange))!
            let charSize = char.size()
//            var range = NSRange(location: 0, length: self.currentCharCount)
//            let style = self.currentString?.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: &range) as! NSParagraphStyle
            self.currentCharCount = self.currentCharCount + 1
            if (char.string == "\n") {
                self.bodyPosition = self.bodyPosition + 1
                self.linePosition = 0
                self.modifyBody(charSize: charSize)
                return nil
            }
            return charSize
        }
        return nil
    }
    
    func modifyBody(charSize: CGSize) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        CATransaction.setCompletionBlock {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DURATION) {
                self.modifyLine()
            }
        }
        self.charMask.frame = CGRect(x: 0, y: self.charMask.frame.minY + 14.5, width: self.bounds.width, height: 50)
        self.lineMask.frame =
            CGRect(
                x: 0,
                y: self.lineMask.frame.minY + 14.5,
                width: self.lineMask.bounds.width,
                height: self.lineMask.bounds.height - (14.5)
            )
        CATransaction.commit()
    }
    
    func modifyLine() {
        if self._update != nil {
            let totalTime = Double(self.currentString?.length ?? 0) * DURATION
            self._update!(Double(self.currentCharCount))
        }
        let currCharSize: CGSize? = self.measureCurrentChar()
        if currCharSize != nil && self.playing {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DURATION) {
                    self.modifyLine()
                }
            }
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            self.charMask.frame =
                CGRect(
                    x: self.charMask.frame.minX + (currCharSize?.width)!,
                    y: self.charMask.frame.minY,
                    width: self.charMask.bounds.width - (currCharSize?.width)!,
                    height: self.charMask.bounds.height
                )
            CATransaction.commit()
        }
    }
    
    func play() {
        self.modifyLine()
    }
    
    func pause() {
        self.playing = false
        self.currentString = NSAttributedString()
        self.currentCharCount = 0
        self.linePosition = 0
        self.bodyPosition = 0
        self.currCharX = 0
        self.string = self.currentString
    }
    
    func setAttributed(_ newString: NSAttributedString) {
        self.currentString = newString
        if !newString.string.isEmpty && !self.playing {
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            self.charMask.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 50)
            self.lineMask.frame = CGRect(x: 0, y: 14, width: self.bounds.width, height: self.bounds.height)
            self.string = newString
            CATransaction.commit()
            self.playing = true
            self.play()
        }
    }
}
