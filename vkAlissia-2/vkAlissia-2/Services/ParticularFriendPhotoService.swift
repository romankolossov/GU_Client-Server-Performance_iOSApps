//
//  ParticularFriendPhotoService.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 03.10.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation
import UIKit

fileprivate protocol DataReloadable {
    func reloadRow(atIndexPath indexPath: IndexPath)
}

class ParticularFriendPhotoService {
    
    //    static let sharedManager: SessionManager = {
    //        let config = URLSessionConfiguration.default
    //
    //        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
    //        config.timeoutIntervalForRequest = 40
    //
    //        let manager = Alamofire.SessionManager(configuration: config)
    //
    //        return manager
    //    }()
    
    
    // Some properties
    enum NetworkError: Error {
        case incorrectData
    }
    
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cashesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return pathName
        }
        
        let url = cashesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        //configuration.allowsCellularAccess = false
        let session =  URLSession(configuration: configuration)
        return session
    }()
    let vkAPIVersion: String = "5.122"
    
    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    private var images = [String: UIImage]()
    private let container: DataReloadable
    
    init(container: UITableView) {
        self.container = Table(tableView: container)
    }
    init(container: UICollectionView) {
        self.container = Collection(collectionView: container)
    }
    
    // MARK: - Major methods
    
    func networkRequest(completion: ((Result<[PhotoData], Error>) -> Void)? = nil) {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/photos.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "owner_id", value: String(Session.shared.friendId)),
            //URLQueryItem(name: "album_id", value: "profile"),
            URLQueryItem(name: "album_id", value: "wall"),
            URLQueryItem(name: "rev", value: "0"),
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "count", value: "30"),
            URLQueryItem(name: "v", value: vkAPIVersion)
        ]
        
        guard let url = urlConstructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.allowsCellularAccess = false
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let photoItems = try JSONDecoder().decode(PhotoQuery.self, from: data).response.items
                    let photos: [PhotoData] = photoItems.map { PhotoData(photoItem: $0) }
                    completion?(.success(photos))
                } catch {
                    completion?(.failure(error))
                }
            } else if let error = error {
                completion?(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    private func getFilePath(url: String) -> String? {
        guard let cashesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let hashName = url.split(separator: "/").last ?? "default"
        
        return cashesDirectory.appendingPathComponent(ParticularFriendPhotoService.pathName + "/" + hashName).path
    }
    
    private func saveImageToCache(url: String, image: UIImage) {
        guard let fileLocalyPath = getFilePath(url: url),
            let data = image.pngData()
            else { return }
        
        FileManager.default.createFile(atPath: fileLocalyPath, contents: data, attributes: nil)
    }
    
    private func getImageFromCache(url: String) -> UIImage? {
        guard let fileLocalyPath = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: fileLocalyPath),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
            else { return nil }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileLocalyPath)
            else { return nil }
        
        DispatchQueue.main.async { [weak self] in
            self?.images[url] = image
        }
        
        return image
    }
    
    private func loadPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) {
        DispatchQueue.global().async { [weak self] in
            self?.networkRequest() { [weak self] result in
                
                switch result {
                case let .success(photosData):
                    let photoData = photosData[indexPath.row]
                    // value of "6" (.last) is the best quality image of the VK photos to .get
                    #if DEBUG
                    print("PHOTO DATA: \(#function), \(photoData)")
                    #endif
                    guard let photoStringURL = photoData.sizes.last?.url else {
                        print("error: nill value of 'photo.sizes.last' in:\n\(#function)\n at line: \(#line - 1)")
                        fatalError()
                    }
                    
                    let photoURL = URL(string: photoStringURL)
                    
                    let data = try? Data(contentsOf: photoURL!)
                    let image = UIImage(data: data!)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.images[url] = image
                    }
                case let .failure(error):
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                }
            }
        }
    }
    
//    private func loadPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) {
//        ParticularFriendPhotoService.sharedManager.request(url).responseData(
//            queue: DispatchQueue.global(),
//            completionHandler: { [weak self] response in
//                guard let data = response.data,
//                    let image = UIImage(data: data)
//                    else  { return }
//
//                DispatchQueue.main.async { [weak self] in
//                    self?.images[url] = image
//                }
//
//                self?.saveImageToCache(url: url, image: image)
//
//                DispatchQueue.main.async { [weak self] in
//                    self?.container.reloadRow(atIndexPath: indexPath)
//                }
//            }
//        )
//    }
    
    func getPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
        
        if let photo = images[url] {
            print("\(url) : ОПЕРАТИВНАЯ ПАМЯТЬ")
            image = photo
        } else if let photo = getImageFromCache(url: url) {
            print("\(url) : ФИЗИЧЕСКАЯ ПАМЯТЬ")
            image = photo
        } else {
            print("\(url) : ЗАГРУЗКА ИЗ СЕТИ")
            loadPhoto(atIndexPath: indexPath, byUrl: url)
        }
        
        return image
    }
}


// MARK: - DataReloadable

extension ParticularFriendPhotoService {
    
    private class Table: DataReloadable {
        let tableView: UITableView
        
        init(tableView: UITableView) {
            self.tableView = tableView
        }
        func reloadRow(atIndexPath indexPath: IndexPath) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private class Collection: DataReloadable {
        let collectionView: UICollectionView
        
        init(collectionView: UICollectionView) {
            self.collectionView = collectionView
        }
        func reloadRow(atIndexPath indexPath: IndexPath) {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
