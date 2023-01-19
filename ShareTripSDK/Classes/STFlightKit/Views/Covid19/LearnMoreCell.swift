//
//  ShowMoreCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 14/03/2021.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import UIKit


enum UserInfoOptionalRowType {
    case covid
    case insurance
}

extension LearnMoreCell {
    class Callback {
        var covidDetail: (_ indexPath: IndexPath, _ detail: Covid19TestCenterDetails?) -> Void = { _,_  in }
        var insuranceDetail: (_ indexPath: IndexPath, _ detail: TravelInsuranceDetails?) -> Void = { _,_ in }
    }
}

class LearnMoreCell: UITableViewCell {

    @IBOutlet weak private var learnMoreCollectionView: UICollectionView!
    @IBOutlet weak private var learnMoreLabel: UILabel!
    
    private var covid19TestCenterDetails: [Covid19TestCenterDetails]?
    private var travelInsuranceDetails: [TravelInsuranceDetails]?
    private var indexPath: IndexPath?
    
    let callback = Callback()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupCV()
    }
    
    private var cellType: UserInfoOptionalRowType = .covid
    
    // MARK: - Init
    func config(indexPath: IndexPath,
                covid19TestCenterDetail: [Covid19TestCenterDetails],
                type: UserInfoOptionalRowType ) {
        self.indexPath = indexPath
        self.cellType = type
        self.covid19TestCenterDetails = covid19TestCenterDetail
    }
    
    func configureForInsurance(indexPath: IndexPath,
                               type: UserInfoOptionalRowType,
                               detail: [TravelInsuranceDetails]) {
        self.indexPath = indexPath
        self.cellType = type
        self.travelInsuranceDetails = detail
    }
    
    // MARK: - Utils
    private func setupCV(){
        learnMoreCollectionView.delegate = self
        learnMoreCollectionView.dataSource = self
        learnMoreCollectionView.registerNibCell(LearnMoreCVCell.self)
    }
    
    private func setupUI(){
        let attributedString = NSMutableAttributedString(string: "Learn More")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 1.88, range: NSRange(location: 0, length: attributedString.length - 1))
        attributedString.addAttributes(
            [
                NSAttributedString.Key.kern: 1.88,
                NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .medium)
            ],
            range: NSRange(location: 0, length: attributedString.length))
        learnMoreLabel.attributedText = attributedString
    }
}

// MARK: - UICollectionview Delegate and Datasource
extension LearnMoreCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellType == .covid {
            return covid19TestCenterDetails?.count ?? 0
        } else if cellType == .insurance {
            return travelInsuranceDetails?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellType == .covid {
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as LearnMoreCVCell
            cell.configure(covid19TestCenterDetails: self.covid19TestCenterDetails?[indexPath.row])
            return cell
        } else if cellType == .insurance {
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as LearnMoreCVCell
            cell.configureForInsurance(detail: self.travelInsuranceDetails?[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if cellType == .covid {
            self.callback.covidDetail(indexPath, self.covid19TestCenterDetails?[indexPath.row])
        } else if cellType == .insurance {
            self.callback.insuranceDetail(indexPath, self.travelInsuranceDetails?[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width)/2.0
        return CGSize(width: width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
