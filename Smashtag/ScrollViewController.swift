//
//  ScrollViewController.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/20.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate
{
    private var imageScrollView = UIScrollView()
    private var mentionImageView = UIImageView()
    
    var mentionImage: UIImage? {
        didSet {
            if let image = mentionImage {
                mentionImageView.image = image
                mentionImageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
                setUpScrollView()
            }
        }
    }

    private func setUpScrollView() {
        self.view.addSubview(imageScrollView)
        self.automaticallyAdjustsScrollViewInsets = false
        imageScrollView.delegate = self
        imageScrollView.addSubview(mentionImageView)
        imageScrollView.contentSize = mentionImageView.bounds.size
        imageScrollView.zoomScale = getSuitableScale(by: mentionImage!).minimumScale
        imageScrollView.reloadInputViews()
    }

    private func getSuitableScale(by image: UIImage) -> (minimumScale: CGFloat, maximumScale: CGFloat) {
        let widthSacle = imageScrollView.frame.width / image.size.width
        let heightSacle = imageScrollView.frame.height / image.size.height
        let suitableMinScale = (widthSacle > heightSacle) ? widthSacle: heightSacle
        return (suitableMinScale, suitableMinScale * 2.0)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mentionImageView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationCV = navigationController {
            navigationCV.isNavigationTransparent = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageScrollView.frame = self.view.frame
        guard let image = mentionImage else { return }
        imageScrollView.minimumZoomScale = getSuitableScale(by: image).minimumScale
        imageScrollView.maximumZoomScale = getSuitableScale(by: image).maximumScale
        imageScrollView.zoomScale = getSuitableScale(by: image).minimumScale
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationCV = navigationController {
            navigationCV.isNavigationTransparent = false
        }
    }
}
