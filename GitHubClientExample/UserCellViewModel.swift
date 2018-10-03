//
//  UserCellViewModel.swift
//  GitHubClientExample
//
//  Created by Nishihara Kiyoshi on 2018/10/03.
//  Copyright © 2018年 Nishihara Kiyoshi. All rights reserved.
//

import Foundation
import UIKit

enum ImageDownloadProgress {
    case loading(UIImage)
    case finish(UIImage)
    case error
}

final class UserCellViewModel {
    
    // ユーザを変数として保持
    private var user: User
    
    // ImageDownloaderを変数として保持
    private let imageDownloader = ImageDownLoader()
    
    // ImageDownloaderでダウンロード中かどうかのBool変数として保持
    private var isLoading = false
    
    // Cellに反映するアウトプット
    var nickName: String {
        return user.name
    }
    
    // Cellを選択したときに必要なwebURL
    var webURL: URL {
        return URL(string: user.webURL)!
    }
    
    // userを引数にinit
    init(user: User) {
        self.user = user
    }
    
    // ImageDownloaderを使ってダウンロードし、
    // その結果をImageDownloadProgressとしてClosureで返している
    func downloadImage(progress: @escaping (ImageDownloadProgress) -> Void) {
        // isLoadingがtrueだったらreturnしている
        // このメソッドはcellForRowメソッドで呼ばれることを想定しているため、
        // 何回もダウンロードしないためにisLoadingを使用している
        if isLoading == true {
            return
        }
        
        isLoading = true
        
        // grayのUIImageを作成
        let loadingImage = UIImage(color: .gray, size: CGSize(width: 45, height: 45))!
        
        // .loadingをClosureで返している
        progress(.loading(loadingImage))
        
        // imageDownloaderを用いて、画像をダウンロードしている
        // 引数に、user.iconUrlを使っている
        // ダウンロードが終了したら、.finishをClosureで返している
        // Errorだったら、.errorをClosureで返している
        imageDownloader.downloadImage(imageURL: user.iconUrl,
                                      success: { (image) in
                                        progress(.finish(image))
                                        self.isLoading = false
        }) { (error) in
            progress(.error)
            self.isLoading = false
        }
    }
}
