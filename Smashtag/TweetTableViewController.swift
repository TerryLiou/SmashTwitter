//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/10.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate
{
    private var tweets: [Twitter.Tweet] = []
    private var backgroudImageView = UIImageView(image: #imageLiteral(resourceName: "twitter-logo_22"))

    private func setuptableView() {
        backgroudImageView.contentMode = .center
        backgroudImageView.alpha = 0.3
        backgroudImageView.frame = CGRect(origin: tableView.center,
                                          size: backgroudImageView.bounds.size)
        tableView.backgroundView = backgroudImageView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    func getTweet(by indexPath: IndexPath) -> Twitter.Tweet {
        return tweets[indexPath.row]
    }

    var searchText: String? {
        didSet {
            searchTextFiled?.resignFirstResponder()
            lastTwitterRequest = nil
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets(by: searchText)
            title = searchText
        }
    }

    func insertTweets(_ newTweets: [Twitter.Tweet], and searchText: String?) {
        self.tweets = newTweets + tweets
        tableView.reloadData()
//        self.tableView.insertSections([0], with: .fade)
    }

    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }

    private var lastTwitterRequest: Twitter.Request?

    private func searchForTweets(by searchText: String?) {
        let spinner = tableView.getDefaultIndicator(type: .whiteLarge, center: tableView.center, color: UIColor.black)
        tableView.addSubview(spinner)
        spinner.startAnimating()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request  // 當 request 產生時存起來比較 backgroundThread 回來的 request 是否一樣
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {  // 關於 UI 的邏輯要切回去 mainQueue
                    if request == self?.lastTwitterRequest {
                        self?.insertTweets(newTweets, and: searchText)
                    }
                    spinner.stopAnimating()
                    self?.refreshControl?.endRefreshing()
                }
            }
        } else {
            spinner.stopAnimating()
            refreshControl?.endRefreshing()
        }
    }
    
    @IBOutlet weak var searchTextFiled: UITextField! {
        didSet {
            searchTextFiled.delegate = self
        } // 在 iOS 把 searchTextFiled 建好的時候就立刻指派 Delegate
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextFiled {
            searchText = searchTextFiled.text
        }
        return true
    }

    @IBAction func refresh(_ sender: Any) {
        searchForTweets(by: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight      // tableView 需要預設高度，所以直接給 rowHight
        tableView.rowHeight = UITableViewAutomaticDimension     // 告訴 tableView rowHight 是 AutomaticDimension
        setuptableView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        let tweet: Twitter.Tweet = tweets[indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }

    @objc private func reload() {  // 上拉加載
        searchForTweets(by: nil)
        tableView.tableFooterView = nil
        tableView.setContentOffset(CGPoint.zero, animated:true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tweets.count - 1 {
            let loadMoewView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            let touch = UITapGestureRecognizer(target: self, action: #selector(reload))
            let label = UILabel(frame: loadMoewView.frame)
            label.text = "Click Here To Reload"
            label.textAlignment = .center
            loadMoewView.backgroundColor = .lightGray
            loadMoewView.addSubview(label)
            loadMoewView.addGestureRecognizer(touch)
            tableView.tableFooterView = loadMoewView
        }
    }
}
