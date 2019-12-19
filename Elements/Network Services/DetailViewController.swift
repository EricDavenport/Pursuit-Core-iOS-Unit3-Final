//
//  DetailViewController.swift
//  Elements
//
//  Created by Eric Davenport on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var favoriteButton: UIBarButtonItem!
  @IBOutlet weak var elementImageView: UIImageView!
  @IBOutlet weak var elementWeight: UILabel!
  
  @IBOutlet weak var elementName: UILabel!
  @IBOutlet weak var elementSymbol: UILabel!
  @IBOutlet weak var elementNumber: UILabel!
  
  
  var thisElement: Element?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateDetailUI()
    disconnectHeart(for: thisElement!)
  }
  
  
  
  func updateDetailUI() {
    guard let element = thisElement else {
      fatalError("could not acces element type")
    }
    navigationItem.title = thisElement!.name.uppercased()
    elementWeight.text = thisElement?.atomic_mass?.description
    elementName.text = thisElement?.name
    elementSymbol.text = thisElement?.symbol
    elementNumber.text = thisElement?.number.description
    elementImageView.getImage(with: imageString(for: element)) {[weak self] (result) in
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
  
  
  func disconnectHeart(for element: Element) {
    if element.favoritedBy != nil {
      DispatchQueue.main.async {
        self.favoriteButton.isEnabled = false
        self.favoriteButton.image = UIImage(systemName: "heart.fill")
      }
    }
  }

  @IBAction func favoriteButton(_ sender: UIBarButtonItem) {
    
    guard let element = thisElement else {
      showAlert(title: "Failed", message: "Unable to favorite this element, please try again.")
      sender.isEnabled = true
      return
    }
    
    let favorite = Element(name: element.name, appearance: element.appearance, atomic_mass: element.atomic_mass, boil: element.boil, category: element.category, summary: element.summary, symbol: element.symbol, number: element.number, melt: element.melt, density: element.density, discovered_by: element.discovered_by, favoritedBy: "Eric D.")
    
    ElementAPIClient.makeFavorite(element: favorite) {[weak self, weak sender] (result) in
      DispatchQueue.main.async {
        sender?.isEnabled = false
      }
      switch result {
      case .failure(let appError):
        DispatchQueue.main.async {
          self?.showAlert(title: "Error", message: "\(appError.description)")
        }
      case .success:
        DispatchQueue.main.async {
          self?.showAlert(title: "Completed", message: "Added to your favorites") { action in
            self?.dismiss(animated: true)
          }
        }
      }
    }
  }
  
  func imageString(for element: Element) -> String {
    let urlString = "http://images-of-elements.com/\(element.name.lowercased()).jpg"
    return urlString
  }
  
  
}
