//
//  AppViewController.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 16.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
    
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    @IBAction func printJsonButton(_ sender: Any) {
        
//        networkManager.loadGroups() {result in
//            switch result {
//            case let .success(groups):
//                for group in groups {
//                    print(group.name)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
//
//        networkManager.loadFriends() {result in
//            switch result {
//            case let .success(friends):
//                for friend in friends {
//                    print(friend.firstName)
//                    print(friend.city)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
        
        networkManager.loadPhotos {result in
            switch result {
            case let .success(photos):
                for photo in photos {
                    print(photo.userID)
                }
            case let .failure(error):
                print(error)
            }
        }

    }
}
