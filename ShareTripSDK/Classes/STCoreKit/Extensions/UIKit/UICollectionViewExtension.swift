//
//  UICollectionViewExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: T.reuseID)
    }
    
    func registerNibCell<T: UICollectionViewCell>(_ cellClass: T.Type, nibName: String = T.reuseID) {
        let nib = UINib(nibName: nibName, bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: T.reuseID)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("fatalError: Could not dequeue cell with identifier: \(T.reuseID) for cell at \(indexPath)")
        }
        return cell
    }
    
    func addTopBackgroundView(viewColor: UIColor) {
        var frame = bounds
        frame.origin.y = -frame.size.height
        let view = UIView(frame: frame)
        view.backgroundColor = viewColor
        addSubview(view)
    }
    
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.normal
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

