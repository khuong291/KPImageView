//
//  KPImageView.swift
//  KPImageViewSource
//
//  Created by Khuong Pham on 11/12/16.
//  Copyright © 2016 fantageek. All rights reserved.
//

import UIKit

public protocol KBImageViewDelegate: NSObjectProtocol {
    /**
     *  Asks delegate to return the number of images in slide show.
     *
     *  @param imageView An object that required a number of images.
     *
     *  @return The number of images in slide show.
     */
    func numberOfImagesInImageView(imageView: KPImageView) -> Int
    /**
     *  Asks delegate to return the image for given index.
     *
     *  @param imageView An object that required a number of images.
     *  @param index     An index number identifying image positin in slide show.
     *
     *  @return An image for current index.
     */
    func imageView(imageView: KPImageView, imageForIndex index: Int) -> UIImage
}

let kKBDefaultTimePerImage: CGFloat = 21.0
let kKBDefaultChangeImageTime: CGFloat = 1.0

public class KPImageView: UIImageView {
    
    /**
     *  Timer that reposive for changing of images.
     */
    var timer: Timer = Timer()
    /**
     *  Index of the current selected image in imageView.
     */
    var index: Int = 0
    /**
     *  What kind of animation is currently is used for image.
     */
    var animationState: Int = 0
    /**
     *  What time interval used for every image animation.
     */
    @IBInspectable public var timePerImage: CGFloat = kKBDefaultTimePerImage
    /**
     *  What time interval used for animation changing of images.
     */
    @IBInspectable public var changeImageTime: CGFloat = kKBDefaultChangeImageTime
    /**
     *  `YES` if indexes of images are stops to change. And currently just change `animationState` for same image.
     */
    var indexPause: Bool = false
    
    func isIndexPause() -> Bool {
        return indexPause
    }
    /**
     *  Delegate, that will be used for calls in `KBImageViewDelegate`.
     */
    weak var delegate: KBImageViewDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        index = -1
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(CGFloat(timePerImage - changeImageTime)), target: self, selector: #selector(KPImageView.changeImage), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    deinit {
        timer.invalidate()
    }
    
    func changeImage() {
        if (delegate != nil) && !indexPause {
            index = (index + 1) % (delegate?.numberOfImagesInImageView(imageView: self))!
            
            image = delegate?.imageView(imageView: self, imageForIndex: index)
            
            let transition = CATransition()
            transition.duration = CFTimeInterval(changeImageTime)
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            layer.add(transition, forKey: nil)
        }
        
        animateLayerWithDuration(duration: TimeInterval(timePerImage), changeState: true)
    }
    
    func animateLayerWithDuration(duration: TimeInterval, changeState: Bool) {
        var scale: CGFloat = 0.0
        var moveX: CGFloat = 0.0
        var moveY: CGFloat = 0.0
        
        if changeState {
            animationState = (animationState + 1) % 4;
        }
        
        switch animationState {
        case 0:
            scale = 1.25
            moveX = -(self.frame.size.width * (scale - 1.0))
            moveY = -(self.frame.size.height * (scale - 1.0))
            break
            
        case 1:
            scale = 1.10
            moveX = -(self.frame.size.width * (scale - 1.0))
            moveY = (self.frame.size.height * (scale - 1.0))
            break
            
        case 2:
            scale = 1.15
            moveX = (self.frame.size.width * (scale - 1.0))
            moveY = -(self.frame.size.height * (scale - 1.0))
            break
            
        case 3:
            scale = 1.20
            moveX = (self.frame.size.width * (scale - 1.0))
            moveY = (self.frame.size.height * (scale - 1.0))
            break
            
        default:
            scale = 1
            moveX = -(self.frame.size.width * (scale - 1.0))
            moveY = -(self.frame.size.height * (scale - 1.0))
            break
        }
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        let translationXAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        let translationYAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        
        if let value = layer.presentation()?.value(forKeyPath: "transform.scale") as? CGFloat {
            scaleAnimation.values = [value, scale]
        } else {
            scaleAnimation.values = [layer.transform.m11, scale]
        }
        
        if let value = layer.presentation()?.value(forKeyPath: "transform.translation.x") as? CGFloat {
            translationXAnimation.values = [value, scale]
        } else {
            translationXAnimation.values = [layer.transform.m14, moveX / 2]
        }
        
        if let value = layer.presentation()?.value(forKeyPath: "transform.translation.y") as? CGFloat {
            translationYAnimation.values = [value, scale]
        } else {
            translationYAnimation.values = [layer.transform.m24, moveY / 2]
        }
        
        scaleAnimation.fillMode = kCAFillModeForwards;
        translationXAnimation.fillMode = kCAFillModeForwards;
        translationYAnimation.fillMode = kCAFillModeForwards;
        
        scaleAnimation.isRemovedOnCompletion = false
        translationXAnimation.isRemovedOnCompletion = false
        translationYAnimation.isRemovedOnCompletion = false
        
        scaleAnimation.duration = duration
        translationXAnimation.duration = duration
        translationYAnimation.duration = duration
        
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        translationXAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        translationYAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        layer.add(scaleAnimation, forKey: "transform.scale")
        layer.add(translationYAnimation, forKey: "transform.translation.x")
        layer.add(translationXAnimation, forKey: "transform.translation.y")
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        animateLayerWithDuration(duration: timer.fireDate.timeIntervalSince1970 - NSDate().timeIntervalSince1970, changeState: false)
    }
}


















