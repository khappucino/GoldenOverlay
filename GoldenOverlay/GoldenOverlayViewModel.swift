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

    override init() {
        self.lastPanPoint = (0,0)
        self.position = (0,0)
        self.zoomScale = 1.0
        super.init()
    }

    func getPosition() -> (Float, Float) {
        return self.position
    }
    
    func getScale() -> Float {
        return self.zoomScale
    }
    
    func setInitialPosition(x xvalue : Float, y yvalue : Float) {
        self.position = (xvalue, yvalue)
    }

}

extension GoldenOverlayViewModel {
    func updateScaleTouch(scale: Float) {
        self.zoomScale = scale
        
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
