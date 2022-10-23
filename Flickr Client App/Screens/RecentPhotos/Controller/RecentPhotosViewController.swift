//
//  RecentPhotosViewController.swift
//  Flickr Client App
//
//  Created by Oğuzhan Erdem on 19.10.2022.
//

import UIKit

class RecentPhotosViewController: UITableViewController, UISearchResultsUpdating {
    // Dönen responsu tutması için bir optional değer oluşturalım.
    private var response: PhotosResponse?{
        // responsa atama olduğunda tableviewı update etmemiz gerekiyor burada tableviewe update oldugunda didset metoduyla updatei sağlıyoruz
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var  selectedPhoto: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        fetchRecectPhotos()
    }
    
    
    private func setupSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Arama için lütfen bir şeyler giriniz..."
        navigationItem.searchController = search
        
    }
    
    private func fetchRecectPhotos() {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=7d32d6168c8492260f03aa209e5a3a4d&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z") else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request ) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data{
                do {
                    let response = try? JSONDecoder().decode(PhotosResponse.self, from: data)
                    self.response = response
                }catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    private func searchPhotos(with text: String) {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=7d32d6168c8492260f03aa209e5a3a4d&text=\(text)&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z") else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request ) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data {
                do {
                    let response = try? JSONDecoder().decode(PhotosResponse.self, from: data)
                    self.response = response
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.photos?.photo?.count ?? .zero
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = response?.photos?.photo?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        
        cell.ownerNameLabel.text = photo?.ownername
        cell.titleLabel.text = photo?.title
        
        NetworkManager.shared.fetchImage(with: photo?.buddyIconURL ) { data in
            cell.ownerImageView.image = UIImage(data: data)
        }
        NetworkManager.shared.fetchImage(with: photo?.urlZ) { data in
            cell.photoImageView.image = UIImage(data: data)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPhoto = response?.photos?.photo?[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? PhotoDetailViewController {
            // TODO : Seçilen fotoğrafı detay ekranına gönder
            viewController.photo = selectedPhoto
        }
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            searchPhotos(with: text)
            
            
        }
        
    }
}


