//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by David Yoon on 2021/08/09.
//

import UIKit

class EmotionsViewController: UIViewController {

    private let emotionFaces: Dictionary<String,FacialExpression> = [
        "angry": FacialExpression(eyes: .Close, eyeBrows: .Furrowed, mouth: .Frown),
        "happy": FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "worried": FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievious": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)
    ]
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        if let facevc = destination as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotionFaces[identifier] {
                    facevc.expression = expression
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
