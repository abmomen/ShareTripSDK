//
//  PaymentGatewaysView.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 03/12/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public enum paymentGatewayType: String {
    case visa     = "visa"
    case flight   = "flight"
    case hotel    = "hotel"
    case transfer = "transfer"
    case tour     = "tour"
    case holiday  = "Package"
}

public enum paymentGatewayCurrency: String, Codable {
    case all = "ALL"
    case usd = "USD"
    case bdt = "BDT"
}

public protocol PaymentGatewaysViewDelegate: AnyObject {
    func onPaymentGatewayFetchingFailed(with error: String)
    func onSelectGateway(paymentGateway: PaymentGateway?, selectedGatewaySeries: GatewaySeries?)
    func onFilterPaymentGateway(allPaymentGateways: [PaymentGateway], dafultPaymentGateway: PaymentGateway?)
}

public extension PaymentGatewaysViewDelegate {
    func onFilterPaymentGateway(dafultDiscountTypePaymentGateway: PaymentGateway) {}
}

public class PaymentGatewaysView: UIView, NibBased {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var paymentGatewayCollectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightLC: NSLayoutConstraint!
    @IBOutlet private weak var cardPrefixView: UIView!
    @IBOutlet private weak var cardPrefixTextField: NoSelectTextField!
    @IBOutlet private weak var pageControllView: UIView!
    @IBOutlet private weak var pageControllViewHLC: NSLayoutConstraint!
    
    private var viewModel: PaymentGatewaysViewModel!
    private var defaultSelectedIndexPath = IndexPath(row: 0, section: 0)
    private var initialSetupPerformed: Bool = false
    
    public weak var delegate: PaymentGatewaysViewDelegate?
    
    // MARK: - Private Properties
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .clearBlue
        pageControl.pageIndicatorTintColor = UIColor.clearBlue.withAlphaComponent(0.32)
        return pageControl
    }()
    
    public private(set) var paymentGatewayLoading: Observable<Bool> = Observable(false)
    private lazy var cardPrefixPicker: DataPickerView =  {
        let pickerView = DataPickerView()
        pickerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return pickerView
    }()
    
    private var selectedPaymentGatewayIndexPath: IndexPath? {
        didSet {
            onPaymentMethodChanged()
        }
    }
    private var selectedGateWaySeries: GatewaySeries? {
        didSet {
            onPaymentMethodChanged()
        }
    }
    
    private var allPaymentGateways = [PaymentGateway]() {
        didSet {
            setCollectionViewWidthHeight()
            initialSetupPerformed = false
            paymentGatewayCollectionView.reloadData()
        }
    }
    
    private var filter: ((PaymentGateway) -> Bool)?
    
    private var paymentGateways: [PaymentGateway] {
        guard let filter = filter else { return [] }
        return allPaymentGateways.filter(filter)
    }
    
    public func configure(_ serviceType: PaymentGatewayType, _ currency: String) {
        viewModel = PaymentGatewaysViewModel(serviceType, currency)
        viewModel.fetchPaymentGateways()
        handleNetworkResponse()
    }
    
    private func handleNetworkResponse() {
        viewModel.callBack.didFetchPaymentGateways = {[weak self] paymentGateways in
            self?.allPaymentGateways = paymentGateways
            self?.setupPageControllerView()
        }
        
        viewModel.callBack.onPaymentGatewayFetchingFailed = {[weak self] errorMessage in
            self?.delegate?.onPaymentGatewayFetchingFailed(with: errorMessage)
        }
    }
    
    // MARK: - Life Cycle Methods
    public override func awakeFromNib() {
        super.awakeFromNib()

        paymentGatewayCollectionView.registerCell(PaymentGatewayCell.self)
        paymentGatewayCollectionView.dataSource = self
        paymentGatewayCollectionView.delegate = self
        paymentGatewayCollectionView.showsHorizontalScrollIndicator = false
        
        let toolbar = UIToolbar.toolbarPicker(title: "Select Card Prefix", tag: 1, target: self,
                                              doneSelector: #selector(donePickerViewButtonTapped(_:)),
                                              cancelSelector: #selector(cancelPickerViewButtonTapped(_:)))
        cardPrefixTextField.inputView = cardPrefixPicker
        cardPrefixTextField.inputAccessoryView = toolbar
        cardPrefixTextField.setRightImageView(imageLink: "arrow-down-mono", tintColor: UIColor.blueGray)
        cardPrefixView.isHidden = true
    }
    
    // MARK: - Utils
    private func resetData() {
        selectedPaymentGatewayIndexPath = nil
        selectedGateWaySeries = nil
        cardPrefixView.isHidden = true
    }
    
    //MARK: - PageController functions
    private func setupPageControllerView() {
        pageControl.numberOfPages = setPageControllerPages()
        pageControllView.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: pageControllView.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: pageControllView.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: pageControllView.trailingAnchor),
            pageControl.topAnchor.constraint(equalTo: pageControllView.topAnchor)
        ])
    }
    
    private var onScreenCollectionViewCells = 8
    
    private func setPageControllerPages() -> Int {
        if paymentGateways.count > onScreenCollectionViewCells {
            pageControllViewHLC.constant = 35
            return ((paymentGateways.count - onScreenCollectionViewCells) / 2) + ((paymentGateways.count - onScreenCollectionViewCells) % 2) + 1
        } else {
            if collectionViewHeightLC.constant == CGFloat(paymentOptionsCollectionViewHeight) {
                if paymentGateways.count == 4 {
                    pageControllViewHLC.constant = 35
                    return 2
                }
                else {
                    pageControllViewHLC.constant = 5
                    return 0
                    
                }
            }
            pageControllViewHLC.constant = 5
            return 0
        }
    }
    
    private func setSelectedPageControllerPage(indexArray: [Int]) -> Int {
        guard let maxValue = indexArray.max() else {return 0}
        
        if (maxValue + 1) <= onScreenCollectionViewCells {
            if collectionViewHeightLC.constant == CGFloat(paymentOptionsCollectionViewHeight) {
                if (maxValue + 1) == 4 {
                    return 1
                }
            }
            return 0
        }
        else { return (((maxValue + 1) - onScreenCollectionViewCells) / 2) + (((maxValue + 1) - onScreenCollectionViewCells) % 2)}
    }
    
    
    //MARK: - Payment getway property and methods
    public func filterPaymentGateways(filter: @escaping (PaymentGateway) -> Bool) {
        self.filter = filter
        resetData()
        pageControl.numberOfPages = setPageControllerPages()
        setCollectionViewWidthHeight()
        initialSetupPerformed = false
        paymentGatewayCollectionView.reloadData()
    }
    
    private func onPaymentMethodChanged() {
        guard let indexPath = selectedPaymentGatewayIndexPath else {
            delegate?.onSelectGateway(paymentGateway: nil, selectedGatewaySeries: nil)
            return
        }
        let paymentGateway = paymentGateways[indexPath.row]
        delegate?.onSelectGateway(paymentGateway: paymentGateway, selectedGatewaySeries: selectedGateWaySeries)
    }
    
    @objc
    private func donePickerViewButtonTapped(_ button: UIBarButtonItem?) {
        cardPrefixTextField?.resignFirstResponder()
        let selectedValue = cardPrefixPicker.selectedValue
        guard let index = selectedPaymentGatewayIndexPath?.item, index < paymentGateways.count else { return }
        let paymentGateway = paymentGateways[index]
        guard let gatewaySeries = (paymentGateway.series.filter { $0.series == selectedValue }.first) else { return }
        cardPrefixTextField.text = gatewaySeries.series
        selectedGateWaySeries = gatewaySeries
    }
    
    @objc
    private func cancelPickerViewButtonTapped(_ button: UIBarButtonItem?) {
        cardPrefixTextField?.resignFirstResponder()
    }
    
    //MARK: - Collectionview properties and methods
    private var paymentOptionsCellWidth: Double {
        return  Double((paymentGatewayCollectionView.bounds.width / 3 - 15))
    }
    private var paymentOptionsCellHeight: Double {
        return paymentOptionsCellWidth * 0.60
    }
    private var paymentOptionsCollectionViewHeight: Double = 150.0
    private func setCollectionViewWidthHeight() {
        if paymentGateways.count > 4 {
            paymentOptionsCollectionViewHeight = paymentOptionsCellHeight * 2 + 10
            collectionViewHeightLC.constant = CGFloat(paymentOptionsCollectionViewHeight)
        } else {
            paymentOptionsCollectionViewHeight = paymentOptionsCellHeight + 10
            collectionViewHeightLC.constant = CGFloat(paymentOptionsCollectionViewHeight)
        }
    }
}

