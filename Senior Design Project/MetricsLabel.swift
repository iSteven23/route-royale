//
//  MeticsView.swift
//  Route Royale
//
//  Created by Steven Sanchez on 2/4/19.
//  Copyright © 2019 Aaron Dahlin. All rights reserved.
//

import UIKit
@IBDesignable
class MetricsLabel: UILabel {

/*    struct Padding {
        static var widthInset: CGFloat = 0.0
        static var heightInset: CGFloat = 8.0
        
        static var symmetricInset: CGFloat {
            return widthInset + heightInset
        }
        
    }*/
    
    var smallFont: UIFont {
        var newFont: UIFont?
        attributedText?.enumerateAttribute(.font, in: NSRange(0..<(attributedText?.length ?? 0)), options: .longestEffectiveRangeNotRequired) { value, range, stop in
            if let font = value as? UIFont {
                if font.fontDescriptor.pointSize < 15 {
                    newFont = font
                }
            }
        }
        return newFont ?? UIFont.preferredFont(forTextStyle: .title2).withSize(13.0)
    }
    
    enum Units: String {
        case miles = "miles"
        case speed = "mph"
        case second = "s"
    }
  
    var mutableAttributedText: String? {
        set {
            switch tag {
            case 0:
                setSuffixFontSize(with: .miles, of: newValue)
            case 1:
                setSuffixFontSize(with: .speed, of: newValue)
            case 2:
                setSuffixFontSize(with: .second, of: newValue)
            default:
                print("none")
                /*
                let mutableAttributedString = attributedText?.mutableCopy() as? NSMutableAttributedString
                if let attrStr = mutableAttributedString, let s = mutableAttributedText {
                    attrStr.enumerateAttribute(.font, in: NSRange(0..<1), options: .reverse) { value, range, stop in
                        if let font = value as? UIFont {
                            attrStr.mutableString.setString(newValue ?? "0")
                            let unitStringBegin = s.firstIndex(where: { $0 > "A" && $0 < "z"}) ?? s.endIndex
                            let rangeUnits = unitStringBegin..<s.endIndex
                            let startPos = s.distance(from: s.startIndex, to: rangeUnits.lowerBound)
                            let endPos = s.distance(from: s.startIndex, to: rangeUnits.upperBound)
                            let nsrange = NSRange(location: startPos, length: endPos)
                            attrStr.addAttribute(.font, value: font, range: nsrange)
                        }
                    }
                    
                }*/
                
            }
        }
        get {
            return attributedText?.string
        }

    }
    
    private func setSuffixFontSize(with suffixString: Units, of fullString: String?) {
        let mutableAttributedString = attributedText?.mutableCopy() as? NSMutableAttributedString
        
        if let attrStr = mutableAttributedString, let s = mutableAttributedString?.string {
            attrStr.mutableString.setString(fullString ?? "0")
            let rangeUnits = attrStr.string.range(of: suffixString.rawValue)
            if let rangeUnits = rangeUnits {
                let nsrange = NSRange(rangeUnits, in: s)
                attrStr.addAttribute(.font, value: smallFont, range: nsrange)
                attributedText = attrStr
            }
            
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor(red: 0.16, green: 0.5, blue: 0.73, alpha: 0.2).cgColor
        layer.borderWidth = 3.5
        layer.cornerRadius = self.frame.width / 2.0
        
    }
    

    
}


