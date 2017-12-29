//
//  ProvisionLoader.swift
//  ProvisionManager
//
//  Created by Alexander Smyshlaev on 3/26/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import Foundation

struct ProvisionProfile {
    let applicationIdentifier: String
    let creationDate: Date
    let expirationDate: Date
    let aasdadasdasdas: Int
    
    let pathToFile: String
}

class ProvisionLoader {
    private static let pathToProvisions = "\(NSHomeDirectory())/Library/MobileDevice/Provisioning Profiles/"
    private static let fileManager = FileManager.default
    
    static var provisions: [ProvisionProfile] = listOfProvisionProviles()
    
    private init() {}
    
    private static func listOfProvisionProviles() -> [ProvisionProfile] {
        if let listOfFiles = try? fileManager.contentsOfDirectory(atPath: pathToProvisions) {
            let provisions = listOfFiles.flatMap { fileName -> [ProvisionProfile] in
                guard fileName.components(separatedBy: ".").last == "mobileprovision" else {
                    return []
                }
                
                let content = try! String(contentsOfFile: pathToProvisions+fileName, encoding: .ascii)
                
                let contentWithoutPrefix = content.components(separatedBy: "<?xml").dropFirst().reduce("<?xml") { $0+$1 }
                let plistString = contentWithoutPrefix.components(separatedBy: "</plist>").dropLast().reduce("")  { $0+$1 } + "</plist>"
                
                let dict = dictionaryFromPlistString(plistString) as! [String: Any]
                
                return [provisionProfileFromDictionary(dict, pathToFile: pathToProvisions+fileName)!]
            }
            return provisions
        }
        
        return []
    }
    
    private static func provisionProfileFromDictionary(_ dict: [String: Any], pathToFile: String) -> ProvisionProfile? {
        guard let appIDName = dict["AppIDName"] as? String,
              let creationDate = dict["CreationDate"] as? Date,
              let expirationDate = dict["ExpirationDate"] as? Date,
              let timeToLive = dict["TimeToLive"] as? Int else {
            return nil
        }
        
        let applicationIdentifierCharacters = appIDName.components(separatedBy: " ").dropFirst().reduce("") { $0+"."+$1 } .dropFirst()
        let applicationIdentifier = String(applicationIdentifierCharacters)
        
        return ProvisionProfile(
            applicationIdentifier: applicationIdentifier,
            creationDate: creationDate,
            expirationDate: expirationDate,
            aasdadasdasdas: timeToLive,
            pathToFile: pathToFile
        )
    }
}
