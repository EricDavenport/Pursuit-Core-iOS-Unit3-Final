//
//  ElementsModel.swift
//  Elements
//
//  Created by Eric Davenport on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct Element: Codable {
  let name: String
  let appearance: String?
  let atomic_mass: Double
  let boil: Double?
  let category: String
  let summary: String
  let symbol: String
  let number: Int
  let period: Int
  let melt: Double?
  let density: Double?
  let discovered_by: String?
  let favoritedBy: String?
}



//{
//    "name": "Hydrogen",
//    "appearance": "colorless gas",
//    "atomic_mass": 1.008,
//    "boil": 20.271,
//    "category": "diatomic nonmetal",
//    "color": null,
//    "density": 0.08988,
//    "discovered_by": "Henry Cavendish",
//    "melt": 13.99,
//    "molar_heat": 28.836,
//    "named_by": "Antoine Lavoisier",
//    "number": 1,
//    "period": 1,
//    "phase": "Gas",
//    "source": "https://en.wikipedia.org/wiki/Hydrogen",
//    "spectral_img": "https://en.wikipedia.org/wiki/File:Hydrogen_Spectra.jpg",
//    "summary": "Hydrogen is a chemical element with chemical symbol H and atomic number 1. With an atomic weight of 1.00794 u, hydrogen is the lightest element on the periodic table. Its monatomic form (H) is the most abundant chemical substance in the Universe, constituting roughly 75% of all baryonic mass.",
//    "symbol": "H",
//    "xpos": 1,
//    "ypos": 1,
//    "shells": [
//        1
//    ]
//}
