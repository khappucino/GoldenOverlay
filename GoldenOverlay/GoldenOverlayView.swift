//
//  GoldenOverlayView.swift
//  GoldenOverlay
//
//  Created by spacehomunculus on 12/13/14.
//  Copyright (c) 2014 electricbaconstudios. All rights reserved.
//

import UIKit

class GoldenOverlayView: UIView, UIGestureRecognizerDelegate {
    
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
        
        setupViewModels()
        setupGestureRecognizers()

    }
   
    func setupViewModels() {
        self.viewModel.setObservationClosure(observationClosure: {
            [weak self](viewModel : GoldenOverlayViewModel) in
            let (posx, posy) = viewModel.getPosition()
            if let view = self {
                view.center = CGPoint(x: CGFloat(posx), y: CGFloat(posy))
            }
        })
    }
   
    override func didMoveToSuperview() {
        self.viewModel.setInitialPosition(x: Float(self.center.x), y: Float(self.center.y))

    }
    
    func setupGestureRecognizers() {
        // add target/selectors after super.init
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

extension GoldenOverlayView {
    
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
        
    }
    
    func rotate(sender : UIRotationGestureRecognizer) {
        
    }
}

// helper methods
extension GoldenOverlayView {
    func calculatePanPoint(sender : UIPanGestureRecognizer) -> CGPoint
    {
        if let parentView = self.superview {
            return sender.translationInView(parentView)
        } else {
            return CGPoint(x: 0,y: 0)
        }
        
    }
}
