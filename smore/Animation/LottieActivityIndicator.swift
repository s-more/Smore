//
//  LottieActivityIndicator.swift
//  smartdesk
//
//  Created by Jing Wei Li on 11/21/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import Lottie

/**
 * An activity indicator compatible with Lottie animations.
 * - start by calling `view.addSubview(myAnimator)`
 * - end by calling `myAnimator.stop()`
 */
class LottieActivityIndicator: UIView {
    private var animationView: LOTAnimationView?
    var animationName: String
    /** The ratio of width / height. Defaults to 1.0. */
    var aspectRatio: CGFloat = 1.0
    
    private lazy var screenCenter: CGPoint = {
        return CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    }()
    
    init(animationName: String, frame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)) {
        self.animationName = animationName
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Supported")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        layer.cornerRadius = 20.0
        backgroundColor = UIColor.darkGray
        clipsToBounds = true
    }
    
    override func didMoveToSuperview() {
        guard let superView = superview else { return }
        
        addShadow()
        let width: Int, height: Int
        if aspectRatio <= 1 {
            height = Int(frame.height * 0.888)
            width = Int(frame.height * 0.888 * aspectRatio)
        } else { // > 1
            width = Int(frame.width * 0.888)
            height = Int(frame.width * 0.888 / aspectRatio) // smaller than 0.888
        }
        
        center = screenCenter
        animationView = LOTAnimationView(name: animationName)
        animationView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        animationView?.center = screenCenter
        animationView?.loopAnimation = true
        animationView?.layer.cornerRadius = 20.0
        animationView?.clipsToBounds = true
        superView.addSubview(animationView!)
        animationView?.play()
        
        alpha = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.alpha = 1
        }
    }
    
    func stop() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.animationView?.alpha = 0
            self?.alpha = 0
        }, completion: { [weak self] _ in
            self?.animationView?.stop()
            self?.animationView?.removeFromSuperview()
            self?.removeFromSuperview()
        })
    }
    
    private func addShadow() {
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20.0)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 3.0, height: 10.0)
        layer.shadowOpacity = 0.3
        layer.shadowPath = shadowPath.cgPath
    }
    
}
