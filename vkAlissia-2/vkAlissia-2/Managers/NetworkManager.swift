//
//  NetworkManager.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 12.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    // Some properties
    enum NetworkError: Error {
        case incorrectData
    }
    
    enum Method: String {
        case groupsGet = "groups.get"
        case friendsGet = "friends.get"
        case photosGet = "photos.get"
        case groupsSearch = "groups.search"
    }
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        //configuration.allowsCellularAccess = false
        let session =  URLSession(configuration: configuration)
        return session
    }()
    
    let vkAPIVersion: String = "5.122"
    
     // MARK: - Major methods
    
    func networkRequest(for method: Method, completion: ((Result<[Any], Error>) -> Void)? = nil) {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/\(method.rawValue)"
        
        switch method {
        case .groupsGet:
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: Session.shared.token),
                URLQueryItem(name: "user_id", value: "\(Session.shared.userId)"),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        case .friendsGet:
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: Session.shared.token),
                URLQueryItem(name: "user_id", value: "\(Session.shared.userId)"),
                URLQueryItem(name: "order", value: "random"),
                URLQueryItem(name: "offset", value: "5"),
                URLQueryItem(name: "fields", value: "city,country,domain,photo_50"),
                URLQueryItem(name: "name_case", value: "nom"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        case .photosGet:
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: Session.shared.token),
                //URLQueryItem(name: "owner_id", value: "-1"),
                URLQueryItem(name: "owner_id", value: String(Session.shared.userId)),
                URLQueryItem(name: "album_id", value: "profile"),
                URLQueryItem(name: "rev", value: "0"),
                URLQueryItem(name: "offset", value: "0"),
                URLQueryItem(name: "count", value: "3"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        default:
            print("error: \(method.rawValue) is out of range")
            return
        }
        
        guard let url = urlConstructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.allowsCellularAccess = false
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                switch method {
                case .friendsGet:
                    do {
                        let friends = try JSONDecoder().decode(FriendQuery.self, from: data).response.items
                        completion?(.success(friends))
                    } catch {
                        completion?(.failure(error))
                    }
                case .groupsGet:
                    do {
                        let groups = try JSONDecoder().decode(GroupQuery.self, from: data).response.items
                        completion?(.success(groups))
                    } catch {
                        completion?(.failure(error))
                    }
                case .photosGet:
                    do {
                        let photos = try JSONDecoder().decode(PhotoQuery.self, from: data).response.items
                        completion?(.success(photos))
                    } catch {
                        completion?(.failure(error))
                    }
                default:
                    print("error: \(method.rawValue) is out of range")
                    return
                }
            } else if let error = error {
                completion?(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - Network load methods
    
    func loadFriends(completion: ((Result<[FriendItem], NetworkError>) -> Void)? = nil) {
        networkRequest(for: .friendsGet) {result in
            switch result {
            case let .success(friends):
                completion?(.success(friends as! [FriendItem]))
            case .failure:
                completion?(.failure(.incorrectData))
            }
        }
    }
    
    func loadGroups(completion: ((Result<[GroupItem], NetworkError>) -> Void)? = nil) {
        networkRequest(for: .groupsGet) {result in
            switch result {
            case let .success(groups):
                completion?(.success(groups as! [GroupItem]))
            case .failure:
                completion?(.failure(.incorrectData))
            }
        }
    }
    
    func loadPhotos(completion: ((Result<[PhotoItem], NetworkError>) -> Void)? = nil) {
        networkRequest(for: .photosGet) {result in
            switch result {
            case let .success(photos):
                completion?(.success(photos as! [PhotoItem]))
            case .failure:
                completion?(.failure(.incorrectData))
            }
        }
    }
}
