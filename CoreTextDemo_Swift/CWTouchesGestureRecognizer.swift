//
//  CWTouchesGestureRecognizer.swift
//  CoreTextDemo_Swift
//
//  Created by cxjwin on 10/16/14.
//  Copyright (c) 2014 cxjwin. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class CWTouchesGestureRecognizer: UIGestureRecognizer {
	var startPoint: CGPoint?
	
	override init(target: Any?, action: Selector?) {
		super.init(target: target, action: action)
	}
	
	func touchesBegan(_ touches: Set<NSObject>!, with event: UIEvent!) {
		let touch: UITouch? = touches.first as? UITouch
		startPoint = touch!.location(in: self.view!)
		self.state = .began
	}
	
	func touchesMoved(_ touches: Set<NSObject>!, with event: UIEvent!) {
		let touch: UITouch? = touches.first as? UITouch
		let currentPoint = touch!.location(in: self.view!)
		
		let distanceX = currentPoint.x - startPoint!.x
		let	distanceY = currentPoint.y - startPoint!.y
		let distance = sqrt(distanceX * distanceX + distanceY * distanceY)
		
		if distance > 10.0 {
			self.state = .cancelled
		} else {
			self.state = .changed
		}
	}
	
	func touchesEnded(_ touches: Set<NSObject>!, with event: UIEvent!) {
		self.state = .ended
	}
	
	 func touchesCancelled(_ touches: Set<NSObject>!, with event: UIEvent!) {
		self.state = .cancelled
	}
	
	override func reset() {
		self.state = .possible
	}
}
