//
//  UIImageView+Extension.swift
//  ios_akakce_cs
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Kingfisher
import UIKit

extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = UIImage(systemName: "photo")) {
        let url = URL(string: urlString)
        let processor = DownsamplingImageProcessor(size: self.bounds.size)

        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ],
            completionHandler: nil
        )
    }
}
