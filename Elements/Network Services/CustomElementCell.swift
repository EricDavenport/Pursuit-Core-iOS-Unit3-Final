//
//  CustomElementCell.swift
//  Elements
//
//  Created by Eric Davenport on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class CustomElementCell: UITableViewCell {
  @IBOutlet weak var elementImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  

  func configureCell(for element: Element) {
    
    DispatchQueue.main.async {
      self.nameLabel.text = element.name
      self.infoLabel.text = "Discovered by: \(String(describing: element.discovered_by ?? "N/A"))"
      self.elementImageView.getImage(with: self.imageString(for: element)) { [weak self] (result) in
        switch result {
        case .failure:
        DispatchQueue.main.async {
          self?.elementImageView.image = UIImage(systemName: "sun.min")
        }
        case .success(let image):
          DispatchQueue.main.async {
          self?.elementImageView.image = image
          }
        }
      }
    }
  }
  
  func imageString(for element: Element) -> String {
    var urlString = ""
    if element.number < 10 {
      urlString = "http://www.theodoregray.com/periodictable/Tiles/00\(element.number)/s7.JPG"
    } else if element.number < 100 {
      urlString = "http://www.theodoregray.com/periodictable/Tiles/0\(element.number)/s7.JPG"
    } else {
      urlString = "http://www.theodoregray.com/periodictable/Tiles/\(element.number)/s7.JPG"
    }
    return urlString
  }
  

}
