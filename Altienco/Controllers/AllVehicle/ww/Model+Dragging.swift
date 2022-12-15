/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helper methods for providing and consuming drag-and-drop data.
*/

import UIKit
import MobileCoreServices

extension Model {
    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let placeName = placeNames[indexPath.row]

        let data = placeName.data(using: .utf8)
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
}
