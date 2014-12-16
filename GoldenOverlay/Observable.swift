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

class Observable {
    
    var changed : Bool
    
    var observers : [Observer]
    
    init() {
        self.changed = true
        self.observers = []
    }
    
    func addObserver(observer : Observer) {
        ghettoSync(self, closure: {
            let x = self.observers.filter({ (obs : Observer) -> Bool in
               return true
            })
            if(0 == x.count) {
               self.observers.append(observer)
            }
        })
    }
    
    func removeObserver(observer : Observer) {
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