//
//  ParticularFriendViewController+CollectionView.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 06.09.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource

extension ParticularFriendViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticularFriendCell", for: indexPath) as? ParticularFriendCell else { fatalError() }
        
        let photo = photos[indexPath.row]
        
        cell.lookConfigure(with: photo,
                           friendName: friendName,
                           photoService: publicParticularFriendPhotoService,
                           indexPath: indexPath)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ParticularFriendViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let friendPhotoVC = storyboard?.instantiateViewController(identifier: "FriendPhotoVC") as? FriendPhotoViewController else { return }
        
        friendPhotoVC.photos = photos
        friendPhotoVC.nameLabel.text = friendName
        friendPhotoVC.currentIndex = indexPath.row
        
        navigationController?.delegate = self
        navigationController?.pushViewController(friendPhotoVC, animated: true)
    }
}

// MARK: - UINavigationControllerDelegate

extension ParticularFriendViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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

