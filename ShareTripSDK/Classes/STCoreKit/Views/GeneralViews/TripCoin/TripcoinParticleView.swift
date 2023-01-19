//
//  TripcoinParticleView.swift
//  ShareTrip
//
//  Created by Mac on 8/22/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class TripcoinParticleView: UIView {
    
    public var particleImage:UIImage?
    public var emitterPosition: CGPoint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // Our own initializer
    public convenience init(emitterPosition: CGPoint) {
        self.init(frame: .zero)
        self.emitterPosition = emitterPosition
    }
    
    public override class var layerClass:AnyClass { return CAEmitterLayer.self }
    
    public override func layoutSubviews() {
        let emitter = self.layer as! CAEmitterLayer
        emitter.masksToBounds = true
        emitter.emitterShape = .point
        
        emitter.emitterPosition = emitterPosition
        
        emitter.emitterSize = CGSize(width: bounds.size.width, height: 1)
        
        let tripCoinEmmiterCell = makeTripCoinEmmiterCell()
        emitter.emitterCells = [tripCoinEmmiterCell]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            emitter.birthRate = 0
        }
    }
    
    public func makeTripCoinEmmiterCell()-> CAEmitterCell {
        let cell = CAEmitterCell()
        
        cell.birthRate = 50
        
        cell.lifetime = 2
        cell.lifetimeRange = 0.5
        
        cell.emissionLongitude = .pi * (3/2)
        cell.emissionRange = .pi/2
        
        cell.velocity = 500
        cell.velocityRange = 500/2
        
        cell.yAcceleration = 500/2
        
        cell.scale = 0.6
        cell.scaleRange = 0.6 / 2
        cell.scaleSpeed = -0.4
        
        cell.contents = particleImage?.cgImage
        return cell
    }
}

