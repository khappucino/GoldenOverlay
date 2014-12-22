//
//  GoldenOverlayView.swift
//  GoldenOverlay
//
//  Created by spacehomunculus on 12/13/14.
//  Copyright (c) 2014 electricbaconstudios. All rights reserved.
//

import UIKit

let BaconRatio : CGFloat = 1.61803398875

class GoldenOverlayView: UIView {
    
    let viewModel : GoldenOverlayViewModel
    let panGestureRecognizer : UIPanGestureRecognizer
    let rotateGestureRecognizer : UIRotationGestureRecognizer
    let zoomGestureRecognizer : UIPinchGestureRecognizer
    let doubleTapGestureRecognizer : UITapGestureRecognizer
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let ctx : CGContextRef = UIGraphicsGetCurrentContext()
        let width = self.frame.size.width
        let height = self.frame.size.height
        CGContextSetLineWidth(ctx, 2.0);
        CGContextSetStrokeColorWithColor(ctx, UIColor.greenColor().CGColor);
        CGContextAddRect(ctx, self.frame);
        
        let direction = self.viewModel.getClockWise()
        if direction == true {
            CGContextMoveToPoint(ctx, width * 1/BaconRatio, 0);
            CGContextAddLineToPoint(ctx, width * 1/BaconRatio, height);
            CGContextMoveToPoint(ctx, 0, height)
            CGContextAddArcToPoint(ctx, 0, 0, height, 0, height)
            CGContextMoveToPoint(ctx, height, 0)
            CGContextAddArcToPoint(ctx, width, 0, width, height * 1/BaconRatio, height * 1/BaconRatio)
            CGContextMoveToPoint(ctx, width, height * 1/BaconRatio)
            CGContextAddArcToPoint(ctx, width, height, width - height * 1/(BaconRatio*2), height, height * 1/(BaconRatio*2))

        } else {

        }
        
        
        CGContextStrokePath(ctx);
        UIGraphicsEndImageContext();
    }
    
    override init(frame: CGRect) {
        self.viewModel = GoldenOverlayViewModel()
        self.panGestureRecognizer = UIPanGestureRecognizer()
        self.rotateGestureRecognizer = UIRotationGestureRecognizer()
        self.zoomGestureRecognizer = UIPinchGestureRecognizer()
        self.doubleTapGestureRecognizer = UITapGestureRecognizer()
        
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
        let rotationAngle = viewModel.getRotationAngle() 
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
        
        self.doubleTapGestureRecognizer.addTarget(self, action: "doubleTap")
        self.doubleTapGestureRecognizer.delegate = self
        self.doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(self.doubleTapGestureRecognizer)
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
            self.viewModel.beginScaleTouch()
        }
        else if(sender.state == UIGestureRecognizerState.Changed) {
            self.viewModel.updateScaleTouch(Float(sender.scale))
        }
        else {
        }
    }
    
    func rotate(sender : UIRotationGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Began) {
            self.viewModel.beginRotateTouch()
        }
        else if(sender.state == UIGestureRecognizerState.Changed) {
            self.viewModel.updateRotateTouch(Float(sender.rotation))
        }
        else {
        }
    }
    
    func doubleTap(sender : UITapGestureRecognizer) {
        self.viewModel.setToggle()
    }
}