//MARK: - UICollectionview DataSource and Delegates
extension PaymentGatewaysView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentGateways.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let paymentGateway = paymentGateways[indexPath.row]
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PaymentGatewayCell
        cell.configure(imageLink: paymentGateway.logo.small)
        
        if !initialSetupPerformed && selectedPaymentGatewayIndexPath == nil {
            collectionView.selectItem(at: defaultSelectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
            initialSetupPerformed = true
            cell.setCellSelection(selected: true)
            selectedPaymentGatewayIndexPath = indexPath
            cardPrefixPicker.data = paymentGateway.series.map { $0.series }
            cardPrefixView.isHidden = paymentGateway.series.count == 0
        } else {
            if let selectedIndexPath = selectedPaymentGatewayIndexPath,
               indexPath == selectedIndexPath {
                cell.setCellSelection(selected: true)
            } else {
                cell.setCellSelection(selected: false)
            }
        }
        return cell
    }
}

extension PaymentGatewaysView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let paymentGateway = paymentGateways[indexPath.row]
        cardPrefixTextField.text = nil
        
        /// deselect previously selected cell
        if let previouslySelectedIndexPath = selectedPaymentGatewayIndexPath,
           let cell = collectionView.cellForItem(at: previouslySelectedIndexPath) as? PaymentGatewayCell {
            cell.setCellSelection(selected: false)
        }
        
        /// if indexPath is previously selected indexPath then clear selection,
        /// otherwise select new indexPath
        if let previouslySelectedIndexPath = selectedPaymentGatewayIndexPath,
           indexPath == previouslySelectedIndexPath {
            selectedPaymentGatewayIndexPath = nil
            cardPrefixPicker.data = nil
            cardPrefixView.isHidden = true
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? PaymentGatewayCell {
                cell.setCellSelection(selected: true)
            }
            selectedPaymentGatewayIndexPath = indexPath
            cardPrefixPicker.data = paymentGateway.series.map { $0.series }
            cardPrefixView.isHidden = paymentGateway.series.count == 0
        }
        
        selectedGateWaySeries = nil
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: paymentOptionsCellWidth, height: paymentOptionsCellHeight)
    }
}

//MARK: - PageController Functionality
extension PaymentGatewaysView {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        getVisibleCollectionviewCells()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        getVisibleCollectionviewCells()
    }
    
    private func getVisibleCollectionviewCells(){
        var indexArray = [Int]()
        for cells in paymentGatewayCollectionView.visibleCells {
            if let indexPath = paymentGatewayCollectionView.indexPath(for: cells) {
                indexArray.append(indexPath.row)
            }
        }
        pageControl.currentPage = setSelectedPageControllerPage(indexArray: indexArray)
    }
}
