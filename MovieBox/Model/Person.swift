//
//  Person].swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/25/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

struct Person {
    let name: String
    let characterName: String
    let avatarURL: String
    
    
    static func getFake() -> [Person] {
        return [
            Person(name: "Messi Lionel Andreas", characterName: "Developer", avatarURL: ""),
            Person(name: "Messi Lionel Andreas", characterName: "Developer", avatarURL: ""),
            Person(name: "Messi Lionel Andreas", characterName: "Developer", avatarURL: ""),
            Person(name: "Messi Lionel Andreas", characterName: "Developer", avatarURL: "")
        ]
    }
}
