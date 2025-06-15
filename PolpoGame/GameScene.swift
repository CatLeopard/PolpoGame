//
//  GameScene.swift
//  PolpoGame
//
//  Created by Alessandro Mulas on 15/06/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var spinnyNode : SKShapeNode?
    private var polpoNode : SKSpriteNode?

    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        // 🔷 Spinny node per interazioni visive
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode(rectOf: CGSize(width: w, height: w), cornerRadius: w * 0.3)
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.run(.repeatForever(.rotate(byAngle: CGFloat.pi, duration: 1)))
            spinnyNode.run(.sequence([
                .wait(forDuration: 0.5),
                .fadeOut(withDuration: 0.5),
                .removeFromParent()
            ]))
        }
        
        // 🐙 Crea e centra il polpo animato
        let textures = (0..<8).map { SKTexture(imageNamed: "idle_float_\($0)") }
        let polpo = SKSpriteNode(texture: textures.first)
        polpo.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        polpo.run(.repeatForever(.animate(with: textures, timePerFrame: 0.15)))
        self.addChild(polpo)
        self.polpoNode = polpo
    }

    // MARK: - Interazioni mouse

    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = .green
            self.addChild(n)
        }
    }

    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = .blue
            self.addChild(n)
        }
    }

    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = .red
            self.addChild(n)
        }
    }

    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }

    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }

    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }

    // MARK: - Tastiera

    override func keyDown(with event: NSEvent) {
        print("🔑 Tasto premuto: \(event.characters ?? "?") [keyCode: \(event.keyCode)]")
    }

    // MARK: - GameplayKit update loop

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }

        let dt = currentTime - lastUpdateTime
        for entity in entities {
            entity.update(deltaTime: dt)
        }

        lastUpdateTime = currentTime
    }
}
