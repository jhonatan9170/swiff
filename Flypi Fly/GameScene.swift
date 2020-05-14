//
//  GameScene.swift
//  Flypi Fly
//
//  Created by jhontan on 4/7/20.
//  Copyright © 2020 jhontan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    var mosca = SKSpriteNode()
    var fondo = SKSpriteNode()
    var tubo1=SKSpriteNode()
    var tubo2=SKSpriteNode()
    var texturaMosca1=SKTexture()
    var timer=Timer()
    enum tipoNodo:UInt32 {
        case moscaa = 1
        case tuboSuelo = 2
        case espaciotubo = 4
    }
    var labelPunt=SKLabelNode()
    var puntos=0
    var gameover=false
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        reiniciar()
      //  impEspacio()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  mosca.physicsBody = SKPhysicsBody(circleOfRadius: texturaMosca1.size().height/2.0)
        if (gameover==false) {
        mosca.physicsBody!.isDynamic=true
        mosca.physicsBody!.velocity=(CGVector(dx: 0, dy: 0))
            mosca.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 100))
            
        }else{
            gameover=false
            self.speed=1
            puntos=0
            self.removeAllChildren()
            reiniciar()
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let cuerpoA=contact.bodyA
        let cuerpoB=contact.bodyB
        if (cuerpoA.categoryBitMask==tipoNodo.moscaa.rawValue&&cuerpoB.categoryBitMask==tipoNodo.espaciotubo.rawValue||cuerpoB.categoryBitMask==tipoNodo.moscaa.rawValue&&cuerpoA.categoryBitMask==tipoNodo.espaciotubo.rawValue){
            puntos+=1
            labelPunt.text="\(puntos)"
        }else{
            self.speed=0
            timer.invalidate()
            labelPunt.text="GAMER OVER"
            gameover=true
        }

    }
    
    override func update(_ currentTime: TimeInterval){
        // Called before each frame is rendered
    }
    
    func reiniciar(){
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.impTubos), userInfo: nil, repeats: true)
        puntuacion()
        impMosca()
        impFondo()
        impSuelo()
        impTubos()
        
    }
    func puntuacion(){
        labelPunt.fontName="Arial"
        labelPunt.text="0"
        labelPunt.fontSize=80
        labelPunt.zPosition=2
        labelPunt.position=CGPoint(x: self.frame.midX, y: self.frame.midY+500)
        self.addChild(labelPunt)
    }
    
    func impMosca (){
      
        texturaMosca1=SKTexture(imageNamed: "fly1.png")
        let texturaMosca2=SKTexture(imageNamed: "fly2.png")
        let animacion=SKAction.animate(with:[texturaMosca1,texturaMosca2], timePerFrame: 0.1)
        let animacionInfinita = SKAction.repeatForever(animacion)
        mosca=SKSpriteNode(texture: texturaMosca1)
        mosca.physicsBody = SKPhysicsBody(circleOfRadius: texturaMosca1.size().height/2.0)
        mosca.physicsBody!.isDynamic=false
        mosca.physicsBody!.categoryBitMask=tipoNodo.moscaa.rawValue
        mosca.physicsBody!.collisionBitMask=tipoNodo.tuboSuelo.rawValue
        mosca.physicsBody!.contactTestBitMask=tipoNodo.tuboSuelo.rawValue | tipoNodo.espaciotubo.rawValue
        mosca.position=CGPoint(x: self.frame.midX, y: self.frame.midY)
        mosca.run(animacionInfinita)
        self.addChild(mosca)
    }
    
    func impFondo(){
        let textFondo=SKTexture(imageNamed: "fondo.png")
        let movimientoFondo = SKAction.move(by: CGVector(dx: -textFondo.size().width, dy: 0.0), duration: 4)
        let movimientoFondoOrigen = SKAction.move(by: CGVector(dx: textFondo.size().width, dy: 0.0), duration: 0)
        let movimientoInfFondo=SKAction.repeatForever(SKAction.sequence([movimientoFondo,movimientoFondoOrigen]))
        var i:CGFloat=0.0
        while i<2{
            fondo=SKSpriteNode(texture: textFondo)
            fondo.size.height = self.frame.height
            fondo.zPosition = -1.0
            fondo.position = CGPoint(x: textFondo.size().width*i, y: self.frame.midY)
            fondo.run(movimientoInfFondo)
            self.addChild(fondo)
            i+=1}
        }
    
    func impSuelo(){
        let suelo = SKNode()
        suelo.position=CGPoint(x: -self.frame.midX, y: -self.frame.height/2)
        suelo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        suelo.physicsBody!.isDynamic=false
        suelo.physicsBody!.categoryBitMask=tipoNodo.tuboSuelo.rawValue
        suelo.physicsBody!.collisionBitMask=tipoNodo.moscaa.rawValue
        suelo.physicsBody!.contactTestBitMask=tipoNodo.moscaa.rawValue
        self.addChild(suelo)
    }
     @objc func impTubos(){
        let moverTubos = SKAction.move(by: CGVector(dx: -3*self.frame.width,dy: 0), duration: TimeInterval(self.frame.width/100))
        let removerTubos = SKAction.removeFromParent()
        let tub = SKAction.sequence([moverTubos,removerTubos])
        let gapDificutad=mosca.size.height*3
        let aleat = CGFloat(arc4random()%UInt32(self.frame.height/2))-self.frame.height/4
        let textTubo1=SKTexture(imageNamed: "Tubo1.png")
        let textTubo2=SKTexture(imageNamed: "Tubo2.png")
        tubo1=SKSpriteNode(texture: textTubo1)
        tubo2=SKSpriteNode(texture: textTubo2)
        tubo1.zPosition=0
        tubo2.zPosition=0
        tubo1.position=CGPoint(x: self.frame.midX+self.frame.width, y: self.frame.midY+textTubo1.size().height/2+gapDificutad+aleat)
        tubo2.position=CGPoint(x: self.frame.midX+self.frame.width, y: self.frame.midY-textTubo1.size().height/2-gapDificutad+aleat)
        tubo1.physicsBody = SKPhysicsBody(rectangleOf: textTubo1.size())
        tubo1.physicsBody!.isDynamic=false
        tubo2.physicsBody = SKPhysicsBody(rectangleOf: textTubo2.size())
        tubo2.physicsBody!.isDynamic=false
        tubo1.physicsBody!.categoryBitMask=tipoNodo.tuboSuelo.rawValue
        tubo2.physicsBody!.categoryBitMask=tipoNodo.tuboSuelo.rawValue
        tubo1.physicsBody!.collisionBitMask=tipoNodo.moscaa.rawValue
        tubo2.physicsBody!.collisionBitMask=tipoNodo.moscaa.rawValue
        tubo1.physicsBody!.contactTestBitMask=tipoNodo.moscaa.rawValue
        tubo2.physicsBody!.contactTestBitMask=tipoNodo.moscaa.rawValue
        tubo1.run(tub)
        tubo2.run(tub)
        self.addChild(tubo1)
        self.addChild(tubo2)
        //espacio
        let espacio = SKSpriteNode()
        espacio.position=CGPoint(x: self.frame.midX+self.frame.width, y: self.frame.midY+aleat)
        espacio.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width: textTubo1.size().width, height: mosca.size.height*3))
        espacio.physicsBody!.isDynamic=false
        espacio.physicsBody!.categoryBitMask = tipoNodo.espaciotubo.rawValue
        espacio.physicsBody!.collisionBitMask=0
        espacio.physicsBody!.contactTestBitMask=tipoNodo.moscaa.rawValue
        espacio.zPosition=1
        espacio.run(tub)
        self.addChild(espacio)
    }
   func impEspacio(){

    }
}
