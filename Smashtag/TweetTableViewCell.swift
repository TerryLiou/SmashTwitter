//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/11.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetProfileImageView: UIImageView! {
        didSet {
            tweetProfileImageView.gotCricleView()
        }
    }
    
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    var tweet: Twitter.Tweet? { didSet { updateUI() } }

    private var lastProfileImageURL: URL?

    private func updateUI() {
        tweetTextLabel?.text = tweet?.text
        
        if tweet?.text != nil {
            tweetTextLabel?.attributedText = setTextColor(with: (tweet?.text)!)
        }

        tweetUserLabel?.text = tweet?.user.description

        if let profileImageURL = tweet?.user.profileImageURL {
            lastProfileImageURL = profileImageURL
            DispatchQueue.global().async { [weak self] in
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    if self?.lastProfileImageURL == profileImageURL {
                        DispatchQueue.main.async {
                            self?.tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        } else {
            tweetProfileImageView?.image = nil
        }

        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }

    private func setTextColor(with text: String) -> NSMutableAttributedString {  // 將 text 裡的 Mention 選項換顏色
        let mutableString = NSMutableAttributedString(string: text)
        let mentionThingArray = [(tweet?.hashtags, UIColor.red),
                                 (tweet?.urls, UIColor.blue),
                                 (tweet?.userMentions, UIColor.cyan)]
        for mentionThingInfo in mentionThingArray {
            if mentionThingInfo.0?.count != 0 {
                for index in 0 ..< (mentionThingInfo.0?.count)! {
                    mutableString.addAttribute(NSForegroundColorAttributeName,
                                               value: mentionThingInfo.1,
                                               range: (mentionThingInfo.0?[index].nsrange)!)
                }
            }
        }

        return mutableString
    }
}

extension UIView {
    public func gotCricleView() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
    }
}
