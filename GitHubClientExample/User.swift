//
//  User.swift
//  GitHubClientExample
//
//  Created by Nishihara Kiyoshi on 2018/10/02.
//  Copyright © 2018年 Nishihara Kiyoshi. All rights reserved.
//

final class User {
    let id: Int
    let name: String
    let iconUrl: String
    let webURL: String
    
    init(attributes: [String: Any]) {
        id = attributes["id"] as! Int
        name = attributes["login"] as! String
        iconUrl = attributes["avatar_url"] as! String
        webURL = attributes["html_url"] as! String
    }
}
