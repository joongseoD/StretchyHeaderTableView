//
//  ViewController.swift
//  StickyHeaderTableView
//
//  Created by DHN0195 on 2021/02/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var smallImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var smallImageView: UIImageView!
    @IBOutlet weak var smallImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var smallImageViewHeightConstraint: NSLayoutConstraint!
    
    private let data = (0...100).map { String($0) }
    private var beforeScrollOffsetY: CGFloat = 0
    private let smallImageViewWidth: CGFloat = 140
    private let maxSmallImageViewTopSpacing: CGFloat = 150
    private let backgroundImageViewOriginHeight: CGFloat = 250
    private let navigationBarHeight: CGFloat = 94
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarView.alpha = 0
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beforeScrollOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        beforeScrollOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        beforeScrollOffsetY = scrollView.contentOffset.y
        scrollMaget(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        beforeScrollOffsetY = scrollView.contentOffset.y
        scrollMaget(scrollView)
    }
    
    private func scrollMaget(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < self.backgroundImageViewOriginHeight else { return }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            if scrollView.contentOffset.y > self.backgroundImageViewOriginHeight / 2 {
                scrollView.setContentOffset(CGPoint(x: 0, y: self.backgroundImageViewOriginHeight - self.navigationBarHeight), animated: true)
            } else {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distance = scrollView.contentOffset.y - beforeScrollOffsetY
        let topAnchor = smallImageViewTopConstraint.constant - distance
        
        smallImageView.alpha = topAnchor / maxSmallImageViewTopSpacing
        smallImageViewTopConstraint.constant = scrollView.contentOffset.y < 0 ? maxSmallImageViewTopSpacing : topAnchor
        backgroundImageViewHeightConstraint.constant = max(0, backgroundImageViewOriginHeight - scrollView.contentOffset.y)
        
        let smallImageSize = max(smallImageViewWidth, smallImageViewWidth - scrollView.contentOffset.y)
        smallImageViewWidthConstraint.constant = smallImageSize
        smallImageViewHeightConstraint.constant = smallImageSize
        
        if distance > 0 && scrollView.contentOffset.y >= backgroundImageViewOriginHeight - navigationBarHeight {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.navigationBarView.alpha = 1
            }
        } else if distance < 0 && scrollView.contentOffset.y < backgroundImageViewOriginHeight - navigationBarHeight  {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.navigationBarView.alpha = 0
            }
        }
        beforeScrollOffsetY = scrollView.contentOffset.y
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
