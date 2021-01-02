//
//  Alertable.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/1/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {

    func showAlert (_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
