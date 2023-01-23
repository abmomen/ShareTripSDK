//
//  BaggageSelectionCell.swift
//  ShareTrip
//
//  Created by ShareTrip iOS on 8/12/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit


protocol BaggageSelectionCellDelegate: AnyObject {
    func baggageSelectionChanged()
    func collapseRoute(indexPath: IndexPath?)
}

class BaggageSelectionCell: UITableViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var totalChargeLabel: UILabel!
    @IBOutlet private weak var currencyImageView: UIImageView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var arrowIndicatorButton: UIButton!
    @IBOutlet private weak var baggageImageView: UIImageView!
    
    private var viewModel: BaggageViewModel?
    private var flightViewModel: FlightDetailsViewModel?
    private weak var delegate: BaggageSelectionCellDelegate?
    private var indexPath: IndexPath?
    private var baggageResponseType: FlightDetailsVC.BaggageResponseType?
    var addBaggageIndicator: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetupView()
        baggageImageView.image = UIImage(named: "baggage-mono")
    }
    
    func configure(viewModel: BaggageViewModel?, flightViewModel: FlightDetailsViewModel?, baggageResponseType: FlightDetailsVC.BaggageResponseType, indexPath: IndexPath?, delegate: BaggageSelectionCellDelegate?) {
        self.viewModel = viewModel
        self.flightViewModel = flightViewModel
        self.indexPath = indexPath
        self.baggageResponseType = baggageResponseType
        self.delegate = delegate
        initialSetupView()
    }
    
    @IBAction private func arrowIndicatorButtonTap(_ sender: Any) {
        if ((flightViewModel?.addBaggageCollupseIndicator ?? false)) {
            let image = UIImage(named: "arrow-up-fat-mono")?.tint(with: .appPrimary)
            arrowIndicatorButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "arrow-down-fat-mono")?.tint(with: .appPrimary)
            arrowIndicatorButton.setImage(image, for: .normal)
        }
        flightViewModel?.addBaggageCollupseIndicator.toggle()
        reloadView()
    }
    
    
    private func initialSetupView() {
        containerView.layer.cornerRadius = 8.0
        containerView.clipsToBounds = true
        selectionStyle = .none
        totalChargeLabel.text = viewModel?.getTotalPrice().withCommas()
        setCollupseStatusOfStackView()
    }
    
    private func setupView() {
        guard let baggageViewModel = viewModel else { return }
                
        if baggageViewModel.isBaggageForWholeFlight() {
            stackView.addArrangedSubview(BaggageRouteView(baggageViewModel: baggageViewModel, routeIndex: 0, delegate: self))
            return
        }
        
        for index in 0..<baggageViewModel.totalRoutesCount() {
            stackView.addArrangedSubview(BaggageRouteView(baggageViewModel: baggageViewModel, routeIndex: index, delegate: self))
        }
        
    }
    
    private func setCollupseStatusOfStackView() {
        for view in stackView.subviews { view.removeFromSuperview() }
        
        if flightViewModel?.addBaggageCollupseIndicator == false {
            let image = UIImage(named: "arrow-down-fat-mono")?.tint(with: .appPrimary)
            arrowIndicatorButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "arrow-up-fat-mono")?.tint(with: .appPrimary)
            arrowIndicatorButton.setImage(image, for: .normal)
            
            switch baggageResponseType {
            case .success:
                setupView()
            case .error:
                setupBaggageNotFoundView(with: "Extra baggage not available for this flight")
            case .none:
                setupBaggageNotFoundView(with: "Extra baggage not available for this flight")
            case .unknown:
                setupBaggageNotFoundView(with: "Loading Baggage options...")
            }
        }
    }
    
    private func setupBaggageNotFoundView(with message: String){
        stackView.addArrangedSubview(BaggageNotFoundView(messageText: message))
    }
}

class BaggageNotFoundView: UIView {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        messageLabel.textAlignment = .center
        messageLabel.textColor = .black
        return messageLabel
    }()
    
    var loadingTimer: Timer?
    
    init(messageText: String = "") {
        super.init(frame: .zero)
        messageLabel.text = messageText
        setupView()
    }
    
    deinit {
        self.loadingTimer?.invalidate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(messageLabel)
        NSLayoutConstraint.activate ([
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 80.0),
            
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            
        ])
    }
}

extension BaggageSelectionCell: BaggageRouteViewDelegate {
    func reloadView() {
        delegate?.collapseRoute(indexPath: indexPath)
        delegate?.baggageSelectionChanged()
    }
}
