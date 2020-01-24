//
//  Storage.swift
//  Senior Design Project
//
//  Created by Mike Maldonado on 10/21/18.
//  Copyright © 2018 Aaron Dahlin. All rights reserved.
//

import Foundation

class DeviceStorage {
    fileprivate init() {}
    
    enum Directory {
        case documents
        case caches
        case userDirectory
    }
    
    static fileprivate func getURL(for directory: Directory) -> URL? {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        case .userDirectory:
            searchPathDirectory = .userDirectory
        }
        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
        return nil
    }
    
    static func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String) {
        let url = getURL(for: directory)?.appendingPathComponent(fileName, isDirectory: false)
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(object)
            if let url = url {
                FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            }
            
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T?
    {
        
        if let url = getURL(for: directory)?.appendingPathComponent(fileName, isDirectory: false) {
            if !FileManager.default.fileExists(atPath: url.path) {
                print("File at path \(url.path) does not exit")
            }
            else if let data = FileManager.default.contents(atPath: url.path) {
                let decoder = PropertyListDecoder()
                do {
                    let model = try decoder.decode(type, from: data)
                    return model
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
            else {
                print("No data at \(url.path)!")
            }
        }
        return nil
    }
    
    
    
    static func clear(_ directory: Directory) {
        if let url = getURL(for: directory) {
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
                for fileUrl in contents {
                    try FileManager.default.removeItem(at: fileUrl)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
    }
}
