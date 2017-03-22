//
//  ViewController.swift
//  CoreTextDemo_Swift
//
//  Created by cxjwin on 10/15/14.
//  Copyright (c) 2014 cxjwin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var textView: CWCoreTextView!
	
	var observer: AnyObject?
	
	deinit {
		if observer != nil {
			NotificationCenter.default.removeObserver(observer!)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
		let text = "http://t.cn/123QHz http://t.cn/1er6Hz [兔子][熊猫][给力][浮云][熊猫]   http://t.cn/1er6Hz [熊猫][熊猫][熊猫][熊猫] Hello World 你好世界[熊猫][熊猫]熊猫aaaaaaa[熊猫] Hello World 你好世界[熊猫][熊猫]熊猫aaaaaaa[熊猫] Hello World 你好世界[熊猫][熊猫]熊猫aaaaaaa[熊猫] Hello World 你好世界[熊猫][熊猫]熊猫aaaaaaa[熊猫] http://t.cn/6gb0Hz Hello World 你好世界[熊猫][熊猫]熊猫aaaaaaa"
		
        let storage = text.transformText()
		
		let paragraphStyle: NSParagraphStyle = {
			let paragraphStyle = NSMutableParagraphStyle()
			
			paragraphStyle.lineSpacing = 5
			paragraphStyle.paragraphSpacing = 15
			paragraphStyle.alignment = .left
			paragraphStyle.firstLineHeadIndent = 5
			paragraphStyle.headIndent = 5
			paragraphStyle.tailIndent = 180
			paragraphStyle.lineBreakMode = .byWordWrapping
			paragraphStyle.minimumLineHeight = 10
			paragraphStyle.maximumLineHeight = 20
			paragraphStyle.baseWritingDirection = .natural
			paragraphStyle.lineHeightMultiple = 0.8
			paragraphStyle.hyphenationFactor = 2
			paragraphStyle.paragraphSpacingBefore = 0
			
			return paragraphStyle.copy() as! NSParagraphStyle
		}()
		
		let range = NSMakeRange(0, storage.length)
		storage.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: range)
		
		storage.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
		
        textView.textStorage = storage
		
		observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: kTouchedLinkNotification), object: nil,
			queue: OperationQueue.main) {
				(note: Notification!) -> Void in
				
				print("\(note.object!)")
				
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
}

