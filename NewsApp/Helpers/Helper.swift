//
//  Helper.swift
//  NewsApp
//
//  Created by Navroz on 28/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import Foundation

class Helper: NSObject {
    class func  dataToCodable<T: Codable>(_ jsonData: Data?) throws -> T?  {
        guard let jsonData = jsonData else {return nil}
        do {
            let codable = try JSONDecoder().decode(T.self, from: jsonData)
            return codable
        } catch {
            print(error)
            return nil
        }
    }
}
