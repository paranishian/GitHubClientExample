//
//  TimeLineViewController.swift
//  GitHubClientExample
//
//  Created by Nishihara Kiyoshi on 2018/10/03.
//  Copyright © 2018年 Nishihara Kiyoshi. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

final class TimeLineViewController: UIViewController {
    
    private var viewModel: UserListViewModel!
    private var tableView: UITableView!
    private var refereshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewを生成
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeLineCell.self, forCellReuseIdentifier: "TimeLineCell")
        view.addSubview(tableView)
        
        // UIRefreshControlを生成し、リフレッシュしたときに呼ばれるメソッドを定義し、
        // tableView.refreshControlにセットしている
        refereshControl = UIRefreshControl()
        refereshControl.addTarget(self, action: #selector(refreshControlValueDidChange(sender:)), for: .valueChanged)
        tableView.refreshControl = refereshControl
        
        // UserListViewModelを生成し、通知を受け取ったときの処理を定義している
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = {[weak self] state in
            switch state {
            case .loading:
                // 通信中だったら、tableViewを操作不能にしている
                self?.tableView.isUserInteractionEnabled = false
                break
            case .finish:
                // 通信が完了したら、tableViewを操作可能にし、tableViewを更新
                // また、refreshControl.endRefreshingを呼んでいる
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
                self?.refereshControl.endRefreshing()
                break
            case .error(let error):
                // Errorだったら、tableViewを操作不能にし、
                // refreshControl.endRefreshingを呼んでいる
                // その後、ErrorメッセージAlertを表示している
                self?.tableView.isUserInteractionEnabled = false
                self?.refereshControl.endRefreshing()
                
                let alertController = UIAlertController(title: error.localizedDescription,
                                                        message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self?.present(alertController, animated: true, completion: nil)
                break
            }
        }
            
        // ユーザ一覧を取得している
        viewModel.getUsers()
    }
    
    
    @objc func refreshControlValueDidChange(sender: UIRefreshControl) {
        // リフレッシュしたとき、ユーザ一覧を取得している
        viewModel.getUsers()
    }
}

extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let timelineCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as? TimeLineCell {
            
            // そのCellのUserCellViewModelを取得し、timelineCellに対して、nickNameとiconをセットしている
            let cellViewModel = viewModel.cellViewModels[indexPath.row]
            timelineCell.setNickName(nickName: cellViewModel.nickName)
            
            cellViewModel.downloadImage { (progress) in
                switch progress {
                case .loading(let image):
                    timelineCell.setIcon(icon: image)
                    break
                case .finish(let image):
                    timelineCell.setIcon(icon: image)
                    break
                case .error:
                    break
                }
            }
            
            return timelineCell
        }
        
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // そのCellのUserCellViewModelを取得し、そのユーザのGithubページへ画面遷移している
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let webURL = cellViewModel.webURL
        let webViewController = SFSafariViewController(url: webURL)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
