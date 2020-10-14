//
//  MyGroupCell.swift
//  vkAlissia
//
//  Created by Роман Колосов on 19.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import SDWebImage

class MyGroupCell: UITableViewCell {
    @IBOutlet weak var myGroupNameLabel: UILabel! {
        didSet {
            myGroupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var myGroupAvatarView: UIImageView! {
        didSet {
            myGroupAvatarView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    let inset: CGFloat = 10
    let avatarSideLength: CGFloat = 80
    let labelFont: UIFont = .preferredFont(forTextStyle: .body)
    
    // View model
    var groupModel: GroupData? {
        didSet {
            setup()
        }
    }
    
    // Build data
    private func setup() {
        guard let groupModel = groupModel else { return }
        
        //let id = groupModel.id.value ?? -1
        let groupName = groupModel.groupName
        let groupAvatarURL = groupModel.groupAvatarUrl
        
        myGroupNameLabel.text = groupName
        myGroupAvatarView.sd_setImage(with: URL(string: groupAvatarURL))
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myGroupNameLabel.font = labelFont
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setMyGroupNameLabelFrame()
        setMyGroupAvatarViewFrame()
    }
    
    // MARK: Major methods
    
    private func calculateLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - avatarSideLength - inset * 3
        
        let textBlockSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let curText = text as NSString
        let rect = curText.getBoundingRect(textBlock: textBlockSize, font: font)
        
        let width = ceil (Double(rect.size.width))
        let height = ceil (Double(rect.size.height))
        
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
    func setMyGroupNameLabelFrame() {
        let myGroupNameLabelSize = calculateLabelSize(text: myGroupNameLabel.text ?? "", font: labelFont)
        
        let y = ceil (bounds.midY - myGroupNameLabelSize.height / 2)
        
        let origin = CGPoint(x: inset, y: y)
        
        myGroupNameLabel.frame = CGRect(origin: origin, size: myGroupNameLabelSize)
    }
    
    func setMyGroupAvatarViewFrame() {
        let imageSize = CGSize(width: avatarSideLength, height: avatarSideLength)
        
        let x = ceil (bounds.width - avatarSideLength - inset)
        let y = ceil (bounds.midY - avatarSideLength / 2)
        
        let origin = CGPoint( x: x, y: y )
        
        myGroupAvatarView.frame = CGRect(origin: origin, size: imageSize)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
