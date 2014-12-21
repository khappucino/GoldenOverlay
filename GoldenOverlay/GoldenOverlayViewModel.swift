//
//  GoldenOverlayViewModel.swift
//  GoldenOverlay
//
//  Created by spacehomunculus on 12/14/14.
//  Copyright (c) 2014 electricbaconstudios. All rights reserved.
//

import Foundation

let BaconPi : Float = 3.14159265358979323846264338327950288
let BaconMaxZoom : Float = 10
let BaconMinZoom : Float = 0.5

class GoldenOverlayViewModel : BaconObservable {
    
    var position : (Float, Float)
    var lastPanPoint : (Float, Float)
    var zoomScale : Float
    var rotationAngle : Float
    var initialRotate : Float
    var initialZoom : Float

    override init() {
        self.lastPanPoint = (0,0)
        self.position = (0,0)
        self.zoomScale = 1.0
        self.rotationAngle = 0
        self.initialRotate = 0
        self.initialZoom = 0
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
    
    func clampRotation(inputRotationAngle : Float) -> Float {
        
        println("before %f", inputRotationAngle)
        var rotAngle : Float = inputRotationAngle
        if rotAngle > 2*BaconPi {
            println("past 2pi", inputRotationAngle)
            rotAngle = rotAngle - 2*BaconPi
        } else if rotAngle < 0 {
            println("past 0", inputRotationAngle)
            rotAngle = 2*BaconPi + rotAngle
        }
        let x = rotAngle
        println("after %f", x)
        return rotAngle
    }
    
    func clampZoom(inputZoomScale : Float) -> Float {
        var zoomScale : Float = inputZoomScale
        if zoomScale > BaconMaxZoom {
            zoomScale = BaconMaxZoom
        } else if zoomScale < BaconMinZoom {
            zoomScale = BaconMinZoom
        }
        return zoomScale
    }

}

extension GoldenOverlayViewModel {
   
    func beginRotateTouch() {
        self.initialRotate = self.rotationAngle
    }
    
    func updateRotateTouch(rotation: Float) {
        self.rotationAngle = clampRotation(rotation + self.initialRotate)
        self.setChanged()
        self.notifyObservers()
    }

}

extension GoldenOverlayViewModel {
    
    func beginScaleTouch() {
        self.initialZoom = self.zoomScale
    }
    
    func updateScaleTouch(scale: Float) {
        self.zoomScale = clampZoom(scale * self.initialZoom)
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
