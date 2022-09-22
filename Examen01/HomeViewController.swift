//
//  HomeViewController.swift
//  Examen01
//
//  Created by Universidad Anahuac on 21/09/22.
//

import UIKit

class Opciones{
    var title: String
    var segueId: String
    
    init(title: String, segueId: String) {
        self.title = title
        self.segueId = segueId
    }
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let data: [Opciones] = [
        Opciones(title: "Superheroes", segueId: "superSegue")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}
    
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if(cell == nil){
            cell = UITableViewCell()
        }
        let item = data[indexPath.row]
        cell?.textLabel?.text = item.title
        return cell!
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        performSegue(withIdentifier: item.segueId, sender: nil)
    }

}

