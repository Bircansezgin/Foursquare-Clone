//
//  placeModel.swift
//  foursQuareClone
//
//  Created by Bircan Sezgin on 27.06.2023.
//

import Foundation
import UIKit

// Sayfalar Arasi veri aktarimi icin, 'Singleton' Kullaniyoruz!
class PlaceModel{
    static let sharedInstance = PlaceModel()
    var accountName = ""
    var placeName = ""
    var placeType = ""
    var placeComment = ""
    var placeImage = UIImage()
    
    var placeLatitude = ""
    var placeLongitude = ""
    
    
    
    private init(){}
}


