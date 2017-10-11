//
//  AnnotationModel.swift
//  CSD Hubs
//
//  Created by Manish on 08/10/17.
//  Copyright © 2017 Manish Sharma. All rights reserved.
//

import Foundation

import UIKit

import CoreLocation

public struct AnnotationModel {
    
    public let coordinates: CLLocationCoordinate2D
    public let title: String
    public let address:String
    public init(coordinate: CLLocationCoordinate2D,titleString:String,addressText:String) {
        
        coordinates = coordinate
        title = titleString
        address = addressText
    }
}
