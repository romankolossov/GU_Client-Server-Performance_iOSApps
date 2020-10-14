//
//  String+Extensions.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 13.10.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

extension NSString {
    
    func getBoundingRect(textBlock: CGSize, font: UIFont) -> CGRect {
        
        let rect = boundingRect(
            with: textBlock,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        
        return rect
    }
    
}
