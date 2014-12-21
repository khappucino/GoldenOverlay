//
//  GoldenOverlayView.swift
//  GoldenOverlay
//
//  Created by spacehomunculus on 12/13/14.
//  Copyright (c) 2014 electricbaconstudios. All rights reserved.
//

import UIKit

class GoldenOverlayView: UIView {
    
    let viewModel : GoldenOverlayViewModel
    let panGestureRecognizer : UIPanGestureRecognizer
    let rotateGestureRecognizer : UIRotationGestureRecognizer
    let zoomGestureRecognizer : UIPinchGestureRecognizer
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let ctx : CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(ctx, 2.0);
        CGContextSetStrokeColorWithColor(ctx, UIColor.greenColor().CGColor);
        CGContextAddRect(ctx, self.frame);
        CGContextMoveToPoint(ctx, self.frame.size.width * 1/1.618, 0);
        CGContextAddLineToPoint(ctx, self.frame.size.width * 1/1.618, self.frame.size.height);
        CGContextStrokePath(ctx);
        UIGraphicsEndImageContext();
    }
    
    override init(frame: CGRect) {
        self.viewModel = GoldenOverlayViewModel()
        self.panGestureRecognizer = UIPanGestureRecognizer()
        self.rotateGestureRecognizer = UIRotationGestureRecognizer()
        self.zoomGestureRecognizer = UIPinchGestureRecognizer()
        
        super.init(frame: frame);
        self.backgroundColor = UIColor.clearColor();
        
        self.viewModel.addObserver(self)
        
        setupGestureRecognizers()
    }

    override func didMoveToSuperview() {
        self.viewModel.setInitialPosition(x: Float(self.center.x), y: Float(self.center.y))
    }
}

// helper methods
extension GoldenOverlayView {
    
    func updateState() {
        let (posx, posy) = viewModel.getPosition()
        let scalex = viewModel.getScale()
        let rotationAngle = viewModel.getRotationAngle() //* (2.0 * 3.14) / (360)
        self.center = CGPoint(x: CGFloat(posx), y: CGFloat(posy))
        self.transform = CGAffineTransformIdentity
        self.transform = CGAffineTransformScale(self.transform, CGFloat(scalex), CGFloat(scalex))
        self.transform = CGAffineTransformRotate(self.transform, CGFloat(rotationAngle))

    }
    
    func calculatePanPoint(sender : UIPanGestureRecognizer) -> CGPoint
    {
        if let parentView = self.superview {
            return sender.translationInView(parentView)
        } else {
            return CGPoint(x: 0,y: 0)
        }
        
    }
    
    func setupGestureRecognizers() {
        self.panGestureRecognizer.addTarget(self, action: "pan:")
        self.panGestureRecognizer.delegate = self
        self.panGestureRecognizer.maximumNumberOfTouches = 1;
        self.addGestureRecognizer(self.panGestureRecognizer)
        
        self.zoomGestureRecognizer.addTarget(self, action: "zoom:")
        self.zoomGestureRecognizer.delegate = self
        self.addGestureRecognizer(self.zoomGestureRecognizer)
        
        self.rotateGestureRecognizer.addTarget(self, action: "rotate:")
        self.rotateGestureRecognizer.delegate = self
        self.addGestureRecognizer(self.rotateGestureRecognizer)
    }
}

extension GoldenOverlayView : BaconObserverType {
    func update(observable: BaconObservable) {
        // we call master update regardless of what observable fired
        self.updateState()
    }
}

extension GoldenOverlayView : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func pan(sender : UIPanGestureRecognizer) {
        let point = calculatePanPoint(sender)
        if(sender.state == UIGestureRecognizerState.Began) {
            self.viewModel.beginPanTouch(x: Float(point.x), y: Float(point.y) )
        }
        else if(sender.state == UIGestureRecognizerState.Changed) {
            self.viewModel.updatePanTouch(x: Float(point.x), y: Float(point.y) )
        }
        else {
            self.viewModel.endPanTouch(x: Float(point.x), y: Float(point.y) )
        }
    }
    
    func zoom(sender : UIPinchGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Began) {
        }
        else if(sender.state == UIGestureRecognizerState.Changed) {
            self.viewModel.updateScaleTouch(Float(sender.scale))
        }
        else {
        }
    }
    
    func rotate(sender : UIRotationGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Began) {
        }
        else if(sender.state == UIGestureRecognizerState.Changed) {
            self.viewModel.updateRotateTouch(Float(sender.rotation))
        }
        else {
        }
    }
}


