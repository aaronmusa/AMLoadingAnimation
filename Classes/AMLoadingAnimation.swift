//
//  AMLoadingAnimation.swift
//  AMLoadingAnimation
//
//  Created by Jonas Aaron Musa on 1/16/22.
//

import UIKit

@IBDesignable
public class AMLoadingAnimation: UIView {
    
    public enum GradientColorPosition {
        case start
        case center
        case end
        
        var locations: [NSNumber] {
            switch self {
            case .start: return [0.0, 1.0]
            case .center: return [0.1, 0.5, 0.6, 0.9]
            case .end: return [0.0, 1.0]
            }
        }
        
        func colors(_ baseColor: UIColor) -> [CGColor] {
            switch self {
            case .start:
                return [
                    baseColor.cgColor,
                    baseColor.withAlphaComponent(0.0).cgColor
                ]
            case .center:
                return [
                    baseColor.withAlphaComponent(0.0).cgColor,
                    baseColor.withAlphaComponent(0.7).cgColor,
                    baseColor.withAlphaComponent(0.7).cgColor,
                    baseColor.withAlphaComponent(0.0).cgColor
                ]
            case .end:
                return [
                    baseColor.withAlphaComponent(0.0).cgColor,
                    baseColor.cgColor
                ]
            }
        }
    }
    
    // MARK: - Inspectable variables
    @IBInspectable
    public var trackColor: UIColor = .purple {
        didSet {
            let path = UIBezierPath(roundedRect: bounds,
                                    cornerRadius: bounds.height * 0.5)
            // Assign the track color to the path
            trackColor.setFill()
            path.fill()
            
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var gradientColor: UIColor = .white
    @IBInspectable
    public var duration: Double = 1.2
    @IBInspectable
    public var isAnimating: Bool = false {
        didSet {
            reload()
        }
    }
    @IBInspectable
    public var isGradientVisible: Bool = false {
        didSet {
            reload()
        }
    }
    
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
        
        gradientLayer.frame = rect
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // For horizontal gradient effect
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0) // For horizontal gradient effect
        setGradientPosition()
        
        // Animate the inner layer for indication of loading
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = -(rect.maxX * 0.5)
        animation.toValue = rect.maxX * 1.25
        animation.duration = duration
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        self.animation = animation
        
        if isGradientVisible {
            layer.addSublayer(gradientLayer)
        }

        if isAnimating {
            startAnimation()
        }
        
        layer.cornerRadius = rect.height * 0.5
        clipsToBounds = true
    }
    
    // MARK: - Observers
    @objc private func willEnterForeground() {
        startAnimation()
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()

        NotificationCenter.default.removeObserver(self)
    }
    
    public func reload() {
        if isGradientVisible {
            if layer.sublayers?.contains(gradientLayer) != true {
                layer.addSublayer(gradientLayer)
            }
            
            if isAnimating {
                startAnimation()
                return
            }
            
            return
        }
        
        stopAnimation()
    }
    
    private func startAnimation() {
        guard let animation = animation, isAnimating, isGradientVisible else { return }
        gradientLayer.add(animation, forKey: animationName)
    }
    
    private func stopAnimation() {
        guard !isGradientVisible else { return }
        gradientLayer.removeFromSuperlayer()
    }
    
    public func setGradientPosition(_ position: GradientColorPosition = .center) {
        gradientLayer.locations = position.locations
        gradientLayer.colors = position.colors(gradientColor)
    }
}
