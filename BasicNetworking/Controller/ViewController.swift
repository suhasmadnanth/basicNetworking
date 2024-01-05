//
//  ViewController.swift
//  BasicNetworking
//
//  Created by Suhas M on 02/01/24.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var homeTableView: UITableView!
    
    //MARK: - Properties
    var products: [Product] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.homeTableView.reloadData()
            }
        }
    }
    
    let networkManager = NetworkManager()
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        fetchData()
    }
    
    //MARK: - Private Methods
    private func fetchData() {
        networkManager.fetchData(for: Constants.endPoint) { [weak self] result in
            switch result {
            case .success(let data):
                self?.products = data.products
            case .failure( let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let brand = products[indexPath.row].brand
        cell.textLabel?.text = brand
        return cell
    }
}
