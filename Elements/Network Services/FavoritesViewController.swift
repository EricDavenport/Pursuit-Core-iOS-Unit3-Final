//
//  FavoritesViewController.swift
//  Elements
//
//  Created by Eric Davenport on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var refreshControl: UIRefreshControl!

  
  var elements = [Element]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    configureRefreshControl()
    getFavorites()
    
  }
  
  private func configureRefreshControl() {
    refreshControl = UIRefreshControl()
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(getFavorites), for: .valueChanged)
  }
  
  @objc func getFavorites() {
    ElementAPIClient.getFavorites { [weak self] (result) in
      switch result {
      case .failure(let appError):
        print("\(appError)")
        self?.refreshControl.endRefreshing()
      case .success(let element):
        DispatchQueue.main.async {
          self?.elements = element
          self?.refreshControl.endRefreshing()
        }
      }
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let navController = segue.destination as? UINavigationController,
      let detailController = navController.viewControllers.first as? DetailViewController,
      let indexPath = tableView.indexPathForSelectedRow else {
        fatalError("Failed to properly segue from main view controller")
    }
    let thisElement = elements[indexPath.row]
    
    detailController.thisElement = thisElement
    
  }
  
  
  
  
  
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? CustomElementCell else {
      fatalError("failed to deque from favorite vc")
    }
    
    let element = elements[indexPath.row]
    
    cell.configureCell(for: element)
    
    
    return cell
    
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return elements.count
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
}
