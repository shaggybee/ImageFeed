//
//  Profile.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.03.2026.
//

struct Profile {
    let bio: String?
    let username: String
    let name: String
    
    var loginName: String { "@\(username)" }
    
    init(username: String, firstName: String, lastName: String?, bio: String?) {
        self.bio = bio
        self.username = username
        
        if let lastName {
            self.name = "\(firstName) \(lastName)"
        } else {
            self.name = firstName
        }
    }
}
