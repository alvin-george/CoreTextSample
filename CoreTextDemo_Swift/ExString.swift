//
//  ExString.swift
//  CoreTextDemo_Swift
//
//  Created by cxjwin on 10/15/14.
//  Copyright (c) 2014 cxjwin. All rights reserved.
//

import Foundation
import UIKit

extension String {
    fileprivate struct _OnceEmojiDict {
        static let emojiDict: NSDictionary? = {
            let path = Bundle.main.path(forResource: "emotionImage", ofType: "plist")
            return NSDictionary(contentsOfFile: path!)
        }()
    }
    
    var emojiDict: NSDictionary {
        return _OnceEmojiDict.emojiDict!
    }
    
    func transformText() -> NSTextStorage {
        let textStorage = NSTextStorage()
        
        var objcString: NSString = self as NSString;
        
        // emoji
        let regex_emoji = "\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
        
        let exp_emoji = try! NSRegularExpression(pattern: regex_emoji, options: [.caseInsensitive,.dotMatchesLineSeparators])
        
       // let exp_emoji = NSRegularExpression(pattern: regex_emoji, options: .CaseInsensitive | .DotMatchesLineSeparators, error: nil)
        
        let emojis = exp_emoji.matches(in: objcString as String, options: .reportCompletion, range: NSMakeRange(0, objcString.length))
        
        var location: Int = 0
				
		for result in emojis {
            let range = result.range
			
            let subStr = objcString.substring(with: NSMakeRange(location, range.location - location))
            let attSubStr = NSAttributedString(string: subStr)
            textStorage.append(attSubStr)
            
            location = NSMaxRange(range)
            
            let emojiKey = objcString.substring(with: range)
            
            let imageName: String? = emojiDict[emojiKey] as? String
            
            if (imageName != nil) {
                let image = UIImage(named: imageName!)
                let attachment = NSTextAttachment()
                attachment.image = image
                attachment.bounds = CGRect( x: 0, y: -3, width : 14,  height : 14)
                let attachmentStr = NSAttributedString(attachment: attachment)
                textStorage.append(attachmentStr)
            } else {
                let emojiStr = NSAttributedString(string: emojiKey)
                textStorage.append(emojiStr)
            }
        }
        
        if (location < objcString.length) {
            let subStr = objcString.substring(with: NSMakeRange(location, objcString.length - location))
            let attSubStr = NSAttributedString(string: subStr)
            textStorage.append(attSubStr)
        }
        
        // reset string
        objcString = textStorage.string as NSString;
        
        // short link
        let regex_http = "http://t.cn/[a-zA-Z0-9]+"
        let exp_http = try! NSRegularExpression(pattern: regex_http, options: [.caseInsensitive,.dotMatchesLineSeparators])
       // let exp_http = NSRegularExpression(pattern: regex_http, options: .CaseInsensitive | .DotMatchesLineSeparators, error: nil)
        
        let https = exp_http.matches(in: objcString as String, options: .reportProgress, range: NSMakeRange(0, objcString.length))
        
        for result in https {
            let range = result.range
            textStorage.addAttribute(NSLinkAttributeName, value: objcString.substring(with: range), range: range)
        }
        
        return textStorage
    }
    
}
