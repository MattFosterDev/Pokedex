//
//  PokedexVC.swift
//  Pokedex
//
//  Created by Matt Foster on 21/08/2021.
//

import UIKit

class PokedexVC: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var pokemonGrid: UITableView!
    var pokedexModel:PokedexModel?
    var gridCellReuseID = "pokemonCell"
    var currentPagination = 0
    var paginationSize = 20
    var pageLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGrid()
        requestPage()
    }
    
    func setupGrid() {
        self.pokemonGrid.delegate = self
        self.pokemonGrid.dataSource = self
    }
    
    func loadNextPage(){
        currentPagination += 1
        requestPage()
    }
    
    func requestPage(){
        guard pageLoading == false else {
            return
        }
        pageLoading = true
        APIRequestsManager().requestPokemonList(offset:currentPagination*paginationSize, completion: { pokedex in
            self.updatePokedex(newPokedex: pokedex)
            self.dataFinishedLoading()
        })
    }
    
    func updatePokedex(newPokedex:PokedexModel?) {
        guard newPokedex != nil else {
            print("New results array is empty")
            return
        }
        if self.pokedexModel != nil {
            self.pokedexModel?.pokemon = self.pokedexModel!.pokemon + newPokedex!.pokemon
        } else {
            self.pokedexModel = newPokedex
        }
    }

    func dataFinishedLoading(){
        self.pokemonGrid.reloadData()
        pageLoading = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        gotoPokemonDetailVC(pokemonIndex: indexPath.row)
    }
    
    func gotoPokemonDetailVC(pokemonIndex:Int) {
        guard pokedexModel != nil else {
            print("Data Model is nil can't load Detail VC")
            return
        }
        guard pokedexModel!.pokemon.count > pokemonIndex else {
            print("Out of bounds request for Detail View")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "PokemonDetailVC") as! PokemonDetailVC
        detailVC.pokemon = pokedexModel?.pokemon[pokemonIndex]
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

extension PokedexVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard pokedexModel != nil else {
            return 0
        }
        return pokedexModel!.pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > (currentPagination * paginationSize) + (paginationSize - 5) {
            loadNextPage()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: gridCellReuseID, for: indexPath) as! PokemonCell
        if pokedexModel != nil {
            cell.name.text = pokedexModel?.pokemon[indexPath.row].name.capitalized
            cell.pokemonNo.text = PokemonIDFormatter().formatPokemonID(idNo: indexPath.row+1)
        }
        
        return cell
    }
}

class PokemonCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pokemonNo: UILabel!
}
