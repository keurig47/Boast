//
//  SCNCodeEditor.swift
//  Boast
//
//  Created by David Keimig on 10/6/20.
//

import SpriteKit
import SwiftUI
import Foundation

class EditorHUD: SKNode {
    var currentProgress: CGFloat = 0 {
        didSet {
            let scale = SKAction.scaleX(to: self.currentProgress, duration: 0)
            self.progress.run(scale)
        }
    }
    let thumb = SKShapeNode(circleOfRadius: 4)
    let progress = SKShapeNode(rect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 100, height: 8), cornerRadius: 4)
    let slider = SKShapeNode(rect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 100, height: 8), cornerRadius: 4)
    
    override init() {
        super.init()
        thumb.fillColor = UIColor(Color.primary)
        thumb.name = "thumb"
        thumb.zPosition = 12
        thumb.position = CGPoint(x: -((UIScreen.main.bounds.size.width - 100) / 2), y: -(UIScreen.main.bounds.size.height / 2) + 104)
        
        slider.fillColor = UIColor(Color.primary.opacity(0.5))
        slider.zPosition = 10
        slider.position = CGPoint(x: -((UIScreen.main.bounds.size.width - 100) / 2), y: -(UIScreen.main.bounds.size.height / 2) + 100)
        slider.alpha = 0.75
        slider.lineWidth = 0
        slider.strokeColor = UIColor(Color.primary.opacity(0.5))
        
        progress.fillColor = UIColor(Color.accentColor)
        progress.zPosition = 11
        progress.position = CGPoint(x: -((UIScreen.main.bounds.size.width - 100) / 2), y: -(UIScreen.main.bounds.size.height / 2) + 100)
        progress.xScale = 0
        progress.alpha = 0.75
        progress.strokeColor = .clear
        progress.lineWidth = 0
        self.createSideBarIcon(systemName: "heart.fill", height: 340)
        self.createSideBarIcon(systemName: "message.fill", height: 260)
        self.createSideBarIcon(systemName: "paperplane.fill", height: 180)
        
        self.addChild(thumb)
        self.addChild(progress)
        self.addChild(slider)
    }
    
    func createSideBarIcon(systemName: String, height: Int) {
        let icon = UIImage(systemName: systemName)!.withTintColor(UIColor(Color.primary))
        let data = icon.pngData()
        let image = UIImage(data: data!)
        let texture = SKTexture(image: image!)
        let node = SKSpriteNode(texture: texture, size: CGSize(width: 45, height: 40))
        
        node.zPosition = 12
        node.position = CGPoint(x: UIScreen.main.bounds.size.width/2 - 50, y: -(UIScreen.main.bounds.size.height / 2) + CGFloat(height))
        
        self.addChild(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(progress: CGFloat) {
        self.currentProgress = progress
    }
}

class SCNCodeEditorScene: SKScene {
    let cameraNode = SKCameraNode()
    let label = SKLabelNode()
    let lineMask = SKSpriteNode()
    let bodyMask = SKSpriteNode()
    let hud = EditorHUD()
    
    var attributedString: NSAttributedString?
    var currentCharCount: Int = 0
    var currentLine: Int = 0
    var startingNewline: Bool = true
    var typeUpdate: Double = 0
    var frameUpdate: Double = 0
    var playState: Bool = false
    var selectedThumb: SKNode?
    var charRanges: [(Int, Int)] = []
    var disableCamera: Bool = false
    
    override init() {
        super.init()
        self.setup()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
        
    func setup() {
        cameraNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        
        label.numberOfLines = 0
        label.verticalAlignmentMode = .top
        label.horizontalAlignmentMode = .left
        label.position = CGPoint(x: 0, y: 800)
        
        lineMask.position = CGPoint(x: 0, y: 800)
        lineMask.anchorPoint = CGPoint(x: 0, y: 1)
        lineMask.size = CGSize(width: UIScreen.main.bounds.size.width, height: 14)
        lineMask.color = .secondarySystemBackground
        
        bodyMask.position = CGPoint(x: 0, y: 786)
        bodyMask.anchorPoint = CGPoint(x: 0, y: 1)
        bodyMask.size = CGSize(width: UIScreen.main.bounds.size.width * 2, height: 786)
        bodyMask.color = .secondarySystemBackground
                
        self.addChild(cameraNode)
        self.addChild(label)
        self.addChild(lineMask)
        self.addChild(bodyMask)
        
        cameraNode.addChild(hud)
        
        self.camera = cameraNode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.disableCamera = true
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes {
                if node.name == "thumb" {
                    self.selectedThumb = node
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.selectedThumb != nil {
            let touch = touches.first
            self.adjustSlider(touch: touch!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.disableCamera = false
        self.selectedThumb = nil
    }
    
    override func didMove(to view: SKView) {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp(sender:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(sender:)))
        swipeUp.direction = .up
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeDown(sender: UISwipeGestureRecognizer) {
        print("SWIPE DOWN")
    }
    
    @objc func swipeUp(sender: UISwipeGestureRecognizer) {
        print("SWIPE UP")
    }
    
    func adjustSlider(touch: UITouch) {
        var position = touch.location(in: self)
        position.y = 104
        if position.x > 50 &&
            position.x < (UIScreen.main.bounds.width) - 50 {
            let totalProgress = UIScreen.main.bounds.width - 100
            let totalCount = CGFloat(self.attributedString?.length ?? 0)
            self.currentCharCount = Int(totalCount * (CGFloat(position.x - 50) / CGFloat(totalProgress)))
            self.selectedThumb?.position = CGPoint(x: -(self.size.width/2) + position.x, y: -(self.size.height/2) + position.y)
        }
    }
    
    func setAttributedText(text: String) {
        DispatchQueue.main.async {
            let attrText = highlighterTool.highlight(text: text)
            self.label.attributedText = attrText
            self.attributedString = attrText
            self.createRangeMap()
            self.playState = true
        }
    }
    
    func measureCurrentChar(currentTime: TimeInterval) -> CGSize? {
        if (self.attributedString?.length)! > (self.currentCharCount + 1) {
            let charRange = NSRange(location: self.currentCharCount, length: 1)
            let char = (self.attributedString?.attributedSubstring(from: charRange))!
            let charSize = char.size()
            if !self.disableCamera && (currentTime - self.typeUpdate > 0.02) {
                self.currentCharCount = self.currentCharCount + 1
                self.typeUpdate = currentTime
            }
            let progress = CGFloat(self.currentCharCount) / CGFloat(self.attributedString!.length)
            self.hud.setProgress(progress: progress)
            return charSize
        }
        return nil
    }
    
    func createRangeMap() {
        self.charRanges = []
        let newlines = splitAttributedString(inputString: self.attributedString!, seperateBy: "\n")
        var start: Int = 0
        var ranges: [(Int, Int)] = []
        for nl in newlines {
            ranges.append((start, nl.length))
            start = start + nl.length + 1
        }
        self.charRanges = ranges
    }
    
    func getNewLine() -> ((Int, Int), CGFloat) {
        let pos = self.currentCharCount + 1
        var count: CGFloat = 0
        for range in self.charRanges {
            let (start, end) = range
            if pos >= start && pos <= (end + start) {
                return (range, count)
            }
            count = count + 1.0
        }
        return ((0, 1), 1)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (self.playState && (currentTime - self.frameUpdate) > 0.017 ) {
            self.frameUpdate = currentTime
            let charSize = self.measureCurrentChar(currentTime: currentTime)
            if charSize != nil {
                let (range, currLine) = self.getNewLine()
                let (begin, _) = range
                let offsetY = (currLine * 14)
                let offsetX = (self.currentCharCount) - begin
                
                let x = CGFloat(offsetX * Int(charSize!.width))
                let y = 800 - offsetY - 14
                
                self.lineMask.position = CGPoint(x: x , y: CGFloat(800 - (currLine * 14)))
                self.bodyMask.position = CGPoint(x: 0, y: y)
            
                let cameraPosition = self.camera?.position
                if (x > UIScreen.main.bounds.size.width) {
                    self.camera?.position = CGPoint(x: x / 2, y: (cameraPosition!.y))
                } else {
                    self.camera?.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: (self.camera?.position.y)!)
                }

                if (y < 0) {
                    self.camera?.position = CGPoint(x: (cameraPosition!.x), y: (400 + y))
                } else {
                    self.camera?.position = CGPoint(x: (self.camera?.position.x)!, y: UIScreen.main.bounds.size.height / 2)
                }
            }
        }
    }
    
}

struct SCNCodeEditor: View {
    var defaultValue: String
    
    var scene: SKScene {
        let scene = SCNCodeEditorScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .secondarySystemBackground
        scene.setAttributedText(text: self.defaultValue)
        return scene
    }

    var body: some View {
        GeometryReader { proxy in
            SpriteView(scene: scene, preferredFramesPerSecond: 60)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

func splitAttributedString(inputString: NSAttributedString, seperateBy: String) -> [NSAttributedString] {
    let input = inputString.string
    let separatedInput = input.components(separatedBy: seperateBy)
    var output = [NSAttributedString]()
    var start = 0
    for sub in separatedInput {
        let range = NSMakeRange(start, sub.utf16.count)
        let attribStr = inputString.attributedSubstring(from: range)
        output.append(attribStr)
        start += range.length + seperateBy.count
    }
    return output
}
