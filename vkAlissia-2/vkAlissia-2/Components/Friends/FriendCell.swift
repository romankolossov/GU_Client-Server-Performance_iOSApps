//
//  FriendCell.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var friendAvatarView: UIImageView! {
        didSet {
            friendAvatarView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    let inset: CGFloat = 30
    let avatarSideLength: CGFloat = 80
    let nameLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
    
    // View model
    var friendModel: FriendData? {
        didSet {
            setup()
        }
    }
    
    // Build data
    private func setup() {
        guard let friendModel = friendModel else { return }
        
        //let id = friendModel.id.value ?? -1
        let friendName = friendModel.friendName
        let friendAvatarURL = friendModel.friendAvatarURL
        
        nameLabel.text = friendName
        friendAvatarView.sd_setImage(with: URL(string: friendAvatarURL))
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setNameLabelFrame()
        setFriendAvatarViewFrame()
        //setShadowViewFrame()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = nameLabelFont
        
        shadowView?.layer.cornerRadius = shadowView.bounds.height / 2
        shadowView?.layer.shadowColor = UIColor.black.cgColor
        shadowView?.layer.shadowOpacity = 30
        shadowView?.layer.shadowRadius = 11
        shadowView?.layer.shadowOffset = CGSize(width: 6, height: 6)
        shadowView?.layer.shadowPath = UIBezierPath(ovalIn: shadowView.bounds).cgPath
        
        friendAvatarView?.layer.cornerRadius = friendAvatarView.bounds.height / 2
        friendAvatarView?.contentMode = .scaleAspectFill
        friendAvatarView?.clipsToBounds = true
        
        friendAvatarView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onAvatarTapped(_:)))
        friendAvatarView.addGestureRecognizer(gesture)
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
    
    func setNameLabelFrame() {
        let nameLabelSize = calculateLabelSize(text: nameLabel.text ?? "", font: nameLabelFont)
        
        let y = ceil (bounds.midY - nameLabelSize.height / 2)
        
        let origin = CGPoint(x: inset, y: y)
        
        nameLabel.frame = CGRect(origin: origin, size: nameLabelSize)
    }
    
    func setFriendAvatarViewFrame() {
        let imageSize = CGSize(width: avatarSideLength, height: avatarSideLength)
        
        let x = ceil (bounds.width - avatarSideLength - inset)
        let y = ceil (bounds.midY - avatarSideLength / 2)
        
        let origin = CGPoint( x: x, y: y )
        
        friendAvatarView.frame = CGRect(origin: origin, size: imageSize)
        shadowView.frame = CGRect(origin: origin, size: imageSize)
    }
    
    // MARK: Actions
    
    @objc func onAvatarTapped(_ gesture: UIGestureRecognizer) {
        animateAvatarView()
        //        sendActions(for: .valueChanged)
    }
    
    // MARK: Animations
    
    func animateAvatarView() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.byValue = 1
        animation.stiffness = 230
        animation.mass = 1.3
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        friendAvatarView.layer.add(animation, forKey: nil)
        shadowView.layer.add(animation, forKey: nil)
    }
}
