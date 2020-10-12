//
//  GetDataOperation.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 24.09.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation

class GetDataOperation: AsyncOperation {
    
    private let networkManager = NetworkManager.shared
    private let realmManager = RealmManager.shared
    
    override func main() {
        networkManager.loadGroups() { [weak self] result in
            
            switch result {
            case let .success(groupItems):
                let groups: [GroupData] = groupItems.map {GroupData(groupItem: $0)}
                DispatchQueue.main.async { [weak self] in
                    try? self?.realmManager?.add(objects: groups)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        
            self.state = .finished
    }
}
