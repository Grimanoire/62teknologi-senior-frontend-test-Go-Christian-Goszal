//
//  APICaller.swift
//  BusinessReviewProject
//
//  Created by Go Christian Goszal on 27/04/23.
//

import Foundation

struct Constants {
    static let API_KEY = "Bearer spP1bp8MPO-y-hpxQOeNmiEkBCg0gu_vD-bnA9AUKwBUpooQMq2RaH-vrNPkPOwww2VmBzPXYnUpAoJGbIzD0XF9Q7KECpIi9LXZWHrGHWDSeq6m3drqKXyCyWZLZHYx"
    static let baseURL = "https://api.yelp.com/v3/businesses"

}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
//  FOR SEARCH BUSINESS LIST (DEFAULT)
    func getBusinessList(page index: Int = 0, completion: @escaping (Result<[BusinessList], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/search?location=NYC&sort_by=best_match&limit=20&offset=\(20*index)") else {return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue(Constants.API_KEY, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let business = try JSONDecoder().decode(GetBusinessList.self, from: data)
                completion(.success(business.businesses))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
    
    
//  FOR SEARCH BUSINESS LIST (RESULT)
    func getBusinessList(with term: String, page index: Int = 0, completion: @escaping (Result<[BusinessList], Error>) -> Void) {
        
        guard let term = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)/search?location=NYC&term=\(term)&sort_by=best_match&limit=20&offset=\(20*index)") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue(Constants.API_KEY, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let businesses = try JSONDecoder().decode(GetBusinessList.self, from: data)
                completion(.success(businesses.businesses))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
    
    
//  FOR BUSINESS DETAIL
    func getBusinessDetail(with id: String, completion: @escaping (Result<GetBusinessDetail, Error>) -> Void) {
        
        guard let id = id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.baseURL)/\(id)") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue(Constants.API_KEY, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let detail = try JSONDecoder().decode(GetBusinessDetail.self, from: data)
                completion(.success(detail))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
    
    
//  FOR BUSINESS DETAIL REVIEW
    func getBusinessDetailReview(with id: String, completion: @escaping (Result<[BusinessDetailReview], Error>) -> Void) {
        
        guard let id = id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.baseURL)/\(id)/reviews?limit=20&sort_by=yelp_sort") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue(Constants.API_KEY, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let reviews = try JSONDecoder().decode(GetBusinessDetailReview.self, from: data)
                completion(.success(reviews.reviews))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
}
