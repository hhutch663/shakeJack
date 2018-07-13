//
//  Helpers.swift
//  Shake Jack
//
//  Created by Heidi Hutchinson on 7/2/18.
//  Copyright © 2018 Heidi Hutchinson. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func imageFromURL(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
