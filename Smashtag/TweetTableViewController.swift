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
    private var tweets = [Array<Twitter.Tweet>]()

    func getTweet(by indexPath: IndexPath) -> Twitter.Tweet {
        return tweets[indexPath.section][indexPath.row]
    }

    var searchText: String? {
        didSet {
            searchTextFiled?.text = searchText
            searchTextFiled?.resignFirstResponder()
            lastTwitterRequest = nil
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }

    func insertTweets(_ newTweets: [Twitter.Tweet]) {
        self.tweets.insert(newTweets, at: 0)
        self.tableView.insertSections([0], with: .fade)
    }

    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }

    private var lastTwitterRequest: Twitter.Request?

    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request  // 當 request 產生時存起來比較 backgroundThread 回來的 request 是否一樣
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {  // 關於 UI 的邏輯要切回去 mainQueue
                    if request == self?.lastTwitterRequest {
                        self?.insertTweets(newTweets)
                    }
                    self?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
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
        searchForTweets()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight      // tableView 需要預設高度，所以直接給 rowHight
        tableView.rowHeight = UITableViewAutomaticDimension     // 告訴 tableView rowHight 是 AutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        let tweet: Twitter.Tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }
}
