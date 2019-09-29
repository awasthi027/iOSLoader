//
//  LoadingView.swift
//  Loading
//
//  Created by Ashish Awasthi on 06/04/19.
//  Copyright © 2019 Ashish Awasthi. All rights reserved.
//
// Cocoa pod setup link

//https://medium.com/@dark_torch/adding-cocoapods-to-your-library-daa755d18fd

import UIKit

public typealias SVProgressHUDDismissCompletion = () ->Void

public enum UILoadingViewMaskType: Int {
    case defaultLoading = 1
    // default mask type, allow user interactions while HUD is displayed
    case clear
    // don't allow user interactions
    case black
    // don't allow user interactions and dim the UI in the back of the HUD, as on iOS 7 and above
    case eGradient
    // don't allow user interactions and dim the UI with a a-la UIAlertView background gradient, as on iOS 6
    case custom
}

public enum UILoadingViewActivitySize: Int {
    case minimum
    case medium
    case large
}

public class LoadingView: UIView {
    var sizeOfActivity = CGSize.zero
    var overlayView: UIControl?
    var defaultMaskType = UILoadingViewMaskType(rawValue: 1)
    var ddIndicatorView: DDIndicator?
    var titleLabel: UILabel?
    var font: UIFont?
    var foreGroundColor: UIColor?
    var backGroundColor: UIColor?
    var messageTxt: String = ""
    public static var loadingThemeColor: UIColor = .gray
    // Declare class instance property
    static let sharedInstance = LoadingView(frame: UIScreen.main.bounds)
    
    // Declare an initializer
    // Because this class is singleton only one instance of this class can be created
    override init(frame: CGRect) {
        super.init(frame: frame)
         self.processLoadingOperation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Add a function
    func processLoadingOperation() ->Void {
       // Log.releasePrint("Started processing loading operation")
        overlayViewObject()
        ddIndicatorViewObject()
        titleLabelObject()
        // Your other code here
    }
   
   public class func showLarge() ->Void {
        weak var weakSelf: LoadingView? = LoadingView.sharedInstance
        OperationQueue.main.addOperation({() -> Void in
            let strongSelf: LoadingView? = weakSelf
            strongSelf?.defaultMaskType = .defaultLoading
            if strongSelf != nil {
                // Update / Check view hierachy to ensure the HUD is visible
                strongSelf?.showProgress(.large)
            }
        })
    }
    
  public  class func showMedium() ->Void {
        weak var weakSelf: LoadingView? = LoadingView.sharedInstance
        OperationQueue.main.addOperation({() -> Void in
            let strongSelf: LoadingView? = weakSelf
            strongSelf?.defaultMaskType = .defaultLoading
            if strongSelf != nil {
                // Update / Check view hierachy to ensure the HUD is visible
                strongSelf?.showProgress(.medium)
            }
        })
    }
    
  public  class func showMinmumSize() ->Void {
        weak var weakSelf: LoadingView? = LoadingView.sharedInstance
        OperationQueue.main.addOperation({() -> Void in
            let strongSelf: LoadingView? = weakSelf
            if strongSelf != nil {
                strongSelf?.defaultMaskType = .defaultLoading
                // Update / Check view hierachy to ensure the HUD is visible
                strongSelf?.showProgress(.minimum)
            }
        })
    }
    
   public class func show(with maskType: UILoadingViewMaskType) ->Void {
        weak var weakSelf: LoadingView? = LoadingView.sharedInstance
        OperationQueue.main.addOperation({() -> Void in
            let strongSelf: LoadingView? = weakSelf
            if strongSelf != nil {
                strongSelf?.defaultMaskType = maskType
                // Update / Check view hierachy to ensure the HUD is visible
                strongSelf?.showProgress(.medium)
            }
        })
    }
    
  public class func show(withText text: String) ->Void {
        weak var weakSelf: LoadingView? = LoadingView.sharedInstance
        OperationQueue.main.addOperation({() -> Void in
            let strongSelf: LoadingView? = weakSelf
            if strongSelf != nil {
                strongSelf?.defaultMaskType = .defaultLoading
                // Update / Check view hierachy to ensure the HUD is visible
                strongSelf?.showProgress(.medium)
                strongSelf?.titleLabel?.text = text
                strongSelf?.titleLabel?.isHidden = false
            }
        })
    }
    
   public class func show(withText text: String, mark maskType: UILoadingViewMaskType) ->Void {
        weak var weakSelf: LoadingView? = LoadingView.sharedInstance
        OperationQueue.main.addOperation({() -> Void in
            let strongSelf: LoadingView? = weakSelf
            if strongSelf != nil {
                strongSelf?.defaultMaskType = maskType
                // Update / Check view hierachy to ensure the HUD is visible
                strongSelf?.showProgress(.medium)
                strongSelf?.messageTxt = text
                strongSelf?.titleLabel?.isHidden = false
            }
        })
    }
   public class func setDefaultMaskType(_ maskType: UILoadingViewMaskType) ->Void {
        LoadingView.sharedInstance.defaultMaskType = maskType
    }
    
   public class func setFont(_ font: UIFont!) ->Void {
        LoadingView.sharedInstance.font = font
    }
    
   public class func setForegroundColor(_ color: UIColor) ->Void {
        LoadingView.sharedInstance.foreGroundColor = color
    }
    
   public class func setBackgroundColor(_ color: UIColor?) ->Void {
        LoadingView.sharedInstance.backGroundColor = color
    }
    
  public  class func messageTxt(_ text: String) {
        LoadingView.sharedInstance.messageTxt = text
    }
    
   public func showProgress(_ size: UILoadingViewActivitySize) ->Void {
        if size == .minimum {
            sizeOfActivity = CGSize(width: 16, height: 16)
        }
        if size == .medium {
            sizeOfActivity = CGSize(width: 32, height: 32)
        }
        if size == .large {
            sizeOfActivity = CGSize(width: 48, height: 48)
        }
        if !(overlayView!.superview != nil) {
            let frontToBackWindows: NSEnumerator? = (UIApplication.shared.windows as NSArray).reverseObjectEnumerator()
            for item in frontToBackWindows!  {
                let window: UIWindow = item as! UIWindow
                let windowOnMainScreen: Bool = window.screen == UIScreen.main
                let windowIsVisible: Bool = !window.isHidden && window.alpha > 0
                let windowLevelNormal: Bool = window.windowLevel == UIWindow.Level.normal
                if windowOnMainScreen && windowIsVisible && windowLevelNormal {
                    window.addSubview(overlayView!)
                    break
                }
            }
        } else {
                // Ensure that overlay will be exactly on top of rootViewController (which may be changed during runtime).
            overlayView?.superview?.bringSubviewToFront(overlayView!)
            }
            if !(superview != nil) {
                overlayView?.addSubview(self)
            }
          ddIndicatorViewObject()
          var rect: CGRect = bounds
           rect.size = sizeOfActivity
           ddIndicatorView?.frame = rect
           ddIndicatorView?.autoresizingMask = ([.flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin])
            ddIndicatorView?.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
            overlayView?.addSubview(ddIndicatorView!)
            titleLabel?.center = CGPoint(x: frame.size.width  / 2, y: (frame.size.height / 2) + 35)
        
            overlayView?.addSubview(titleLabel!)
            if defaultMaskType == .defaultLoading {
                overlayView?.isUserInteractionEnabled = false
                ddIndicatorView?.isAccessibilityElement = false
              }
            else {
                overlayView?.isUserInteractionEnabled = true
                isAccessibilityElement = true
            }
        
           ddIndicatorView?.startAnimating()
            self.setNeedsDisplay()
        }
    
  @discardableResult  fileprivate func ddIndicatorViewObject()->DDIndicator {
            if let item = ddIndicatorView {
                item.startAnimating()
                return item
            }else {
            var rect: CGRect = bounds
            rect.size = sizeOfActivity
            ddIndicatorView = DDIndicator(frame: rect)
                ddIndicatorView?.loaderColor = LoadingView.loadingThemeColor
           }
         return ddIndicatorView!
    }
  
    
  @discardableResult  fileprivate func titleLabelObject() ->UILabel {
        if let item = titleLabel {
            return item
        }else {
            let screenSize = UIScreen.main.bounds
            let rect = CGRect(x: 0, y: 0, width:screenSize.width, height: 42)
            titleLabel = UILabel(frame: rect)
            titleLabel?.numberOfLines = 0
            titleLabel?.backgroundColor = .clear
             titleLabel?.textAlignment = .center
             titleLabel?.text = messageTxt
            titleLabel?.textColor = LoadingView.loadingThemeColor
            titleLabel?.autoresizingMask = ([.flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin])
             titleLabel?.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 + (ddIndicatorView?.frame.size.height)!)
             titleLabel?.isHidden = true
        }
        return  titleLabel!
    }
    
