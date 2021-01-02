//
//  Person].swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/25/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

struct Person: Decodable {
    var id: Int
    var name: String
    var characterName: String
    var avatarURL: String
    
    enum CodingKeys: CodingKey {
        case profile_path, id, original_name, character
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .original_name)
        self.characterName = try values.decode(String.self, forKey: .character)
        self.avatarURL = ImageSize.poster.getURL(imagePath: (try? values.decode(String.self, forKey: .profile_path)) ?? "")
    }
    
    static func getFake() -> [Person] {
        return [
//            Person(name: "Messi Lionel Andreas", characterName: "Developer", avatarURL: ""),
//            Person(name: "Messi Lionel Andreas", characterName: "Developer", avatarURL: ""),
//            Person(name: "Messi Lionel Andreas", characterName: "Developer", avatarURL: ""),
//            Person(name: "Messi Lionel Andreas", characterName: "Developer", avatarURL: "")
        ]
    }
}

struct PersonResponse: Decodable {
    let cast: [Person]
}
