//
//  PulseAnimation.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

class PulseAnimation: CALayer {
    
    var animationGroup = CAAnimationGroup()
    var animationDuration: TimeInterval = 0
    var radius: CGFloat = 0
    var numberOfPulses: Float = 0
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(numberOfPulses: Float = 10, radius: CGFloat, position: CGPoint) {
        super.init()
        backgroundColor = UIColor.systemBlue.cgColor
        contentsScale = UIScreen.main.scale
        opacity = 0
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
        
        bounds = CGRect(x: 0, y: 0, width: (radius*2), height: (radius*2))
        cornerRadius = radius
        startAnimation()
    }
    
    func startAnimation() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.setupAnimation()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
    }
    
    func scaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: 0)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        return scaleAnimation
    }
    
    func createAnimationOpacity() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.keyTimes = [0, 0.3, 1]
        opacityAnimation.values = [0.4, 0.8, 0]
        return opacityAnimation
    }
    
    func setupAnimation() {
        animationGroup.duration = animationDuration
        animationGroup.repeatCount = numberOfPulses
        let defaultCurve = CAMediaTimingFunction(name: .default)
        animationGroup.timingFunction = defaultCurve
        animationGroup.animations = [scaleAnimation(), createAnimationOpacity()]
    }
}
