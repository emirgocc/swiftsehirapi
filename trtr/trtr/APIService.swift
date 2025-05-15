import Foundation

class APIService {
    static let shared = APIService()

    private init() {}

    // Şehirleri alıyoruz
    func fetchCities(completion: @escaping ([TRCity]) -> Void) {
        guard let url = URL(string: "https://turkiyeapi.dev/api/v1/provinces") else {
            print("URL geçersiz")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Veri yok")
                return
            }

            do {
                // CityResponse modelini kullanarak JSON'u decode ediyoruz
                let response = try JSONDecoder().decode(CityResponse.self, from: data)
                completion(response.data)
            } catch {
                print("JSON parse hatası: \(error)")
            }
        }

        task.resume()
    }

    // Şehir detaylarını alıyoruz
    func fetchCityDetail(cityId: Int, completion: @escaping (CityDetail) -> Void) {
        guard let url = URL(string: "https://turkiyeapi.dev/api/v1/provinces/\(cityId)") else {
            print("URL geçersiz")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Veri yok")
                return
            }

            do {
                // Gelen JSON'u string olarak bas (hata ayıklamak için)
                let jsonString = String(data: data, encoding: .utf8)
                print("Gelen JSON:\n\(jsonString ?? "Boş veri")")

                // CityDetailResponse üzerinden doğru şekilde decode ediyoruz
                let response = try JSONDecoder().decode(CityDetailResponse.self, from: data)
                completion(response.data)
            } catch {
                print("JSON parse hatası: \(error)")
            }
        }

        task.resume()
    }


}


// MARK: - Response Structs

struct CityListResponse: Codable {
    let data: [TRCity]
}

struct CityDetailResponse: Codable {
    let data: CityDetail
}

