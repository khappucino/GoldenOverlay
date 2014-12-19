//
//  BaconObserver.swift
//  BaconObserver
//
//  Created by spacehomunculus on 12/17/14.
//  Copyright (c) 2014 electricbaconstudios. All rights reserved.
//

import Foundation

protocol BaconObserverType : class {
    func update(observable : BaconObservable)
}

protocol BaconObservableType {
    func addObserver(obs : BaconObserverType) -> Void
}

class BaconObservable : BaconObservableType {
    var observers: [BaconObserverType]
    var changed : Bool
    init() {
        self.changed = false
        self.observers = [BaconObserverType]()
    }
    
    func containsCurryClosure(newObserver : BaconObserverType) (obs : BaconObserverType) -> Bool {
        // when contains is called on an empty collection it doesn't
        // ever execute the closure so we just add on empty count
        if newObserver === obs {
            return true
        }
        return false
    }
    
    // Non-Curry version works with contains
    func containsClosure(newObserver : BaconObserverType) -> ((obs : BaconObserverType) -> Bool) {
        // when contains is called on an empty collection it doesn't
        // ever execute the closure so we just add on empty count
        return { obs in
            if newObserver === obs {
                return true
            }
            return false
        }
    }
    
    func tryToAdd(newObserver : BaconObserverType, containsObserver containsObs : Bool) {
        if self.observers.count == 0 || !containsObs {
            self.observers.append(newObserver)
        }
    }
    
    func addObserver(newObserver : BaconObserverType) {
        objc_sync_enter(self)
        var alreadyContainsObserver = contains(self.observers, containsCurryClosure(newObserver))
        tryToAdd(newObserver, containsObserver : alreadyContainsObserver)
        objc_sync_exit(self)
    }
    
    func removeObserver(killObserver : BaconObserverType) {
        objc_sync_enter(self)
        var indexOf : Int = -1
        // so apparently find() doesn't work right yet with protocol arrays
        for var i = 0; i < self.observers.count; i++ {
            indexOf = i
            break
        }
        if indexOf != -1 {
            self.observers.removeAtIndex(indexOf)
        }
        objc_sync_exit(self)
    }
    
    func setChanged() {
        self.changed = true
    }
    
    func clearChanged() {
        self.changed = false
    }
    
    func notifyObservers() {
        objc_sync_enter(self)
        if self.changed == false {
            return
        } else {
            self.clearChanged()
        }
        objc_sync_exit(self)
        
        let tempArray = self.observers
        tempArray.map({ $0.update(self) })
        
    }
    
    func poke() {
        self.setChanged()
        self.notifyObservers()
    }
}


