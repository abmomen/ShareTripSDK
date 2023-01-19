//
//  UITableViewExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public extension UITableView {
    func registerCell<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: T.reuseID)
    }
    
    func registerConfigurableCellDataContainer<T: UITableViewCell>(_ cellClass: T.Type) where T: ConfigurableTableViewCellDataContainer {
        register(cellClass, forCellReuseIdentifier: T.reuseableContainerID)
    }
    
    func registerNibConfigurableCellDataContainer<T: UITableViewCell>(_ cellClass: T.Type, nibName: String = T.reuseID)  where T: ConfigurableTableViewCellDataContainer {
        let nib = UINib(nibName: nibName, bundle: Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: T.reuseableContainerID)
    }
    
    func registerNibCell<T: UITableViewCell>(_ cellClass: T.Type, nibName: String = T.reuseID) {
        let nib = UINib(nibName: nibName, bundle: Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: T.reuseID)
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) {
        register(viewClass, forHeaderFooterViewReuseIdentifier: T.reuseID)
    }
    
    func registerNibHeaderFooter<T: UITableViewHeaderFooterView>(_ viewClass: T.Type, nibName: String = T.reuseID) {
        let nib = UINib(nibName: nibName, bundle: Bundle(for: T.self))
        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseID)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("fatalError: Could not dequeue cell with identifier: \(T.reuseID) for cell at \(indexPath)")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseID) as? T else {
            fatalError("fatalError: Could not dequeue header/footer view with identifier: \(T.reuseID)")
        }
        return view
    }
}

public extension UITableView {
    
    var dataHasChanged: Bool {
        guard let dataSource = dataSource else { return false }
        let sections = dataSource.numberOfSections?(in: self) ?? 1
        if numberOfSections != sections {
            return true
        }
        for section in 0..<sections {
            let rowCount = numberOfRows(inSection: section)
            let dataSourceRowCount = dataSource.tableView(self, numberOfRowsInSection: section)
            STLog.info("rowCount: \(rowCount) dataSourceRowCount: \(dataSourceRowCount)")
            if numberOfRows(inSection: section) != dataSource.tableView(self, numberOfRowsInSection: section) {
                return true
            }
        }
        return false
    }
    
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }) { _ in
            completion()
        }
    }
    
    func reloadRowsSafely(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        if dataHasChanged {
            reloadData()
        } else {
            reloadRows(at: indexPaths, with: animation)
        }
    }
    
    func reloadRowsInSection(section: Int, oldCount:Int, newCount: Int, visibleRowsOnly: Bool = false) {
        
        let maxCount = max(oldCount, newCount)
        let minCount = min(oldCount, newCount)
        
        var changed = [IndexPath]()
        for i in minCount..<maxCount {
            let indexPath = IndexPath(row: i, section: section)
            changed.append(indexPath)
        }
        
        var reload = [IndexPath]()
        for i in 0..<minCount{
            let indexPath = IndexPath(row: i, section: section)
            reload.append(indexPath)
        }
        
        beginUpdates()
        if newCount > oldCount  {
            insertRows(at: changed, with: .fade)
        } else if oldCount > newCount {
            deleteRows(at: changed, with: .fade)
        }
        if reload.count > 0 {
            if visibleRowsOnly {
                let indexPathsIntersection = Set(indexPathsForVisibleRows ?? []).intersection(reload)
                reload = Array(indexPathsIntersection)
            }
            reloadRows(at: reload, with: .none)
        }
        endUpdates()
    }
}

public extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        //self.separatorStyle = .none
    }
    
    func setEmptyMessageView(_ messageView: UIView) {
        
        messageView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        //let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        //messageLabel.text = "message"
        //messageLabel.textColor = .black
        //messageLabel.numberOfLines = 0;
        //messageLabel.textAlignment = .center
        //messageLabel.sizeToFit()
        messageView.sizeToFit()
        
        self.backgroundView = messageView
        //self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        //self.separatorStyle = .singleLine
    }
    
    /// remove top space from top of TableView
    func removeTopSpace() {
        self.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude)))
    }
    /// Remove space at bottom of tableView.
    func removeBottomSpace() {
        self.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude)))
    }
    
    func addTopBackgroundView(viewColor: UIColor) {
        var frame = UIScreen.main.bounds
        frame.origin.y = -frame.size.height
        let view = UIView(frame: frame)
        view.backgroundColor = viewColor
        addSubview(view)
    }
}

public extension UITableView {
    func startActivityIndicator() {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        activityIndicator.center = center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        
        //let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        self.backgroundView = activityIndicator
        //self.separatorStyle = .none
    }
    
    func stopActivityIndicator() {
        self.backgroundView = nil
    }
}

public extension UITableViewCell {
    
    func hideSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
    }
    
    func showSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

