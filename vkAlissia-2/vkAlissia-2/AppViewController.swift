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
    var jsonArray: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkManager.getData(for: "groups", with: "get")
        //networkManager.getData(for: "friends", with: "get")
        //networkManager.getData(for: "photos", with: "get")
        //networkManager.getData(for: "groups", with: "search")
    }
    
    @IBAction func printJsonButton(_ sender: Any) {
        print(jsonArray)
    }
}

// MARK: NetworkManagerDelegate
extension AppViewController: NetworkManagerDelegate {
    func saveJson(_ json: Any) {
        jsonArray.append(json)
    }
}
