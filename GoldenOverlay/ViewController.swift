//
//  ViewController.swift
//  GoldenOverlay
//
//  Created by spacehomunculus on 12/13/14.
//  Copyright (c) 2014 electricbaconstudios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let frames = CGRectMake(0, 0, 100*BaconRatio, 100)
        let v : GoldenOverlayView = GoldenOverlayView(frame : frames)
        self.view.addSubview(v)
        v.setNeedsDisplay()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

