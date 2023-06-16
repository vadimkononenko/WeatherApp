//
//  SearchVC.swift
//  WeatherApp
//
//  Created by Vadim Kononenko on 16.06.2023.
//

import UIKit
import MapKit
import SnapKit

class SearchVC: UIViewController {
    
    //MARK: - Views
    
    private lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Type location..."
        searchbar.delegate = self
        return searchbar
    }()
    
    private lazy var resultTableView: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    
    //MARK: - MKLocalSearchCompleter
    
    private lazy var searchCompleter: MKLocalSearchCompleter = {
        let sc = MKLocalSearchCompleter()
        sc.delegate = self
        return sc
    }()
    
    /// Field for found locations
    var searchSource = [String]()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    //MARK: - Helpers
    
    /// Method for searching chosen location
    func searchForCoordinates(of place: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = place
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                return
            }
            
            // Отримані координати місця
            print("Coordinates: \(coordinate.latitude), \(coordinate.longitude)")
        }
    }
    
    //MARK: - Layouting
    
    private func configure() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(searchBar)
        view.addSubview(resultTableView)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

}

//MARK: - UISearchBarDelegate

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchText
        }
    }
}

//MARK: - MKLocalSearchCompleterDelegate

extension SearchVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchSource = completer.results.map { $0.title }
        
        DispatchQueue.main.async {
            self.resultTableView.reloadData()
        }
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = searchSource[indexPath.row]
        searchForCoordinates(of: selectedPlace)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let source = searchSource[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = source
        return cell
    }
}
