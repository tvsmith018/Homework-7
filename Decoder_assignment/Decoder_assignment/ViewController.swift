//
//  ViewController.swift
//  Decoder_assignment
//
//  Created by Consultant on 5/3/22.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var decode_button: UIButton =  {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Decode the Dragons", for: .normal)
        button.setTitleColor(UIColor(red: 0.357, green: 0.055, blue: 0.176, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 0.655, blue: 0.506, alpha: 1)
        button.addTarget(self, action: #selector(self.decodeButtonPush), for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = UIColor(red: 0.357, green: 0.055, blue: 0.176, alpha: 1)
        setup_button()
    }
    
    func setup_button() {
        self.view.addSubview(self.decode_button)
        self.decode_button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.decode_button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.decode_button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -45).isActive = true
        self.decode_button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 45).isActive = true
    }
    
    @objc
    func decodeButtonPush() {
        guard let pokemon = grabPokemonData() else { return }
        presentAlert(pokemon: pokemon)
    }
    
    func grabPokemonData() -> Pokemon_Class? {
        guard let path = Bundle.main.path(forResource: "SampleJSONDragon", ofType: "json") else {
            print("Json file not found")
            return nil
        }
        
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            guard let baseDict = jsonObj as? [String: Any] else { return nil }
            return parsePokeData(baseDict: baseDict)
        }
        catch{
            print("Structure of Poke Data")
            return nil
            
        }
    }
    
    func parsePokeData(baseDict: [String: Any]) -> Pokemon_Class? {
        
        let empty_basic_dict_array: [basic_data] = [basic_data(name: "", url: "")]
        
        guard let damageRelationDict = baseDict["damage_relations"] as? [String: Any] else {
            print("The Damage Relation Dictionary does not exist")
            return nil
        }
        
        guard let damage_relation_arr = damageRelationDict["damage_relations"] as? [[String: Any]] else{
            return nil
        }
        guard basicDicData(dict: damage_relation_arr) != nil else {return nil}
        let damage_relation = basicDicData(dict: damage_relation_arr)
        
        guard let double_damage_to_arr = damageRelationDict["double_damage_to"] as? [[String: Any]] else{
            return nil
        }
        guard basicDicData(dict: double_damage_to_arr) != nil else {return nil}
        let double_damage_to = basicDicData(dict: double_damage_to_arr)
        
        guard let half_damage_from_arr = damageRelationDict["half_damage_from"] as? [[String: Any]] else{
            return nil
        }
        guard basicDicData(dict: half_damage_from_arr) != nil else {return nil}
        let half_damage_from = basicDicData(dict: half_damage_from_arr)
        
        guard let half_damage_to_arr = damageRelationDict["half_damage_to"] as? [[String: Any]] else{
            return nil
        }
        guard basicDicData(dict: half_damage_to_arr) != nil else {return nil}
        let half_damage_to = basicDicData(dict: half_damage_to_arr)
        
        guard let no_damage_from_arr = damageRelationDict["no_damage_from"] as? [[String: Any]] else{
            return nil
        }
        guard basicDicData(dict: no_damage_from_arr) != nil else {return nil}
        let no_damage_from = basicDicData(dict: no_damage_from_arr)
        
        guard let no_damage_to_arr = damageRelationDict["no_damage_to"] as? [[String: Any]] else{
            return nil
        }
        guard basicDicData(dict: no_damage_to_arr) != nil else {return nil}
        let no_damage_to = basicDicData(dict: no_damage_to_arr)
        
        guard let Damage_Relation_parsed = Damage_Relations(damage_relations: damage_relation ?? empty_basic_dict_array, double_damage_to: double_damage_to ?? empty_basic_dict_array, half_damage_from: half_damage_from ?? empty_basic_dict_array, half_damage_to: half_damage_to ?? empty_basic_dict_array, no_damage_from: no_damage_from ?? empty_basic_dict_array, no_damage_to: no_damage_to ?? empty_basic_dict_array) as? Damage_Relations else{
            return nil
        }
        
        guard let gameIndicesArr = baseDict["game_indices"] as? [[String: Any]] else {
            print("The Game Indices Dictionary does not exist")
            return nil
        }
        
        var Game_Indices_Arr_Parsed: [Game_Index] = []
        gameIndicesArr.forEach {
            
            guard let game_index = $0["game_index"] as? Int else { return }
            guard let generation_dic = $0["generation"] as? [String: Any] else { return }
            guard let generation = basicDicData(dict: generation_dic) else { return }
            
            Game_Indices_Arr_Parsed.append(Game_Index(game_index: game_index, generation: generation))
        }
        
        guard let Generation_Arr = baseDict["generation"] as? [String: Any] else {
            print("The Generation Dictionary does not exist")
            return nil
        }
        guard let Generation = self.basicDicData(dict: Generation_Arr) else { return nil }
        
        guard let id = baseDict["id"] as? Int else { return nil }
        
        guard let move_damage_class_Arr = baseDict["move_damage_class"] as? [String: Any] else {
            print("The move damage class Dictionary does not exist")
            return nil
        }
        guard let move_damage_class = self.basicDicData(dict: move_damage_class_Arr) else { return nil }

        
        guard let moves_arr = baseDict["moves"] as? [[String: Any]] else{
            return nil
        }
        guard basicDicData(dict: moves_arr) != nil else {return nil}
        let moves = basicDicData(dict: moves_arr)!
        
        guard let name = baseDict["name"] as? String else { return nil }
        
        guard let pokemon_dict = baseDict["pokemon"] as? [[String: Any]] else {
            print("The Game Indices Dictionary does not exist")
            return nil
        }
        
        var pokemon_array_parsed: [Pokemon] = []
        pokemon_dict.forEach {
            
            guard let slot = $0["slot"] as? Int else { return }
            guard let pokemon_data_dic = $0["pokemon"] as? [String: Any] else { return }
            guard let pokemon_data = basicDicData(dict: pokemon_data_dic) else { return }
            
            
            pokemon_array_parsed.append(Pokemon(pokemon: pokemon_data, slot: slot))
        }
        
        return Pokemon_Class(damage_relations: Damage_Relation_parsed, game_indices: Game_Indices_Arr_Parsed, generation: Generation, id: id, move_damage_class: move_damage_class, moves: moves, name: name, pokemon: pokemon_array_parsed)
        
    }
    
    func basicDicData(dict: [[String: Any]]) -> [basic_data]? {
        var array: [basic_data]? = []
       
        for i in 0..<dict.count {
            array?.append(basic_data(name:dict[i]["name"] as? String ?? "Do Not Exist", url:dict[i]["url"] as? String ?? "Do Not Exist"))
        }
        return array
    }
    
    func basicDicData(dict: [String: Any]) -> basic_data? {
        guard let name = dict["name"] as? String else { return nil }
        guard let url = dict["url"] as? String else { return nil }
        return basic_data(name: name, url: url)
    }
    
    func presentAlert(pokemon: Pokemon_Class) {
        var mess = ""
        for i in 0 ..< pokemon.pokemon.count{
            mess += pokemon.pokemon[i].pokemon.name + "\n"
        }
        let alert = UIAlertController(title: "Dragon", message: mess, preferredStyle: .alert)
        let action = UIAlertAction(title: "Kool", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

