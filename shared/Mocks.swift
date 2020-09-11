//
//  Mocks.swift
//  iOSHomeApp
//
//  Created by Matthias Fischer on 04.09.20.
//  Copyright © 2020 Matthias Fischer. All rights reserved.
//

import Foundation

func homeViewModelMock() -> HomeViewModel {
    
    let val1Place1 = HomeViewValueModel(id: "val1Place1" , key: "Temperatur", value: "21°C", accent: "00cc00")
    let val2Place1 = HomeViewValueModel(id: "val2Place1" , key: "Thermostat", value: "20°C", accent: "8c8c8c")
    let place1 = HomeViewPlaceModel(id: "place1" , name: "Badezimmer", values: [val1Place1, val2Place1])
    
    let val1Place2 = HomeViewValueModel(id: "val1Place2" , key: "Temperatur", value: "26°C", accent: "ff0000")
    let place2 = HomeViewPlaceModel(id: "place2" , name: "Wohnzimmer", values: [val1Place2])

    let val1Place3 = HomeViewValueModel(id: "val1Place3" , key: "Strom Haus", value: "4,6 kW/h", accent: "8c8c8c")
    let place3 = HomeViewPlaceModel(id: "place3" , name: "Energie", values: [val1Place3])
    
    let val1Place4 = HomeViewValueModel(id: "val1Place4" , key: "Temperatur", value: "16°C", accent: "1e4eeb")
    let place4 = HomeViewPlaceModel(id: "place4" , name: "Draußen", values: [val1Place4])
    
    return HomeViewModel(timestamp: "20:01", places: [place1, place2, place3, place4])
}
