//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Matt Foster on 21/08/2021.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonNo: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var typesStackView: UIStackView!
    
    @IBOutlet weak var defConstraint: NSLayoutConstraint!
    @IBOutlet weak var attackConstraint: NSLayoutConstraint!
    @IBOutlet weak var hpConstraint: NSLayoutConstraint!
    @IBOutlet weak var spDefConstraint: NSLayoutConstraint!
    @IBOutlet weak var spAtConstaint: NSLayoutConstraint!
    @IBOutlet weak var speedConstraint: NSLayoutConstraint!
    
    var pokemon:Pokemon? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard pokemon != nil else {
            return
        }
        requestDetails()
    }
    
    func requestDetails() {
        APIRequestsManager().requestPokemonDetail(pokemonName: pokemon!.name) { detailModel in
            guard detailModel != nil else {
                return
            }
            self.setDetailViews(detailModel: detailModel!)
        }
    }
    
    func setDetailViews(detailModel:PokemonDetailModel) {
        guard detailModel.pokemonDetails != nil else {
            return
        }
        
        self.pokemonNo.text = PokemonIDFormatter().formatPokemonID(idNo: detailModel.pokemonDetails!.id)
        self.loadImage(imageURL: detailModel.pokemonDetails!.sprites.front_default)
        self.weight.text = "weight:  \(detailModel.pokemonDetails!.weight/10)kg"
        self.height.text = "height:  \(detailModel.pokemonDetails!.height*10)cm"
        for type in detailModel.pokemonDetails!.types {
            self.addTypeLabel(type: type.type.name)
        }
        addWhiteSpaceToTypesView()
        self.setStats(stats: detailModel.pokemonDetails!.stats)
        self.pokemonName.text = self.pokemon?.name.capitalized
    }
    
    func loadImage(imageURL:String){
        APIRequestsManager().requestImage(urlString: imageURL) { image in
            self.mainImage.image = image
        }
    }
    
    func addTypeLabel(type:PokemonTypeEnum) {
        let newType = UITextView()
        newType.isUserInteractionEnabled = false
        newType.text = type.rawValue
        newType.textAlignment = NSTextAlignment.center
        newType.backgroundColor = getPokemonTypeColour(type: type)
        newType.layer.cornerRadius = 5.0
        newType.layer.masksToBounds = true
        newType.font = UIFont(name: "PKMN-RBYGSC", size: 10)
        newType.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        newType.widthAnchor.constraint(equalToConstant: 100).isActive = true
        typesStackView.spacing = 5
        typesStackView.addArrangedSubview(newType)
    }
    
    func addWhiteSpaceToTypesView() {
        let whiteSpace = UIView()
        typesStackView.addArrangedSubview(whiteSpace)
    }
    
    func getPokemonTypeColour(type:PokemonTypeEnum) -> UIColor {
        switch type {
        case .normal:
            return UIColor(red: 0.66, green: 0.66, blue: 0.47, alpha: 1.00)
        case .fighting:
            return UIColor(red: 0.75, green: 0.19, blue: 0.16, alpha: 1.00)
        case .flying:
            return UIColor(red: 0.66, green: 0.56, blue: 0.94, alpha: 1.00)
        case .poison:
            return UIColor(red: 0.63, green: 0.25, blue: 0.63, alpha: 1.00)
        case .ground:
            return UIColor(red: 0.88, green: 0.75, blue: 0.41, alpha: 1.00)
        case .rock:
            return UIColor(red: 0.72, green: 0.63, blue: 0.22, alpha: 1.00)
        case .bug:
            return UIColor(red: 0.66, green: 0.72, blue: 0.13, alpha: 1.00)
        case .ghost:
            return UIColor(red: 0.44, green: 0.35, blue: 0.60, alpha: 1.00)
        case .steel:
            return UIColor(red: 0.72, green: 0.72, blue: 0.82, alpha: 1.00)
        case .fire:
            return UIColor(red: 0.94, green: 0.50, blue: 0.19, alpha: 1.00)
        case .water:
            return UIColor(red: 0.41, green: 0.56, blue: 0.94, alpha: 1.00)
        case .grass:
            return UIColor(red: 0.47, green: 0.78, blue: 0.31, alpha: 1.00)
        case .electric:
            return UIColor(red: 0.97, green: 0.82, blue: 0.19, alpha: 1.00)
        case .psychic:
            return UIColor(red: 0.97, green: 0.35, blue: 0.53, alpha: 1.00)
        case .ice:
            return UIColor(red: 0.60, green: 0.85, blue: 0.85, alpha: 1.00)
        case .dragon:
            return UIColor(red: 0.44, green: 0.22, blue: 0.97, alpha: 1.00)
        case .dark:
            return UIColor(red: 0.44, green: 0.35, blue: 0.28, alpha: 1.00)
        case .fairy:
            return UIColor(red: 0.93, green: 0.60, blue: 0.67, alpha: 1.00)
        case .unknown:
            return UIColor(red: 0.41, green: 0.63, blue: 0.56, alpha: 1.00)
        case .shadow:
            return UIColor(red: 0.44, green: 0.35, blue: 0.28, alpha: 1.00)
        }
    }
    
    func setStats(stats:[PokemonStats]) {
        guard stats.count > 4 else {
            return
        }
        self.view.layoutIfNeeded()
        hpConstraint.constant = CGFloat(255 - stats[0].base_stat)
        attackConstraint.constant = CGFloat(255 - stats[1].base_stat)
        defConstraint.constant = CGFloat(255 - stats[2].base_stat)
        spAtConstaint.constant = CGFloat(255 - stats[3].base_stat)
        spDefConstraint.constant = CGFloat(255 - stats[4].base_stat)
        speedConstraint.constant = CGFloat(255 - stats[5].base_stat)
        UIView.animate(withDuration: 1.5) { [weak self] in
          self?.view.layoutIfNeeded()
        }
        
    }
}
