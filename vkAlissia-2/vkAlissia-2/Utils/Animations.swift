//
//  Animations.swift
//  vkAlissia
//
//  Created by Роман Колосов on 02.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        destination.view.transform = CGAffineTransform(translationX: source.view.frame.width, y: 0)
        
        UIView
            .animateKeyframes(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0,
                options: .calculationModePaced,
                animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0,
                                       relativeDuration: 0.75) {
                                        let transform = CGAffineTransform(translationX: -200, y: 0)
                                        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                        
                                        source.view.transform = transform.concatenating(scale)
                    }
                    
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4) {
                        let translation = CGAffineTransform(translationX: source.view.frame.width / 2, y: 0)
                        
                        let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        destination.view.transform = translation.concatenating(scale)
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                        destination.view.transform = .identity
                    }
                    
            }) { result in
                if result && !transitionContext.transitionWasCancelled {
                    source.view.transform = .identity
                    transitionContext.completeTransition(true)
                }
                else {
                    transitionContext.completeTransition(false)
                }
        }
    }
}

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        destination.view.frame = source.view.frame
        
        let translation = CGAffineTransform(translationX: -200, y: 0)
        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        destination.view.transform = translation.concatenating(scale)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                           let translation = CGAffineTransform(translationX: source.view.frame.width / 2, y: 0)
                                                           let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                                           source.view.transform = translation.concatenating(scale)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.4,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                           source.view.transform = CGAffineTransform(translationX: source.view.frame.width, y: 0)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                       relativeDuration: 0.75,
                                                       animations: {
                                                           destination.view.transform = .identity
                                    })
                                    
                                    
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}

class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    
    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func handlePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        switch gesture.state {
        case .began:
            hasStarted = true
            viewController?.navigationController?.popViewController(animated: true)
            
        case .changed:
            let translation = gesture.translation(in: gesture.view)
            let relativeTranslation = translation.x / (gesture.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            
            shouldFinish = progress > 0.33
            
            update(progress)
            
        case .ended:
            hasStarted = false
            shouldFinish ? finish() : cancel()
            
        case .cancelled:
            hasStarted = false
            cancel()
        default:
            return
        }
    }
}
