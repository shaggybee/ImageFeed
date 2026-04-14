//
//  Profile.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.03.2026.
//

public struct Profile {
    let bio: String?
    let username: String
    let name: String
    
    var loginName: String { "@\(username)" }
    
    public init(username: String, firstName: String, lastName: String?, bio: String?) {
        self.bio = bio
        self.username = username
        
        if let lastName {
            self.name = "\(firstName) \(lastName)"
        } else {
            self.name = firstName
        }
    }
}
