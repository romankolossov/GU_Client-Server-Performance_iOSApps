//
//  AppViewController.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 12.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
    
    let networkManager = NetworkManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkManager.getData(for: "groups")
        networkManager.getData(for: "friends")
        //networkManager.loadData(for: "photos")
    }
}
