import UIKit

class CityDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var city: TRCity?
    var districts: [District] = []
    var filteredDistricts: [District] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let city = city {
            print("City geldi: \(city.name) - ID: \(city.id)")
        } else {
            print("City nil!")
        }

        title = city?.name
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self // Delegate atandı

        fetchCityDetails()
    }

    func fetchCityDetails() {
        guard let cityId = city?.id else {
            print("City ID alınamadı.")
            return
        }

        print("Fetching details for city ID: \(cityId)")

        APIService.shared.fetchCityDetail(cityId: cityId) { [weak self] detail in
            DispatchQueue.main.async {
                // Tüm bilgileri infoLabel'a yazdıralım
                self?.infoLabel.numberOfLines = 0 // Birden fazla satır görünmesini sağla
                self?.infoLabel.text = """
                Nüfus: \(detail.population)
                Yüzölçümü: \(detail.area) km²
                Plaka Kodu: \(detail.id)
                Rakım: \(detail.altitude) m
                Bölge: \(detail.region.tr)
                """
                self?.infoLabel.sizeToFit() // Boyutunu otomatik olarak ayarla

                self?.districts = detail.districts
                self?.filteredDistricts = detail.districts // Başta hepsini göster
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDistricts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistrictCell", for: indexPath)
        cell.textLabel?.text = filteredDistricts[indexPath.row].name
        return cell
    }

    // MARK: - SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredDistricts = districts
        } else {
            filteredDistricts = districts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDistrict = filteredDistricts[indexPath.row]
        showDistrictDetails(district: selectedDistrict)
    }

    // MARK: - Show Pop-up for District Details
    func showDistrictDetails(district: District) {
        let alertController = UIAlertController(title: district.name, message: """
            Nüfus: \(district.population)
            Yüzölçümü: \(district.area) km²
        """, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
