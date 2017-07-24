//
//  ImageScrollViewController.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/21.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController, UIScrollViewDelegate
{
    private var imageScrollView = UIScrollView()
    private var mentionImageView = UIImageView()

    var mentionImage: UIImage? {
        didSet {
            if let image = mentionImage {
                mentionImageView.image = image
                mentionImageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
                setUpScrollView()
                setupImageScale(image, view.frame.size)
            }
        }
    }

    private func setUpScrollView() {
        self.view.addSubview(imageScrollView)
        self.automaticallyAdjustsScrollViewInsets = false
        imageScrollView.delegate = self
        imageScrollView.addSubview(mentionImageView)
        imageScrollView.contentSize = mentionImageView.frame.size
//        imageScrollView.reloadInputViews()
    }

    private func setupImageScale(_ image: UIImage, _ size: CGSize) {
        imageScrollView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        imageScrollView.minimumZoomScale = getSuitableScale(by: image).minimumScale
        imageScrollView.maximumZoomScale = getSuitableScale(by: image).maximumScale
        imageScrollView.zoomScale = getSuitableScale(by: image).minimumScale
        imageScrollView.contentOffset = CGPoint().getPointAboutContentOffsetToCenter(by: mentionImageView, and: imageScrollView)
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
        navigationController?.isNavigationTransparent = true
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let image = mentionImage else { return }
        setupImageScale(image, size)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationCV = navigationController {
            navigationCV.isNavigationTransparent = false
            tabBarController?.tabBar.isHidden = false
        }
    }
}
