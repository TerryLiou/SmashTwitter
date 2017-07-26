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

    var imageCache = NSCache<NSURL, UIImage>()

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
        mentionImage.addSubview(spinner)

        if let mentionImageURL = mentionUrl {
            if let image = imageCache.object(forKey: (mentionImageURL as NSURL)) {
                mentionImage.image = image
            } else {
                spinner.startAnimating()
                lastmMediaUrl = mentionImageURL
                DispatchQueue.global().async { [weak self] in
                    if let imageData = try? Data(contentsOf: mentionImageURL) {
                        if self?.lastmMediaUrl == mentionImageURL {
                            DispatchQueue.main.async {
                                self?.mentionImage.image = UIImage(data: imageData)
                                self?.imageCache.setObject(UIImage(data: imageData)!, forKey: mentionImageURL as NSURL)
                                spinner.stopAnimating()
                            }
                        }
                    }
                }
            }
        } else {
            mentionImage.image = nil
            spinner.stopAnimating()
        }
    }
}