 @discardableResult fileprivate func overlayViewObject() ->UIControl {
    if let item = overlayView {
        return item
      }else {
        if !(overlayView != nil) {
            #if !SV_APP_EXTENSIONS
                let windowBounds: CGRect? = UIApplication.shared.delegate?.window??.bounds
                overlayView = UIControl(frame: windowBounds!)
            #else
                overlayView = UIControl(frame: UIScreen.main.bounds)
            #endif
            overlayView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlayView?.backgroundColor = UIColor.clear
            overlayView?.addTarget(self, action:#selector(overlayViewDidReceiveTouchEvent(_:for:)) , for: .touchDown)
         }
      }
      return overlayView!
    }
    
   public class func dismiss() {
        LoadingView.sharedInstance.dismiss(withDelay: 0.0) {  }
    }
    
    @objc func overlayViewDidReceiveTouchEvent(_ sender: Any, for event: UIEvent) {
        let touch: UITouch? = event.allTouches?.first
        let touchLocation: CGPoint? = touch?.location(in: self)
        if (ddIndicatorView?.frame.contains(touchLocation!))! {
            
        }
    }
    
  public  func dismiss(withDelay delay: TimeInterval, completion: SVProgressHUDDismissCompletion) {
        ddIndicatorView?.stopAnimating()
        weak var weakSelf: LoadingView? = self
        OperationQueue.main.addOperation({() -> Void in
            let strongSelf: LoadingView? = weakSelf
            if strongSelf != nil {
                let animationsBlock: (() -> Void)?? = {() -> Void in
                    strongSelf?.ddIndicatorView?.transform = (strongSelf?.ddIndicatorView?.transform.scaledBy(x: 0.8, y: 0.8))!
                    strongSelf?.alpha = 0.0
                    strongSelf?.ddIndicatorView?.alpha = 0.0
                }
                let completionBlock: (() -> Void)? = {() -> Void in
                    weakSelf?.overlayView?.removeFromSuperview()
                    weakSelf?.ddIndicatorView?.removeFromSuperview()
                    weakSelf?.titleLabel?.removeFromSuperview()
                    weakSelf?.ddIndicatorView = nil
                    weakSelf?.titleLabel?.text = nil
                }
                animationsBlock!!()
                completionBlock!()
                // Inform iOS to redraw the view hierachy
                strongSelf?.setNeedsDisplay()
            }
        })
    }
    

}
