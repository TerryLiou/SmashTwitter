//
//  MentionImageTableViewCell.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/14.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import UIKit
import Twitter

class MentionImageTableViewCell: UITableViewCell
{
    @IBOutlet weak var mentionImage: UIImageView!

    var mentionUrl: URL? {
        didSet {
            catchImage()
        }
    }

    private var lastmMediaUrl: URL?

    private func catchImage() {
        let spinner = getDefaultIndicator(type: UIActivityIndicatorViewStyle.whiteLarge,
                                          center: contentView.center,
                                          color : UIColor.black)
        contentView.addSubview(spinner)
        if let profileImageURL = mentionUrl {
            lastmMediaUrl = profileImageURL
            DispatchQueue.global().async { [weak self] in
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    if self?.lastmMediaUrl == profileImageURL {
                        DispatchQueue.main.async {

                            self?.mentionImage.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        } else {

            mentionImage.image = nil
        }
    }
}
