//
//  GoldenOverlayViewModel.swift
//  GoldenOverlay
//
//  Created by spacehomunculus on 12/14/14.
//  Copyright (c) 2014 electricbaconstudios. All rights reserved.
//

import Foundation

class GoldenOverlayViewModel : BaconObservable {
    
    var position : (Float, Float)
    var lastPanPoint : (Float, Float)
    var zoomScale : Float
    var rotationAngle : Float
    var initialRotate : Float

    override init() {
        self.lastPanPoint = (0,0)
        self.position = (0,0)
        self.zoomScale = 1.0
        self.rotationAngle = 0
        self.initialRotate = 0
        super.init()
    }

    func getPosition() -> (Float, Float) {
        return self.position
    }
    
    func getScale() -> Float {
        return self.zoomScale
    }
    
    func getRotationAngle() -> Float {
        return self.rotationAngle
    }
    
    func setInitialPosition(x xvalue : Float, y yvalue : Float) {
        self.position = (xvalue, yvalue)
    }

}

extension GoldenOverlayViewModel {
   
    func updateRotateTouch(rotation: Float) {
        self.rotationAngle = rotation
        if self.rotationAngle > 2*3.14 {
            self.rotationAngle = self.rotationAngle - 2*3.14
        } else if self.rotationAngle < 0 {
            self.rotationAngle = 2*3.14 + self.rotationAngle
        }
        self.setChanged()
        self.notifyObservers()
    }

}

extension GoldenOverlayViewModel {
    func updateScaleTouch(scale: Float) {
        self.zoomScale = scale
        if self.zoomScale > 10 {
            self.zoomScale = 10
        } else if  self.zoomScale < 0.5 {
            self.zoomScale = 0.5
        }
        self.setChanged()
        self.notifyObservers()
    }
}


extension GoldenOverlayViewModel {
    
    func beginPanTouch(x xvalue : Float, y yvalue : Float) {
        self.lastPanPoint = (xvalue, yvalue)
    }
    
    func updatePanTouch(x xvalue : Float, y yvalue : Float) {
        let (lastPanPointx, lastPanPointy) = self.lastPanPoint
        let (translationX, translationY) = (xvalue - lastPanPointx,
            yvalue - lastPanPointy)
        let (currentX, currentY) = self.position
        
        self.lastPanPoint = (xvalue, yvalue)
        self.position = (currentX + translationX,
            currentY + translationY)
        
        self.setChanged()
        self.notifyObservers()
    }
    
    func endPanTouch(x xvalue : Float, y yvalue : Float) {
        let (lastPanPointx, lastPanPointy) = self.lastPanPoint
        let (translationX, translationY) = (xvalue - lastPanPointx,
            yvalue - lastPanPointy)
        let (currentX, currentY) = self.position
        
        self.lastPanPoint = (xvalue, yvalue)
        self.position = (currentX + translationX,
            currentY + translationY)
        
        self.setChanged()
        self.notifyObservers()
    }

}
