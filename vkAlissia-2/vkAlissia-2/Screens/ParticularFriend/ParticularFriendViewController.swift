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
    let interactiveTransition = InteractiveTransition()
    
    // Some properties
    var friendName: String?
    var photos: [PhotoData] = []
    
    private let networkManager = NetworkManager.shared
    private var particularFriendPhotoService: ParticularFriendPhotoService?
    var publicParticularFriendPhotoService: ParticularFriendPhotoService? {
        particularFriendPhotoService
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        particularFriendPhotoService = ParticularFriendPhotoService(container: collectiovView)
        
        loadData()
        
        if let layout = collectiovView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 202, height: 202)
        }
    }
    
    // MARK: - Major methods
    
    private func loadData(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.loadPhotos() { [weak self] result in
                
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
}
