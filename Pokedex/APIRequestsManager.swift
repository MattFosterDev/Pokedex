//
//  APIRequestsManager.swift
//  Pokedex
//
//  Created by Matt Foster on 21/08/2021.
//

import Foundation
import UIKit

enum requestType {
    case fullPokemonList, pokemonDetail
}

class APIRequestsManager {
    
    func requestPokemonList(offset:Int, completion:@escaping (PokedexModel?) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=20")!
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            self.printError(error: error)
            let pokedexModel = PokedexModel(data: data)
            DispatchQueue.main.async { completion(pokedexModel) }
        }
        task.resume()
    }
    
    func requestPokemonDetail(pokemonName:String, completion:@escaping (PokemonDetailModel?) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonName)/")!
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            self.printError(error: error)
            let pokemonDetail = PokemonDetailModel(data: data)
            DispatchQueue.main.async { completion(pokemonDetail) }
        }
        task.resume()
    }
    
    func requestImage(urlString:String, completion:@escaping (UIImage?) -> Void) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            self.printError(error: error)
            DispatchQueue.main.async { completion(UIImage(data: data!)) }
        }
        task.resume()
    }
    
    func printError(error:Error?) {
        guard error != nil else {
            return
        }
        print("Request error: \(error!.localizedDescription)")
        
    }
    
}
