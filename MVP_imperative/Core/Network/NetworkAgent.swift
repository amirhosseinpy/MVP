//
//  NetworkAgent.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 14/11/2021.
//
import Foundation


class NetworkAgent: NSObject {
  
  private var decoder: JSONDecoder!
  private var encoder: JSONEncoder!
  private var session: URLSession!
  
  private let cacher: CacheAgent?
  
  init(session: URLSession = URLSession.shared, cacher: CacheAgent? = nil) {
    self.cacher = cacher 
    self.session = session
    
    super.init()
    setupDecoder()
    setupEncoder()
  }
  
  private func setupDecoder() {
    let decoder =  JSONDecoder()
    decoder.dataDecodingStrategy = .base64
    decoder.dateDecodingStrategy = .millisecondsSince1970
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(
      positiveInfinity: "Infinity",
      negativeInfinity: "-Infinity",
      nan: "NaN")
    
    self.decoder = decoder
  }
  
  private func setupEncoder() {
    let encoder = JSONEncoder()
    encoder.dataEncodingStrategy = .base64
    self.encoder = encoder
  }
  
  func request<R: APIRouter>(_ router: R,
                             isRefresh: Bool = false,
                             completion: @escaping (Result<R.ResponseType, Error>) -> Void) {
    
    do {
      
      let body = try encoder.encode(router.request)
      
      guard let baseURL = R.baseURL else { return }
      
      var request = URLRequest(url: baseURL)
      
      request.httpMethod = R.method.rawValue
      
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      
      let token = "YOUR_TOKEN" 
      request.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
      
      
      request.httpBody = body
      
      if !isRefresh, let model: R.ResponseType = cacher?.fetch(forKey: body) {
        completion(.success(model))
        
      } else {
        run(request, completion: completion)
      }
      
    } catch {
      completion(.failure(error))
    }
  }
  
  private func run<C: Codable>(_ request: URLRequest, completion: @escaping (Result<C, Error>) -> Void) {
    let task = session.dataTask(with: request) { (data, response, error) in
      do {
        
        if let error = error { throw error }
        
        try self.validate(response: response, data: data)
        
        let dataValue = data ?? Data()
        
        let model: C = try self.decodeModel(data: dataValue)
        
        if let key = request.httpBody {
          self.cacher?.store(data: model, forKey: key)
        }
        
        completion(.success(model))
        
      } catch {
        completion(.failure(error))
      }
    }
    
    task.resume()
  }
  
  private func validate(response: URLResponse?, data: Data?) throws {
    guard let response = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
    
    switch response.statusCode {
      case 500:
        throw NetworkError.network
      case 401:
        throw NetworkError.authorization
      case 400:
        throw NetworkError.badRequest()
      default:
        break
    }
    
    guard data != nil else { throw NetworkError.invalidResponse }
  }
  
  private func decodeModel<D: Decodable>(data: Data) throws -> D {
    do {
      let result: GraphQLResult<D> = try self.decoder.decode(GraphQLResult<D>.self, from: data)
      
      if let model =  result.value {
        return model
      }
      
      throw NetworkError.badRequest(message: result.errorMessages.joined(separator: "\n"))
      
    } catch {
      throw NetworkError.parsing
    }
  }
}
