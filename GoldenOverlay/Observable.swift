//
//  Observable.swift
//  GoldenOverlay
//
//  Created by spacehomunculus on 12/15/14.
//  Copyright (c) 2014 electricbaconstudios. All rights reserved.
//

import Foundation

protocol Observer {
    func update(observable : Observable)
}

func ==(lhs: Observer, rhs: Observer) -> Bool {
    return lhs == rhs
}

class Observable {
    
    var changed : Bool
    var observers : [Observer]?
    
    init() {
        self.changed = true
        self.observers = []
    }
    
    func addObserver<T : Observer>(observer : T) {
        ghettoSync(self, closure:  { [weak self] in
            if let weakSelf = self {
                let isObserverInSetAlready : Bool = contains(weakSelf.observers, {
                    (obs : Observer) -> Bool in
                    if observer == obs {
                        return true
                    } else {
                        return false
                    }
                })
                
                if !isObserverInSetAlready {
                
                }
            }
        })
    }
    
    func removeObserver<T:Observer>(observer : T) {
        ghettoSync(self, closure: {
            
        })
    }
    
    
    // http://stackoverflow.com/questions/24045895/what-is-the-swift-equivalent-to-objective-cs-synchronized
    func ghettoSync(lockObject : AnyObject, closure: () -> ()) {
        objc_sync_enter(self)
        closure()
        objc_sync_exit(self)
    }
}