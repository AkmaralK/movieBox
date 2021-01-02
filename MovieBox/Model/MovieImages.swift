//
//  MovieImages.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/2/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation
import AXPhotoViewer

struct MovieImages: Decodable {
    let backdrops: [MovieImage]
    
}

struct MovieImage: Decodable {
    var url: String
    
    enum CodingKeys: CodingKey {
        case file_path
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = ImageSize.wallpaper.getURL(imagePath: try values.decode(String.self, forKey: .file_path))
    }
    
    func toAXCustomPhoto () -> AXCustomPhoto {
        let customPhoto = AXCustomPhoto()
        customPhoto.url = URL(string: url)
        return customPhoto
    }
}


class AXCustomPhoto: NSObject, AXPhotoProtocol {
    @objc var url: URL? = nil
    @objc var imageData: Data? = nil
    @objc var image: UIImage? = nil
}

