//
//  MentionTableViewCell.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/14.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import UIKit
import Twitter

class MentionTableViewCell: UITableViewCell
{

    var selectedTweetForCell: Twitter.Tweet? {
        didSet {
            contentView.subviews.forEach { $0.removeFromSuperview() }  // 解決 dequeue 時 UI 重複 add 的問題
            updateUI()
        }
    }
    var mentionSectionHeaderTitle = ""
    var indexForRow = 0

    private let ditailLabel = UILabel()
    private var lastmMediaUrl: URL?
    private let mentionImageView = UIImageView()

    private func setUpImageView() {
        contentView.addSubview(mentionImageView)
        mentionImageView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width,
                                        height: contentView.bounds.width / CGFloat((selectedTweetForCell?.media[indexForRow].aspectRatio)!))
        mentionImageView.contentMode = .scaleAspectFit
        mentionImageView.translatesAutoresizingMaskIntoConstraints = false
        mentionImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mentionImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mentionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mentionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

    private func setLabelConstains() {
        contentView.addSubview(ditailLabel)
        ditailLabel.translatesAutoresizingMaskIntoConstraints = false
        ditailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        ditailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
    }

    private func updateUI() {
        switch mentionSectionHeaderTitle {
        case "Image":
            if let mediaUrl = selectedTweetForCell?.media[indexForRow].url {
                lastmMediaUrl = mediaUrl
                DispatchQueue.global().async { [weak self] in
                    if let imageData = try? Data(contentsOf: mediaUrl) {
                        if self?.lastmMediaUrl == mediaUrl {
                            DispatchQueue.main.async {
                                self?.mentionImageView.image = UIImage(data: imageData)
                                self?.setUpImageView()
                            }
                        }
                    }
                }
            }

        case "Hashtags":
            setLabelConstains()
            ditailLabel.text = selectedTweetForCell?.hashtags[indexForRow].keyword

        case "Mention Urls":
            setLabelConstains()
            ditailLabel.text = selectedTweetForCell?.urls[indexForRow].keyword

        case "Mention Tweeter":
            setLabelConstains()
            ditailLabel.text = selectedTweetForCell?.userMentions[indexForRow].keyword

        default:
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
