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
    var name: String?
    var characterName: String?
    var avatarURL: String = ""
    var wallpaperURL: String = ""
    var biography: String?
    
    enum CodingKeys: CodingKey {
        case profile_path, id, original_name, character, job, biography, name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = (try? values.decode(String.self, forKey: .original_name)) ?? (try? values.decode(String.self, forKey: .name))
        
        self.avatarURL = ImageSize.poster.getURL(imagePath: (try? values.decode(String.self, forKey: .profile_path)) ?? "")
        
        if let profileURL = try? values.decode(String.self, forKey: .profile_path) {
            self.wallpaperURL = ImageSize.bigPoster.getURL(imagePath: profileURL)
        }
        
        self.biography = try? values.decode(String.self, forKey: .biography)
        
        self.characterName = (try? values.decode(String.self, forKey: .character)) ?? (try? values.decode(String.self, forKey: .job)) ?? ""
    } 
    
    static func getFake() -> [Person] {
        return [
        ]
    }
}

struct PersonResponse: Decodable {
    let cast: [Person]
    let crew: [Person]
}

struct ActorsResponse: Decodable {
    let results: [Person]
    
}
