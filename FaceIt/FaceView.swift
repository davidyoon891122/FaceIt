//
//  FaceView.swift
//  FaceIt
//
//  Created by David Yoon on 2021/07/21.
//

import UIKit
@IBDesignable
class FaceView: UIView {
    // can't use bounds before initialization
    // chage var to computed var
    // if there is just get feature on var, you don't have to use get{} method
    @IBInspectable
    var scale: CGFloat = 0.90{ didSet { setNeedsDisplay() }}// send redraw order to system
    
    @IBInspectable
    var mouthCurvature: Double = 0.0{ didSet { setNeedsDisplay() }} // 1 full smile, -1 full frown
    @IBInspectable
    var eyesOpen: Bool = false{ didSet { setNeedsDisplay() }}
    @IBInspectable
    var eyeBrowTilt: Double = -0.5{ didSet { setNeedsDisplay() }}  // full smile, -1 full frown
    @IBInspectable
    var color: UIColor = UIColor.blue{ didSet { setNeedsDisplay() }}
    @IBInspectable
    var lineWidth: CGFloat = 5.0{ didSet { setNeedsDisplay() }} 
    
    
    @objc func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            // scale 축척을 막기 위함
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    
    // struct for drawing skull's eyes
    // if there is a Capitalized var name on struct, struct name should be capitalized
    private struct Ratios {
        static let SkullRadiusToEysOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 3
    }
    // there are two case for Left, Right eye
    enum Eye {
        case Left
        case Right
    }
    
    
    func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath{
        let path =  UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*Double.pi),
            clockwise: false
        )
        
        path.lineWidth = lineWidth
        
        return path
    }
    
    // calculate eye center point with skullCenter
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEysOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left:
            eyeCenter.x -= eyeOffset
        case .Right:
            eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius // 10 times smaller than skull
        let eyeCenter = getEyeCenter(eye:eye)
        
        if eyesOpen {
            return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
        }else {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
        
        
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .Left:
            tilt *= -1.0
        case .Right:
            break
        }
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1,min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    
    
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        // draw Rectangle mouth
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        // draw Curve with BezierPath
        let mouthCurvature: Double = mouthCurvature // 1 full smile, -1 full frown
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y:mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.midY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.midY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to:start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // draw skull circle
        color.set()
        //chaning calling
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
        pathForBrow(eye: .Left).stroke()
        pathForBrow(eye: .Right).stroke()
    }
    


}
