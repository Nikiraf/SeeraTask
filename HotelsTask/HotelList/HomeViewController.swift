//
//  HomeViewController.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 1.4.23..
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var sortAndMapView: UIView!
  @IBOutlet weak var sortButton: UIButton!
  @IBOutlet weak var mapButton: UIButton!
  @IBOutlet weak var loader: UIActivityIndicatorView!
  @IBOutlet weak var searchBar: SearchBarView!
  
  let refreshControl = UIRefreshControl()
  
  let viewModel = HotelListViewModel()
  
  let hotelCellIdentifier: String = "HotelTableViewCell"
  
  @IBAction func sortButtonAction(_ sender: Any) {
    if !loader.isAnimating {
      showSortingPopup()
    }
  }
  
  @IBAction func mapButtonAction(_ sender: Any) {
    if !viewModel.hotelsCellModel.isEmpty && !loader.isAnimating {
      presentMapController()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UINib(nibName: hotelCellIdentifier, bundle: nil), forCellReuseIdentifier: hotelCellIdentifier)
    refreshControl.addTarget(self, action: #selector(loadNewData), for: .valueChanged)
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.refreshControl = refreshControl
    
    viewModel.delegate = self
    updateUI()
    self.loader.startAnimating()
    
    viewModel.loadData()
    
    searchBar.performSearch = { [unowned self] (searchQuery: String) in
      self.viewModel.findHotelsByName(searchQuery)
    }
    
  }
  
  func updateUI() {
    title = NSLocalizedString("hotels", comment: "")
    searchBar.placeholder = NSLocalizedString("search_bar_placeholder", comment: "")
    sortButton.setTitle(NSLocalizedString("button_sort_title", comment: ""), for: .normal)
    mapButton.setTitle(NSLocalizedString("button_map_title", comment: ""), for: .normal)
  }
  
  // MARK: Present controller and sort popup
  @objc
  func showSortingPopup() {
    let actionSheet = UIAlertController(title: nil, message: NSLocalizedString("sort_by_title", comment: ""), preferredStyle: .actionSheet)
    
    let sortByRecommended = UIAlertAction(title: NSLocalizedString("sort_by_recommended", comment: ""), style: .default) { [weak self] action in
      self?.viewModel.sortBy(.recommended)
    }
    let sortByLowestPrice = UIAlertAction(title: NSLocalizedString("sort_by_lowest_price", comment: ""), style: .default) { [weak self] action in
      self?.viewModel.sortBy(.lowestPrice)
    }
    let sortByStarRating = UIAlertAction(title: NSLocalizedString("sort_by_star_rating", comment: ""), style: .default) { [weak self] action in
      self?.viewModel.sortBy(.starRating)
    }
    let sortByStarDistance = UIAlertAction(title: NSLocalizedString("sort_by_distance", comment: ""), style: .default) { [weak self] action in
      self?.viewModel.sortBy(.distance)
    }
    let cancelAction = UIAlertAction(title: NSLocalizedString("button_title_cancel", comment: ""), style: .cancel)
    
    actionSheet.addAction(sortByRecommended)
    actionSheet.addAction(sortByLowestPrice)
    actionSheet.addAction(sortByStarRating)
    actionSheet.addAction(sortByStarDistance)
    actionSheet.addAction(cancelAction)
    
    actionSheet.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    DispatchQueue.main.async {
      self.present(actionSheet, animated: true, completion: nil)
    }
  }
  
  func presentMapController() {
    let hotelsOnMap = viewModel.makeHotelMapItem()
    let vc = self.storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
    vc.modalPresentationStyle = .fullScreen
    vc.hotels = hotelsOnMap
    self.present(vc, animated: true)
  }
  
  // MARK: Helper
  @objc
  func loadNewData() {
    viewModel.loadData(isPullToRefresh: true)
  }
  
}

// MARK: Search Bar
extension HomeViewController: HotelsSearchProtocol {
  func enableSearchInput(_ enable: Bool) {
    searchBar.isSearchEnabled = enable
  }
  
  func dataFetched() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  func dataSorted() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  func insertNewElements(_ newElements: [HotelCellModel]) {
    DispatchQueue.main.async {
      let numberOfRows: Int = self.tableView.numberOfRows(inSection: 0)
    
      var newIndexPath: [IndexPath] = []
      for i in numberOfRows ..< self.viewModel.hotelsCellModel.count {
        let ip = IndexPath(row: i, section: 0)
        newIndexPath.append(ip)
      }
      self.tableView.insertRows(at: newIndexPath, with: .none)
    }
  }
  
  func showError(_ error: Error) {
    DispatchQueue.main.async {
      self.showAlert(title: "", text: error.localizedDescription)
    }
  }
  
  func startLoader() {
    DispatchQueue.main.async {
      self.loader.startAnimating()
    }
  }
  
  func stopLoader(isPullToRefresh: Bool) {
    DispatchQueue.main.async {
      isPullToRefresh ? self.refreshControl.endRefreshing() : self.loader.stopAnimating()
    }
  }
  
}
// MARK: Table view data source and delefate
extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.viewModel.hotelsCellModel.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: hotelCellIdentifier) as! HotelTableViewCell
    viewModel.currentIndex = indexPath.row
    cell.setCell(viewModel.hotelsCellModel[indexPath.row])
    viewModel.populateModelWithNewData()
    return cell
  }
  
}

extension HomeViewController: UITableViewDelegate {
  private func tableView(tableView: UITableView,
      heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      return UITableView.automaticDimension
  }
}
