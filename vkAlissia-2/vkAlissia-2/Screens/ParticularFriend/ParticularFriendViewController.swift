//
//  CertainFriendViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import SDWebImage

class ParticularFriendViewController: BaseViewController {
    
    // UI
    @IBOutlet private weak var collectiovView: UICollectionView! {
        didSet {
            collectiovView.dataSource = self
            collectiovView.delegate = self
        }
    }
    var publicCollectiovView: UICollectionView {
        collectiovView
    }
    
    let interactiveTransition = InteractiveTransition()
    
    // Some properties
    var friendName: String?
    var photos: [PhotoData] = []
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectiovView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 202, height: 202)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    // MARK: - Major methods
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.loadPhotos() { [weak self] result in
            
            switch result {
            case let .success(photoItems):
                let photos: [PhotoData] = photoItems.map { PhotoData(photoItem: $0) }
                DispatchQueue.main.async {
                    self?.photos = photos
                    self?.collectiovView.reloadData()
                    completion?()
                }
            case let .failure(error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}


// MARK: - UICollectionViewDataSource
extension ParticularFriendViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticularFriendCell", for: indexPath) as? ParticularFriendCell else { fatalError() }
        let photo = photos[indexPath.row]
        
        cell.nameLabel.text = friendName
        
        // value of "6" is the best quality image of the VK photos to .get
        cell.favoriteImageView.sd_setImage(with: URL(string: photo.sizes[6].url))
        
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
