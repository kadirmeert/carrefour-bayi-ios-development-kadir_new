//
//  CircularTransititon.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 16.08.2022.
//

import UIKit

class CircularTransititon: UIView {
    weak var circleView: UIView?
    lazy var isAnimating = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setup() {
        let rectSide = (frame.size.width > frame.size.height) ? frame.size.height : frame.size.width
        let circleRect = CGRect(x: (frame.size.width-rectSide)/2, y: (frame.size.height-rectSide)/2, width: rectSide, height: rectSide)
        let circleView = UIView(frame: circleRect)
        circleView.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        circleView.layer.cornerRadius = rectSide/2
        addSubview(circleView)
        self.circleView = circleView
    }

    func resizeCircle (summand: CGFloat, duration: TimeInterval) {

        guard let circleView = circleView else { return }
        frame.origin.x -= summand/2
        frame.origin.y -= summand/2
        frame.size.height += summand
        frame.size.width += summand

        circleView.frame.size.height += summand
        circleView.frame.size.width += summand
        
        animateChangingCornerRadius(toValue: circleView.frame.size.width/2, duration: duration)
    }

    private func animateChangingCornerRadius (toValue: Any?, duration: TimeInterval) {
        guard let circleView = circleView else { return }
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fromValue = circleView.layer.cornerRadius
        animation.toValue =  toValue
        animation.duration = duration
        circleView.layer.cornerRadius = circleView.frame.size.width/2
        circleView.layer.add(animation, forKey:"cornerRadius")
    }
}
