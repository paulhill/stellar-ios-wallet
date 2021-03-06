//
//  TradingViewController.swift
//  BlockEQ
//
//  Created by Satraj Bambra on 2018-05-23.
//  Copyright © 2018 Satraj Bambra. All rights reserved.
//

import UIKit

protocol TradeSegmentControllerDelegate: AnyObject {
    func setScroll(offset: CGFloat, page: Int)
}

final class TradeSegmentViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    
    var leftViewController: UIViewController!
    var rightViewController: UIViewController!
    var middleViewController: UIViewController!
    var totalPages: CGFloat!
    var tradeSegmentDelegate: TradeSegmentControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(leftViewController: UIViewController, middleViewController: UIViewController, rightViewController: UIViewController, totalPages: CGFloat) {
        super.init(nibName: String(describing: TradeSegmentViewController.self), bundle: nil)
        
        self.leftViewController = leftViewController
        self.middleViewController = middleViewController
        self.rightViewController = rightViewController
        self.totalPages = totalPages
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    func setupView() {
        scrollView.backgroundColor = Colors.lightBackground
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let leftView = UIView(frame: CGRect(origin: .zero, size: scrollView.frame.size))
        scrollView.addSubview(leftView)
        
        let middleView = UIView(frame: CGRect(origin: CGPoint(x: scrollView.frame.size.width, y: 0.0), size: scrollView.frame.size))
        scrollView.addSubview(middleView)
        
        let rightView = UIView(frame: CGRect(origin: CGPoint(x: scrollView.frame.size.width * 2, y: 0.0), size: scrollView.frame.size))
        scrollView.addSubview(rightView)
        
        
        self.addContentViewController(leftViewController, to: leftView)
        self.addContentViewController(middleViewController, to: middleView)
        self.addContentViewController(rightViewController, to: rightView)

        scrollView.contentSize = CGSize(width: view.frame.size.width * totalPages, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }

    func switchSegment(_ type: TradeSegment) {
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width * CGFloat(type.rawValue), y: 0.0), animated: true)
    }
}

extension TradeSegmentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        
        let totalOffset = view.frame.size.width * totalPages
        let scrollOffset = (scrollView.contentOffset.x / totalOffset) * scrollView.frame.size.width
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        tradeSegmentDelegate?.setScroll(offset: scrollOffset, page: page)
    }
}
