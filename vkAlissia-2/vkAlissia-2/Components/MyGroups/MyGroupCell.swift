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
    let insetet: CGFloat = 10
    let imageSideLength: CGFloat = 80
    
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
        setMyGroupNameLabelFrame()
        myGroupAvatarView.sd_setImage(with: URL(string: groupAvatarURL))
        setMyGroupAvatarViewFrame()
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Major methods
    
    private func calculateLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - imageSideLength - insetet * 3
        
        let textBlockSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let curText = text as NSString
        let rect = curText.getBoundingRect(textBlock: textBlockSize, font: font)
        
        let width = ceil (Double(rect.size.width))
        let height = ceil (Double(rect.size.height))
        
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
    func setMyGroupNameLabelFrame() {
        let weatherLabelSize = calculateLabelSize(text: myGroupNameLabel.text ?? "", font: .preferredFont(forTextStyle: .title1))
        
        let y = ceil (bounds.midY - weatherLabelSize.height / 2)
        
        let origin = CGPoint(x: insetet, y: y)
        
        myGroupNameLabel.frame = CGRect(origin: origin, size: weatherLabelSize)
    }
    
    func setMyGroupAvatarViewFrame() {
        let imageSize = CGSize(width: imageSideLength, height: imageSideLength)
        
        let x = ceil (bounds.width - imageSideLength - insetet)
        let y = ceil (bounds.midY - imageSideLength / 2)
        
        let origin = CGPoint( x: x, y: y )
        
        myGroupAvatarView.frame = CGRect(origin: origin, size: imageSize)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setMyGroupNameLabelFrame()
        setMyGroupAvatarViewFrame()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
