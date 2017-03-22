//
//  CWCoreTextView.swift
//  CoreTextDemo_Swift
//
//  Created by cxjwin on 10/16/14.
//  Copyright (c) 2014 cxjwin. All rights reserved.
//

import UIKit

let kTouchedLinkNotification = "kTouchedLinkNotification"
let kCWInvalidRange = NSMakeRange(NSNotFound, 0)

class CWCoreTextView: UIView, NSLayoutManagerDelegate {
	
	var layoutManager: CWLayoutManager
	var textContainer: NSTextContainer
	var touchesGestureRecognizer: CWTouchesGestureRecognizer?
	
	var touchRange = kCWInvalidRange
	
	var textStorage: NSTextStorage? {
		didSet {
			if let _textStorage: NSTextStorage = textStorage {
				_textStorage.addLayoutManager(layoutManager)
				self.setNeedsUpdateConstraints()
				self.setNeedsDisplay()
			}
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		layoutManager = CWLayoutManager()
		textContainer = NSTextContainer(size: CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude))
		
		super.init(coder: aDecoder)!
		
		layoutManager.delegate = self
		layoutManager.addTextContainer(textContainer)
		
		touchesGestureRecognizer = CWTouchesGestureRecognizer(target: self, action: #selector(CWCoreTextView.handleTouch(_:)))
		self.addGestureRecognizer(touchesGestureRecognizer!)
	}
	
	override func draw(_ rect: CGRect) {
		if let _: NSTextStorage = textStorage {
			let glyphRange = layoutManager.glyphRange(for: textContainer)
			let point = layoutManager.location(forGlyphAt: glyphRange.location)
			layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: point)
		}
	}
	
	func handleTouch(_ gestureRecognizer: UIGestureRecognizer) {
		let state = gestureRecognizer.state
		
		switch state {
			// began
		case .began :
			var location = gestureRecognizer.location(in: self)
			let startPoint = layoutManager.location(forGlyphAt: 0)
			location = CGPoint(x: location.x - startPoint.x, y: location.y - startPoint.y)
			
			var fraction: CGFloat = 0
			let index = layoutManager.glyphIndex(for: location, in: textContainer, fractionOfDistanceThroughGlyph: &fraction)
			
			if (0.01 < fraction && fraction < 0.99) {
				var effectiveRange: NSRange = kCWInvalidRange
				let value: AnyObject? = textStorage?.attribute(NSLinkAttributeName, at: index, effectiveRange: &effectiveRange) as AnyObject?
				if let _value: AnyObject = value {
					touchRange = effectiveRange
					layoutManager.touchRange = touchRange
					layoutManager.isTouched = true
					
					NotificationCenter.default.post(name: Notification.Name(rawValue: kTouchedLinkNotification), object: _value)
					self.setNeedsDisplay()
				} else {
					touchRange = kCWInvalidRange
				}
			}
			
			// end or canceled
		case .ended, .cancelled :
			if (touchRange.location != NSNotFound) {
				touchRange = kCWInvalidRange
				layoutManager.isTouched = false
				self.setNeedsDisplay()
			}
			
			// other
		default :
			//println("do nothing")
			break
		}
	}
	
	override var intrinsicContentSize : CGSize {
		let rect = layoutManager.usedRect(for: textContainer)
		let width = rect.width + 30.0
		let height = rect.height + 20.0
		return CGSize(width: ceil(width), height: ceil(height))
	}
}


class CWLayoutManager: NSLayoutManager {
	var touchRange = kCWInvalidRange
	var isTouched = false
	
	override func drawUnderline(forGlyphRange glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: CGRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: CGPoint) {
		
		let firstPosition = self.location(forGlyphAt: glyphRange.location).x
		
		var lastPosition: CGFloat
		
		if NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange) {
			lastPosition = self.location(forGlyphAt: NSMaxRange(glyphRange)).x
		} else {
			lastPosition = self.lineFragmentUsedRect(forGlyphAt: NSMaxRange(glyphRange) - 1, effectiveRange:nil).size.width
		}
		
		var tempRect = lineRect
		
		tempRect.origin.x = tempRect.origin.x + firstPosition
		tempRect.size.width = lastPosition - firstPosition
		tempRect.size.height = tempRect.size.height - baselineOffset + 2
		
		tempRect.origin.x = floor(tempRect.origin.x + containerOrigin.x)
		tempRect.origin.y = floor(tempRect.origin.y + containerOrigin.y)
		
		let tempRange = NSIntersectionRange(touchRange, glyphRange)
		if (isTouched && tempRange.length != 0) {
			UIColor.purple.set()
		} else {
			UIColor.green.set()
		}
		
		UIBezierPath(rect: tempRect).fill()
	}
}
