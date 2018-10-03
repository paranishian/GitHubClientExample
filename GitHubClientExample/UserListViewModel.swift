//
//  UserListViewModel.swift
//  GitHubClientExample
//
//  Created by Nishihara Kiyoshi on 2018/10/03.
//  Copyright © 2018年 Nishihara Kiyoshi. All rights reserved.
//

import Foundation
import UIKit

enum ViewModelState {
    case loading
    case finish
    case error(Error)
}

final class UserListViewModel {
    
    // ViewModelStateをClosureとしてpropertyで保持
    // この変数がViewControllerに対して通知を送る役割を果たす
    
    var stateDidUpdate: ((ViewModelState) -> Void)?
    
    private var users = [User]()
    
    var cellViewModels = [UserCellViewModel]()
    
    let api = API()
    
    // Userの配列を取得する
    func getUsers() {
        // .loading通知を送る
        stateDidUpdate?(.loading)
        users.removeAll()
        
        api.getUsers(success: { (users) in
            self.users.append(contentsOf: users)
            for user in users {
                let cellViewModel = UserCellViewModel(user: user)
                self.cellViewModels.append(cellViewModel)
                
                // 通信が成功したので、.finish通知を送る
                self.stateDidUpdate?(.finish)
            }
        }, failure: { (error) in

            // 通信が失敗したので、.error通知を送る
            self.stateDidUpdate?(.error(error))
        })
    }
    
    // tableViewを表示させるために必要なアウトプット
    // UserListViewModelはtableView全体に対するアウトプットなので、
    // tableViewのcountに必要なusers.countがアウトプット
    // tableViewCellに対するアウトプットは、UserCellViewModelが担当する
    func usersCount() -> Int {
        return users.count
    }
}
