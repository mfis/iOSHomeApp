//
//  Mocks.swift
//  iOSHomeApp
//
//  Created by Matthias Fischer on 04.09.20.
//  Copyright © 2020 Matthias Fischer. All rights reserved.
//

import Foundation

func homeViewModelMock() -> HomeViewModel {
    
    let val1Place1 = HomeViewValueModel(key: "Temperatur", value: "21°C")
    let val2Place1 = HomeViewValueModel(key: "Thermostat", value: "20°C")
    let place1 = HomeViewPlaceModel(name: "Badezimmer", values: [val1Place1, val2Place1])
    
    let val1Place2 = HomeViewValueModel(key: "Temperatur", value: "23°C")
    let place2 = HomeViewPlaceModel(name: "Wohnzimmer", values: [val1Place2])
    
    return HomeViewModel(places: [place1, place2])
}
