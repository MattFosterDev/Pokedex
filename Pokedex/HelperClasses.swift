//
//  HelperClasses.swift
//  Pokedex
//
//  Created by Matt Foster on 22/08/2021.
//

import Foundation

struct PokemonIDFormatter {
    func formatPokemonID(idNo:Int) -> String {
        var formattedNo = "#"
        var iterator = idNo
        while iterator < 100 {
            iterator *= 10
            formattedNo.append("0")
        }
        formattedNo.append(String(idNo))
        return formattedNo
    }
}
