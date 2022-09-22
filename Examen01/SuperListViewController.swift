//
//  SuperListViewController.swift
//  Examen01
//
//  Created by Universidad Anahuac on 21/09/22.
//

import UIKit

struct SuperheroList: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Superhero]
}

struct Superhero: Decodable {
    var name: String
    var url: String
}

class GoToSuperhero{
    var title: String
    var segueId: String
    
    init(title: String, segueId: String){
        self.title = title
        self.segueId = segueId
    }
}

class SuperListViewController: UIViewController {

    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var pokemonTableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var superTableView: UITableView!
    
    var supers: [Superhero] = []
    var currentSuper: Superhero? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        superTableView.register(UINib(nibName: "SuperTableViewCell", bundle: nil), forCellReuseIdentifier: "pokemonCell")
        superTableView.dataSource = self
        loadingView.hidesWhenStopped = true
        loadingView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.loadSupers()
        }
        superTableView.delegate = self

    }
    
    func loadSupers(){
        let urlBase = "https://pokeapi.co/api/v2/"
        let listPokemonEndPoint = URL.init(string: "\(urlBase)pokemon?limit=100000&offset=0")!
        let task = URLSession.shared.dataTask(with: listPokemonEndPoint){data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let result = try! jsonDecoder.decode(SuperheroList.self, from: data)
                self.supers = result.results
                DispatchQueue.main.sync {
                    self.loadingView.stopAnimating()
                    self.superTableView.reloadData()
                }
                
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "especificPokemonSegue" {
            let detailedPokemonViewController = segue.destination as? DetailedPokemonViewController
            detailedPokemonViewController?.pokemons = currentPokemon
        }
    }

}

extension SuperListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = superTableView.dequeueReusableCell(withIdentifier: "pokemonCell") as? PokemonTableViewCell
        if(cell == nil){
            cell = PokemonTableViewCell()
        }
        let item = pokemons[indexPath.row]
        //cell?.textLabel?.text = item.name
        cell?.setupView(pokemon: item)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPokemon = pokemons[indexPath.row]
        performSegue(withIdentifier: "especificPokemonSegue", sender: nil)
    }

}
