//
//  CertainFriendViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class ParticularFriendViewController: UIViewController {
    // MARK: - UI
    @IBOutlet weak var collectiovView: UICollectionView!
    
    // MARK: - Constants & variables
    let interactiveTransition = InteractiveTransition()
    
    var friendName: String?
    var favoriteImages: [UIImage] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectiovView.dataSource = self
        collectiovView.delegate = self
        
        if let layout = collectiovView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 202, height: 202)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ParticularFriendViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return favoriteImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticularFriendCell", for: indexPath) as? ParticularFriendCell else { fatalError() }
        
        cell.nameLabel.text = friendName
        cell.favoriteImageView.image = favoriteImages[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ParticularFriendViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let friendPhotoVC = storyboard?.instantiateViewController(identifier: "FriendPhotoVC") as? FriendPhotoViewController else { return }
        
        friendPhotoVC.favoriteImages = favoriteImages
        friendPhotoVC.nameLabel.text = friendName
        friendPhotoVC.currentIndex = indexPath.row
        
        navigationController?.delegate = self
        navigationController?.pushViewController(friendPhotoVC, animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension ParticularFriendViewController: UINavigationControllerDelegate {


    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
                              -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController)
                              -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            self.interactiveTransition.viewController = toVC
            
            return PushAnimator()
        } else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return PopAnimator()
        }
        return nil
    }

}
