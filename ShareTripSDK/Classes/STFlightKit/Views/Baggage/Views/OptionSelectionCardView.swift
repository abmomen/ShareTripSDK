//
//  InputPopupCardView.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 23/4/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

//import UIKit
//import STCoreKit
//
//public protocol OptionSelectionCardViewDelegate: PopupInputViewDelegate {
//    func didSelectOption(optionIndex: Int, option: String)
//}
//
//public class PopupSingleOptionSelectionView: UIView {
//
//    // MARK: - UI Components
//
//    lazy var containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .offWhite
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.greyishBrown
//        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var crossButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named:"close-mono"), for: .normal)
//        button.tintColor = UIColor.greyishBrown
//        button.translatesAutoresizingMaskIntoConstraints = false
//        let constraints = [
//            button.heightAnchor.constraint(equalToConstant: 24.0),
//            button.widthAnchor.constraint(equalToConstant: 24.0)
//        ]
//        NSLayoutConstraint.activate(constraints)
//        button.addTarget(self, action: #selector(self.crossButtonTapped(_:)), for: .touchUpInside)
//        return button
//    }()
//
//    lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.estimatedRowHeight = 48.0
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = .clear
//        return tableView
//    }()
//
//    // MARK: - Instance Properties
//
//    /// Title of the card
//    public var title: String
//    /// Height of the card
//    public var height: CGFloat = 500.0
//    /// Offset from bottom to display the card
//    public var offest: CGFloat = 0.0
//    /// Delegate to receive cross button and done button tap event
//    public weak var delegate: OptionSelectionCardViewDelegate?
//    /// Options to select
//    private let options: [String]
//
//    // MARK: - Initializers / Deinitializers
//    
//    public init(title: String, options: [String], delegate: OptionSelectionCardViewDelegate? = nil) {
//        self.title = title
//        self.delegate = delegate
//        self.options = options
//        
//        super.init(frame: .zero)
//
//        setupView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init?(coder aDecoder: NSCoder not implemented")
//    }
//
//    deinit {
//        STLog.info("\(Self.self) deinit")
//    }
//
//    // MARK: - Helper Methods
//
//    func setupView() {
//        titleLabel.text = title
//        backgroundColor = UIColor.black.withAlphaComponent(0.24)
//
//        let screenWidth = UIScreen.main.bounds.size.width
//        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
//        containerView.roundTopCorners(radius: 8.0, frame: frame)
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
//        tapGesture.delegate = self
//        isUserInteractionEnabled = true
//        addGestureRecognizer(tapGesture)
//
//        tableView.registerNibCell(OptionSelectTBCell.self)
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        addAllSubviews()
//    }
//
//    var containerViewBottomLC: NSLayoutConstraint!
//    func addAllSubviews() {
//        addSubview(containerView)
//        containerView.addSubview(crossButton)
//        containerView.addSubview(titleLabel)
//        containerView.addSubview(tableView)
//
//        // Intitialy move the card to the bottom of the screen
//        containerViewBottomLC = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: height + 5.0)
//        let constraints = [
//            containerView.heightAnchor.constraint(equalToConstant: height),
//            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            containerViewBottomLC!,
//
//            crossButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0),
//            crossButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
//
//            titleLabel.leadingAnchor.constraint(equalTo: crossButton.trailingAnchor, constant: 16.0),
//            titleLabel.centerYAnchor.constraint(equalTo: crossButton.centerYAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
//
//            tableView.topAnchor.constraint(equalTo: crossButton.bottomAnchor, constant: 16),
//            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//        ]
//        NSLayoutConstraint.activate(constraints)
//    }
//
//    func show() {
//        //layoutIfNeeded()
//        containerViewBottomLC.constant = -offest
//        UIView.animate(withDuration: 0.2) { [weak self] in
//            self?.layoutIfNeeded()
//        }
//    }
//
//    func hide() {
//        containerViewBottomLC.constant = height + 5.0
//        UIView.animate(withDuration: 0.2, animations: { [weak self] in
//            self?.layoutIfNeeded()
//        }) { [weak self] (finished) in
//            guard finished else { return }
//            self?.removeFromSuperview()
//        }
//    }
//
//
//    // MARK:- Action Methods
//
//    @objc func viewTapped(_ sender: UIGestureRecognizer) {
//        crossButtonTapped()
//    }
//
//    @objc func crossButtonTapped(_ sender: UIButton? = nil) {
//        delegate?.crossButtonTapped()
//    }
//}
//
//// MARK: - UIGestureRecognizerDelegate
//
//extension PopupSingleOptionSelectionView: UIGestureRecognizerDelegate {
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if let touchedView = touch.view,
//            touchedView.isDescendant(of: containerView) {
//            return false
//        }
//        return true
//    }
//}
//
//extension PopupSingleOptionSelectionView: UITableViewDataSource {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return options.count
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as OptionSelectTBCell
//        cell.titleLabel.text = options[indexPath.row]
//        return cell
//    }
//}
//
//extension PopupSingleOptionSelectionView: UITableViewDelegate {
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        delegate?.didSelectOption(optionIndex: indexPath.row, option: options[indexPath.row])
//    }
//}
