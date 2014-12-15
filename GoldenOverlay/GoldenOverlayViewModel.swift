//
//  GoldenOverlayViewModel.swift
//  GoldenOverlay
//
//  Created by spacehomunculus on 12/14/14.
//  Copyright (c) 2014 electricbaconstudios. All rights reserved.
//

import Foundation

class GoldenOverlayViewModel {
    
    var position : (Float, Float)
    var lastPanPoint : (Float, Float)
    var notifyObserverClosure : ((GoldenOverlayViewModel) -> Void)?
    
    init() {
        self.lastPanPoint = (0,0)
        self.position = (0,0)
    }
    

    func getPosition() -> (Float, Float) {
        return self.position
    }
    
    func setInitialPosition(x xvalue : Float, y yvalue : Float) {
        self.position = (xvalue, yvalue)
    }
    
    func setObservationClosure(observationClosure closure: (GoldenOverlayViewModel) -> Void) {
        self.notifyObserverClosure = closure
    }
    
    
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
        
        if let notify = self.notifyObserverClosure {
            notify(self)
        }
    }
    
    func endPanTouch(x xvalue : Float, y yvalue : Float) {
        let (lastPanPointx, lastPanPointy) = self.lastPanPoint
        let (translationX, translationY) = (xvalue - lastPanPointx,
            yvalue - lastPanPointy)
        let (currentX, currentY) = self.position
        
        self.lastPanPoint = (xvalue, yvalue)
        self.position = (currentX + translationX,
            currentY + translationY)
        
        if let notify = self.notifyObserverClosure {
            notify(self)
        }
    }
}