//
//  User.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/19/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

class AppUser {
    var name: String = "User"
    var email: String = ""
    var loaded = false
    
    convenience init (name: String, email: String, loaded: Bool = true) {
        self.init()
        self.name = name
        self.email = email
        self.loaded = loaded
    }
}
