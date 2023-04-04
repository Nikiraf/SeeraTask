//
//  SearchBarView.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 2.4.23..
//

import UIKit

final class SearchBarView: UIView {
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  var performSearch: ((String) -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureView()
    searchBar.delegate = self
  }
  
  private func configureView() {
    guard let view = self.loadViewFromNib(nibName: "SearchBarView") else { return }
    view.autoresizingMask = [.flexibleWidth]
    view.frame = self.bounds
    searchBar.isUserInteractionEnabled = false
    self.addSubview(view)
  }
}

//MARK: Delegates
extension SearchBarView: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchQuery = searchBar.text, !searchQuery.isEmpty else {
      return
    }
    DispatchQueue.main.async {
      self.searchBar.resignFirstResponder()
    }
    performSearch?(searchQuery)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    DispatchQueue.main.async {
      self.searchBar.resignFirstResponder()
    }
    performSearch?("")
  }
  
}

// MARK: Public properties
extension SearchBarView {
  public var placeholder: String {
    get { return searchBar.placeholder ?? "" }
    set {
      DispatchQueue.main.async {
        self.searchBar.placeholder = newValue
      }
    }
  }
  public var isSearchEnabled: Bool {
    get { return searchBar.isUserInteractionEnabled }
    set {
      DispatchQueue.main.async {
        self.searchBar.isUserInteractionEnabled = newValue
      }
    }
  }
}


