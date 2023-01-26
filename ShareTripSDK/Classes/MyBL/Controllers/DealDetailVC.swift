//
//  DealsDetailVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 4/29/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

class DealDetailVC: ViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .offWhite
        tableView.registerNibCell(ImageViewCell.self)
        tableView.registerNibCell(DealDetailCell.self)
        tableView.registerNibCell(SingleButtonCardCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel: DealDetailsViewModel
    
    init(viewModel: DealDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewControllers Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupScene()
    }
    
    // MARK: - Helpers
    private func setupNavigationItems() {
        title = viewModel.title
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupScene() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc
    private func backButtonTapped(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView DataSource and Delegate
extension DealDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.cells[indexPath.row] {
        case .image:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ImageViewCell
            cell.imageURL = viewModel.dealImageStr ?? ""
            return cell
            
        case .description:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DealDetailCell
            cell.configure(dealsAndUpdates: viewModel.deal)
            return cell
            
        case .action:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleButtonCardCell
            cell.configure(title: "SEARCH FLIGHT", titleColor: .white, backgroundColor: .appPrimary)
            cell.callBack = {[weak self] in
                self?.navigationController?.pushViewController(FlightSearchVC.instantiate(), animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch viewModel.cells[indexPath.row] {
        case .image:
            openFullScreenImageViewer(urlStr: viewModel.deal.imageUrl ?? "")
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.cells[indexPath.row] {
        case .image:
            return 160
        default:
            return UITableView.automaticDimension
        }
    }
    
    private func openFullScreenImageViewer(urlStr: String){
        if let kingfisherSource = KingfisherSource(urlString: urlStr) {
            let fullscreen = FullScreenSlideshowViewController()
            fullscreen.inputs = [kingfisherSource]
            fullscreen.slideshow.activityIndicator = DefaultActivityIndicator()
            fullscreen.modalPresentationStyle = .fullScreen
            fullscreen.modalTransitionStyle = .crossDissolve
            present(fullscreen, animated: true, completion: nil)
        }
    }
}
