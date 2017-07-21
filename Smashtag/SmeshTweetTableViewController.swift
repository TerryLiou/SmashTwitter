//
//  SmeshTweetTableViewController.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/11.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import UIKit
import CoreData
import Twitter
// 執行 CoreData 相關的邏輯，做的事情和 TwitterAPI 雷同，但是為了避免程式的相依性，將邏輯分開寫
class SmeshTweetTableViewController: TweetTableViewController
{
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    override func insertTweets(_ newTweets: [Twitter.Tweet], and searchText: String?) {
        super.insertTweets(newTweets, and: searchText)
        updateDatabase(with: newTweets, and: searchText)
    }

    private func updateDatabase(with tweets: [Twitter.Tweet], and searchText: String?) {
        container?.performBackgroundTask{ context in
            for twitterInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            _ = try? SearchTerm.updateSearchTexts(with: searchText, in: context)
            try? context.save()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term" {
            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        } else if segue.identifier == "Mentions Information" {
            if let tweeterMentionTVC = segue.destination as? TweeterMentionTableViewController {
                if let cell = sender as? TweetTableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    tweeterMentionTVC.selectedTweet = getTweet(by: indexPath!)
                }
            }
        }
    }
}
