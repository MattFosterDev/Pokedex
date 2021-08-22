//
//  PokemonDetailModel.swift
//  Pokedex
//
//  Created by Matt Foster on 21/08/2021.
//

import Foundation

enum PokemonTypeEnum: String, Codable {
    case normal, fighting, flying, poison, ground, rock, bug, ghost, steel, fire, water, grass, electric, psychic, ice, dragon, dark, fairy, unknown, shadow
}

class PokemonDetailModel:ObservableObject {
    var pokemonDetails:PokemonDetail?
    
    init(data:Data?){
        loadData(data: data)
    }

    func loadData(data: Data?) {
        do {
            try pokemonDetails = JSONDecoder().decode(PokemonDetail.self, from: data!)
            
        } catch let error as NSError{
            print("Error reading JSON file: \(error.localizedDescription)")
        }
    }
}

struct PokemonDetail:Codable {
    enum CodingKeys: String, CodingKey {
        case id, height, sprites, stats, weight, types
    }
    
    var id:Int
    var height:Int
    var sprites:PokemonSprites
    var stats:[PokemonStats]
    var weight:Int
    var types:[PokemonTypes]
    
    init(from decoder:Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        id = try results.decode(Int.self, forKey: .id)
        height = try results.decode(Int.self, forKey: .height)
        weight = try results.decode(Int.self, forKey: .weight)
        sprites = try results.decode(PokemonSprites.self, forKey: .sprites)
        stats = try results.decode([PokemonStats].self, forKey: .stats)
        types = try results.decode([PokemonTypes].self, forKey: .types)
    }
}

struct PokemonSprites:Codable {
    enum CodingKeys: String, CodingKey {
        case front_default
    }
    
    var front_default:String
    
    init(from decoder:Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        front_default = try results.decode(String.self, forKey: .front_default)
    }
}

struct PokemonTypes:Codable {
    enum CodingKeys: String, CodingKey {
        case type, slot
    }
    
    var type:PokemonType
    var slot:Int
    
    init(from decoder:Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        type = try results.decode(PokemonType.self, forKey: .type)
        slot = try results.decode(Int.self, forKey: .slot)
    }
}

struct PokemonType:Codable {
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    var name:PokemonTypeEnum
    
    init(from decoder:Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        name = try results.decode(PokemonTypeEnum.self, forKey: .name)
    }
    
}

struct PokemonStats:Codable {
    enum CodingKeys: String, CodingKey {
        case base_stat, stat
    }
    
    var base_stat:Int
    var stat:PokemonStat
    
    init(from decoder:Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        base_stat = try results.decode(Int.self, forKey: .base_stat)
        stat = try results.decode(PokemonStat.self, forKey: .stat)
    }
}

struct PokemonStat:Codable {
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    var name:String
    
    init(from decoder:Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        name = try results.decode(String.self, forKey: .name)
    }
}
