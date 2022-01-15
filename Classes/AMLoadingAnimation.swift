//
//  AMLoadingAnimation.swift
//  AMLoadingAnimation
//
//  Created by Jonas Aaron Musa on 1/16/22.
//

import UIKit

@IBDesignable
public class AMLoadingAnimation: UIView {
    
    // MARK: - Inspectable variables
    @IBInspectable
    public private(set) var trackColor: UIColor = .purple
    @IBInspectable
    public private(set) var animatingColor: UIColor = .white
    @IBInspectable
    public private(set) var duration: Double = 1.2
    
    // MARK: - Variables
    private let animationName = "positionX"
    
    private let gradientLayer = CAGradientLayer()
    private var animation: CABasicAnimation? {
        willSet {
            guard animation == nil else { return }
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    // MARK: Functions
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Create path for the track/base view
        let path = UIBezierPath(roundedRect: rect,
                                cornerRadius: rect.height * 0.5)
        // Assign the track color to the path
        trackColor.setFill()
        path.fill()
        
        // For gradient layer
        let locations: [NSNumber] = [0.1, 0.5, 0.6, 0.9]
        let colors = [
            animatingColor.withAlphaComponent(0.0).cgColor,
            animatingColor.withAlphaComponent(0.7).cgColor,
            animatingColor.withAlphaComponent(0.7).cgColor,
            animatingColor.withAlphaComponent(0.0).cgColor,
        ]
        
        gradientLayer.locations = locations
        gradientLayer.colors = colors
        gradientLayer.frame = rect
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // For horizontal gradient effect
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0) // For horizontal gradient effect
        
        // Animate the inner layer for indication of loading
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = -(rect.maxX * 0.5)
        animation.toValue = rect.maxX * 1.25
        animation.duration = duration
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        self.animation = animation

        gradientLayer.add(animation, forKey: animationName)

        layer.addSublayer(gradientLayer)
        layer.cornerRadius = rect.height * 0.5
        clipsToBounds = true
    }
    
    // MARK: - Observers
    @objc private func willEnterForeground() {
        guard let animation = animation else { return }
        gradientLayer.add(animation, forKey: animationName)
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()

        NotificationCenter.default.removeObserver(self)
    }
}

