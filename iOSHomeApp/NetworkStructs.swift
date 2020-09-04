//
//  NetworkStructs.swift
//  iOSHomeApp
//
//  Created by Matthias Fischer on 04.09.20.
//  Copyright © 2020 Matthias Fischer. All rights reserved.
//

import Foundation

struct TokenCreationResponseModel: Codable {
    var success : Bool
    var token : String
}

struct HomeViewValueModel: Codable {
    var key : String
    var value : String
}

struct HomeViewPlaceModel: Codable {
    var name : String
    var values : [HomeViewValueModel]
}

struct HomeViewModel: Codable {
    var places : [HomeViewPlaceModel]
}
