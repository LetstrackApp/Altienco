/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model object for the table view.
*/

import Foundation

/// The data model used to populate the table view on app launch.
struct Model {
    private(set) var placeNames = [
        "Yosemite",
        "Yellowstone",
        "Theodore Roosevelt",
        "Sequoia",
        "Pinnacles",
        "Mount Rainier",
        "Mammoth Cave",
        "Great Basin",
        "Grand Canyon"
    ]
    
    mutating func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        let place = placeNames[sourceIndex]
        placeNames.remove(at: sourceIndex)
        placeNames.insert(place, at: destinationIndex)
    }
    
    mutating func addItem(_ place: String, at index: Int) {
        placeNames.insert(place, at: index)
    }
}
