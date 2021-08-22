//
//  PokedexModel.swift
//  Pokedex
//
//  Created by Matt Foster on 21/08/2021.
//

import Foundation

class PokedexModel:ObservableObject {
    private var pokemonArray = PokemonIndex()
    var pokemon:[Pokemon] {
        get { return pokemonArray.results }
        set {
            pokemonArray.results = newValue
        }
    }
    
    init(data:Data?){
        loadData(data: data)
    }

    func loadData(data: Data?) {
        do {
            try pokemonArray = JSONDecoder().decode(PokemonIndex.self, from: data!)
            
        } catch let error as NSError{
            print("Error reading JSON file: \(error.localizedDescription)")
        }
    }
}

struct PokemonIndex:Codable {
    var results:[Pokemon] = []
}

struct Pokemon:Codable {
    enum CodingKeys: String, CodingKey {
        case name, url
    }
    
    var name:String
    var url:String
    
    init(from decoder:Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        name = try results.decode(String.self, forKey: .name)
        url = try results.decode(String.self, forKey: .url)
    }
}
