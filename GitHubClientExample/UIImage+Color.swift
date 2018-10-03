//
//  UIImage+Color.swift
//  GitHubClientExample
//
//  Created by Nishihara Kiyoshi on 2018/10/03.
//  Copyright © 2018年 Nishihara Kiyoshi. All rights reserved.
//

import UIKit

// swift3以降でも単色画像作成のinitが使えるように
// @see https://stackoverflow.com/questions/26542035/create-uiimage-with-solid-color-in-swift
extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
