//
//  DDIndicator.swift
//  Loading
//
//  Created by Ashish Awasthi on 06/04/19.
//  Copyright © 2019 Ashish Awasthi. All rights reserved.
//

import UIKit

private var stage: Int = 0

class DDIndicator: UIView {
    var timer: Timer?
    var loaderColor: UIColor = .gray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        if let _ = timer {
            //Log.releasePrint("timer already running...:\(item.isValid)")
        }else {
            timer = Timer(timeInterval: 0.1, target: self, selector: #selector(self.callNeedToDisplay), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        }
        isHidden = false
        stage += 1
    }
    
    @objc func callNeedToDisplay()  {
        self.setNeedsDisplay()
    }
    
    func stopAnimating() {
        self.isHidden = true
        if let item = timer {
            item.invalidate()
            timer = nil
        }
    }
    
    func getColorForStage(_ currentStage: Int, withAlpha alpha: Double) -> UIColor {
        let max: Int = 16
        let cycle: Int = currentStage % max
        if cycle < max / 4 {
            return loaderColor
        }
        else if cycle < max / 4 * 2 {
            return loaderColor
        }
        else if cycle < max / 4 * 3 {
            return loaderColor
        }
        else {
           return UIColor(red: 239.0 / 255.0, green: 91.0 / 255.0, blue: 148.0 / 255.0, alpha: CGFloat(alpha))
        }
    }
    
    func pointOnInnerCirecle(withAngel angel: Int) ->CGPoint {
        let r: Double = Double(frame.size.height / 2 / 2)
        let cx: Double = Double(frame.size.width / 2)
        let cy: Double = Double(frame.size.height / 2)
        let x:Double = cx + r * cos((Double.pi / 10) * Double(angel ))
        let y:Double = cy + r * sin((Double.pi / 10) * Double(angel ))
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    func pointOnOuterCirecle(withAngel angel: Int) ->CGPoint {
        let r: Double = Double(frame.size.height / 2)
        let cx: Double = Double(frame.size.width / 2)
        let cy: Double = Double(frame.size.height / 2)
        let x:Double = cx + r * cos((Double.pi / 10) * Double(angel ))
        let y:Double = cy + r * sin((Double.pi / 10) *   Double(angel ))
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    override func draw(_ rect: CGRect) {
        var point: CGPoint
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(2.0)
        for  i in 1...20 {
            ctx?.setStrokeColor(getColorForStage(stage + i, withAlpha: (0.1 *  Double(i))).cgColor)
            point = pointOnOuterCirecle(withAngel: stage + i)
            ctx?.move(to: CGPoint(x: point.x, y: point.y))
            point = pointOnInnerCirecle(withAngel: stage + i)
            ctx?.addLine(to: CGPoint(x: point.x, y: point.y))
            ctx?.strokePath()
        }
        stage += 1
    }
    

}
