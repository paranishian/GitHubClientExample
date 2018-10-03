//
//  ImageDownloader.swift
//  GitHubClientExample
//
//  Created by Nishihara Kiyoshi on 2018/10/02.
//  Copyright © 2018年 Nishihara Kiyoshi. All rights reserved.
//

import Foundation
import UIKit

final class ImageDownLoader {
    
    // UIImageをキャッシュするための変数
    var cacheImage: UIImage?
    
    func downloadImage(imageURL: String,
                       success: @escaping (UIImage) -> Void,
                       failure: @escaping (Error) -> Void) {
        
        // もしキャッシュがあればそれをClosureで返す
        if let cacheImage = cacheImage {
            success(cacheImage)
        }
        
        // リクエストを作成
        var request = URLRequest(url: URL(string: imageURL)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            
            guard let imageFromData = UIImage(data: data) else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            
            DispatchQueue.main.async {
                success(imageFromData)
            }
            
            // 画像をキャッシュする
            self.cacheImage = imageFromData
        }
        task.resume()
    }
}
