//
//  ViewController.swift
//  FaceIt
//
//  Created by David Yoon on 2021/07/21.
//

import UIKit

class FaceViewController: UIViewController {
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Neutral){ didSet{ updateUI() } }
    
    @IBOutlet var faceView: FaceView! { didSet { updateUI() } }
    
    private let mouthCurvatures = [
        FacialExpression.Mouth.Frown:-1.0,
        .Grin:0.5,
        .Smile:1.0,
        .Neutral:0,
        .Smirk:-0.5
    ]
    
    private let eyeBrowTilts = [
        FacialExpression.EyeBrows.Relaxed:0.5,
        .Furrowed:-0.5,
        .Normal:0.0
    ]
    
    private func updateUI() {
        switch expression.eyes {
        case .Open:
            faceView.eyesOpen = true
        case .Close:
            faceView.eyesOpen = false
        case .Squinting:
            faceView.eyesOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        
    }

}

