//
//  ViewController.swift
//  Elements
//
//  Created by Alex Paul on 12/31/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var elements = [Element]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  var additionalElements = [Element]()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    getElements()
  }
  
  
  func getElements() {
    ElementAPIClient.getElements( completion: { [weak self] (result) in
      switch result {
      case .failure(let appError):
        print("\(appError)")
      case .success(let elements):
        ElementAPIClient.additionalEighteenElements { (result) in
          switch result {
          case .failure(let appError2):
            print("additional element not found Error:\(appError2)")
          case .success(let element2):
            DispatchQueue.main.async {
              self?.additionalElements = element2
              self?.elements.append(contentsOf: element2)
            }
          }
        }
        DispatchQueue.main.async {
          self?.elements.append(contentsOf: elements)
        }
      }
    } )
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

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let elementCell = tableView.dequeueReusableCell(withIdentifier: "elementCell", for: indexPath) as? CustomElementCell else {
      fatalError("failed to deque cell propely, check MainViewController")
    }
    
    let element = elements[indexPath.row]
    
    elementCell.configureCell(for: element)
    
    return elementCell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return elements.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 260
  }
}

