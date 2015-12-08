//
//  TopicModel.swift
//  V2EX-iOS
//
//  Created by ciel on 15/11/29.
//  Copyright © 2015年 CL. All rights reserved.
//

import UIKit
import ObjectMapper

class TopicModel: NSObject, Mappable {
    var topicID: Int?
    var title: String?
    var replies: Int?
    var member: Member?
    var node: Node?
    var last_modified: Double?
    var last_modifiedText: String?
    
    required init?(_ map: Map) {
        
    }
    
    override init() {
        
    }

    func mapping(map: Map) {
        topicID <- map["id"]
        title <- map["title"]
        replies <- map["replies"]
        member <- map["member"]
        node <- map["node"]
        last_modified <- map["last_modified"]
    }
    
    func lastModifiedText() -> String {
        if let last_modified = last_modified {
            return V2EXHelper.dateFormat(last_modified)
        }
        
        if let last_modifiedText = last_modifiedText {
            return last_modifiedText
        }
        return ""
    }
    
    func avatarURL() -> String {
        if !member!.avatar_normal!.hasPrefix("http") {
            return "https:" + member!.avatar_normal!
        }
        return member!.avatar_normal!
    }
}

class Node: NSObject, Mappable {
    var title: String?
    var name: String?
    var url: String?
    
    required init?(_ map: Map) {
        
    }
    
    override init() {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        name <- map["name"]
        url <- map["url"]
    }
}

class Member: NSObject, Mappable {
    var username: String?
    var avatar_normal: String?
    
    required init?(_ map: Map) {
        
    }
    
    override init() {
        
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        avatar_normal <- map["avatar_normal"]
    }
}