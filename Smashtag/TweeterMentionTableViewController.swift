//
//  TweeterMentionTableViewController.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/13.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import UIKit
import Twitter

class TweeterMentionTableViewController: UITableViewController
{
    private var mentionTypes = [(mentionType: MentionTypes, itemsCouny: Int)]() // Array in MentionTypes and items quantity

    var selectedTweet: Twitter.Tweet? {
        didSet {
            if selectedTweet != nil {
                _ = makeTweeterMentionSection(by: selectedTweet!)
            }
        }
    }

    private func makeTweeterMentionSection(by tweet: Twitter.Tweet) -> [(MentionTypes, Int)] {
        if tweet.media.count != 0 {
            mentionTypes.append((.media, tweet.media.count))
        }

        if tweet.hashtags.count != 0 {
            mentionTypes.append((.hashtags, tweet.hashtags.count))
        }

        if tweet.urls.count != 0 {
            mentionTypes.append((.urls, tweet.urls.count))
        }

        if tweet.userMentions.count != 0 {
            mentionTypes.append((.userMention, tweet.userMentions.count))
        }
        return mentionTypes
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentionTypes.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentionTypes[section].mentionType.rawValue
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionTypes[section].itemsCouny
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionTableViewCell", for: indexPath)

        if let mentionCell = cell as? MentionTableViewCell, selectedTweet != nil {
            mentionCell.indexForRow = indexPath.row
            mentionCell.mentionSectionType = mentionTypes[indexPath.section].mentionType
            mentionCell.selectedTweetForCell = selectedTweet!
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mentionTypes[indexPath.section].mentionType == .media {
            guard let tweet = selectedTweet else { return UITableViewAutomaticDimension}
            return tableView.frame.width / CGFloat(tweet.media[indexPath.row].aspectRatio)
        } else {
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tweet = selectedTweet {
            switch mentionTypes[indexPath.section].mentionType {
            case .media:
                if let MentionCell = tableView.cellForRow(at: indexPath) as? MentionTableViewCell {
                    let image = MentionCell.mentionImageView.image
                    let imageScrollViewController = ScrollViewController()
                    imageScrollViewController.mentionImage = image
                    navigationController?.pushViewController(imageScrollViewController, animated: true)
                }
                print("media")

            case .urls:
                if let url = URL(string: tweet.urls[indexPath.row].keyword) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    } else {
                        makeSimpleAlert(title: "Error", message: "Oop! This is an invalid URL.")
                    }
                }

            default :
                if let newSearchVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TweetTableViewController") as? TweetTableViewController {
                    newSearchVC.searchText = (mentionTypes[indexPath.section].mentionType == .hashtags) ? tweet.hashtags[indexPath.row].keyword : tweet.userMentions[indexPath.row].keyword
                    navigationController?.pushViewController(newSearchVC, animated: true)
                }
            }
        }
    }
}
