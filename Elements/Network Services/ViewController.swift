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
        DispatchQueue.main.async {
          self?.elements = elements
        }
      }
    } )
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let detailVC = segue.destination as? DetailViewController,
      let indexPath = tableView.indexPathForSelectedRow else {
        fatalError("failed to properly sugue")
    }
    let thisElement = elements[indexPath.row]
    
    detailVC.thisElement = thisElement
  
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

