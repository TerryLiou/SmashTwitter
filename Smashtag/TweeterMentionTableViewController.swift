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
    private enum MentionTypes: String {
        case media = "Image"
        case hashtags = "Hashtags"
        case urls = "Mention Urls"
        case userMention = "Mention Tweeter"
    }
    
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
        let sectionHeaderTitle = mentionTypes[indexPath.section].mentionType.rawValue

        if let mentionCell = cell as? MentionTableViewCell, selectedTweet != nil {
            mentionCell.indexForRow = indexPath.row
            mentionCell.mentionSectionHeaderTitle = sectionHeaderTitle
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
}
