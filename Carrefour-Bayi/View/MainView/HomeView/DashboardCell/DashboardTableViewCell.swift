//
//  DashboardTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 23.08.2022.
//

import UIKit
import AdvancedPageControl

protocol DashboardItemDelegate {
    func dashboardAnnouncementClicked(index: Int)
}

class DashboardTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageIndicator: AdvancedPageControlView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var pageIndicatorWidthConstraint: NSLayoutConstraint!
    
    // MARK: -Properties
    var dashboardItems: [GetAdvertisementData]?
    var delegate: DashboardItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pageIndicator.drawer = ScaleDrawer(numberOfPages: 0,
                                           height: 5,
                                           width: 5,
                                           space: 7,
                                           raduis: 6,
                                           currentItem: 0,
                                           indicatorColor: .white,
                                           dotsColor: .white)
        pageIndicatorWidthConstraint.constant = CGFloat(3 * 20)
    }
    
    // MARK: -UI Methods
    func bind(dashboardItems: [GetAdvertisementData]) {
#if DEBUG
        print("VEYSEL <<<< dashboard items -> ", dashboardItems)
#endif
        self.dashboardItems = dashboardItems
        if let dashboardItems = self.dashboardItems {
            pageIndicator.numberOfPages = dashboardItems.count
            
            pageIndicator.drawer = ScaleDrawer(numberOfPages: dashboardItems.count,
                                               height: 5,
                                               width: 5,
                                               space: 7,
                                               raduis: 6,
                                               currentItem: 0,
                                               indicatorColor: .white,
                                               dotsColor: .white)
            
            pageIndicatorWidthConstraint.constant = CGFloat(dashboardItems.count * 20)
        }
        
        DashboardCollectionViewCell.registerSelf(collectionView: collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setCollectionViewLayout()
    }
    
    private func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.collectionView?.collectionViewLayout = layout
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        
        pageIndicator.setPageOffset(offSet/width)
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if dashboardItems != nil {
            let visibleItems: NSArray = collectionView.indexPathsForVisibleItems as NSArray
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            
            if nextItem.row < dashboardItems?.count ?? 0 {
                self.collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
            }
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        if dashboardItems != nil {
            let visibleItems: NSArray = collectionView.indexPathsForVisibleItems as NSArray
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
            
            if nextItem.row < dashboardItems?.count ?? 0 {
                self.collectionView.scrollToItem(at: nextItem, at: .right, animated: true)
            }
        }
    }
}

// MARK: -UICollectionView Delegate Methods
extension DashboardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dashboardItems = dashboardItems else {
            return 0
        }
        return dashboardItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionViewCell", for: indexPath) as! DashboardCollectionViewCell
        
        if let dashboardItems = dashboardItems {
            cell.bind(item: dashboardItems[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.dashboardAnnouncementClicked(index: indexPath.row)
    }
}
