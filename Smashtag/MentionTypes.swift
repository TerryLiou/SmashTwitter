//
//  MentionTypes.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/19.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import Foundation
import Twitter

enum MentionTypes: String {
    case media = "Image"
    case hashtags = "Hashtags"
    case urls = "Mention Urls"
    case userMention = "Mention Tweeter"

    static func getCurrentType(by type: MentionTypes, from tweet: Twitter.Tweet) -> [Mention]? {
        switch type {
        case .hashtags:
            return tweet.hashtags
        case .urls:
            return tweet.urls
        case .userMention:
            return tweet.userMentions
        default:
            return nil
        }
    }
}

