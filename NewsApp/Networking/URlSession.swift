//
//  URlSession.swift
//  NewsApp
//
//  Created by Navroz on 28/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import UIKit

enum Operation: String {
    case GET, POST
}
class URlSession: NSObject {
    private let APIKEY = "669fd7271d444d819fe80c0aac75a4a5"
    static let handler = URlSession()
    let cache = NSCache<AnyObject, AnyObject>()

    func request(url:URL, parameter:[String: Any]? = nil, operation: Operation = .GET, completion :@escaping (Data?,Error?)->()) {
        var request = URLRequest(url: url)
        request.addValue(APIKEY, forHTTPHeaderField: "Authorization")
        request.httpMethod = operation.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data,error)
            }
        }
        task.resume()
    }
}
