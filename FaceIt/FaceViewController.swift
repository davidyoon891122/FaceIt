//
//  ViewController.swift
//  FaceIt
//
//  Created by David Yoon on 2021/07/21.
//

import UIKit

class FaceViewController: UIViewController {
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Neutral){ didSet{ updateUI() } }
    
    @IBOutlet var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(recognizer:))
            ))
            
            let happierSwipeGestureRecongnizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            
            happierSwipeGestureRecongnizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecongnizer)
            
            let sadderSwipeGestureRecongnizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            
            sadderSwipeGestureRecongnizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecongnizer)
            
            updateUI()
            
        }
    }
    
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .Open:
                expression.eyes = .Close
            case .Close:
                expression.eyes = .Open
            case .Squinting:
                break
            }
        }
    }
    
    
    @objc func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    
    @objc func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
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

