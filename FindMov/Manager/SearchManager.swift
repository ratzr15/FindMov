//----------------------------------------------------------------------------------
//  File Name         :  SearchManager.swift
//  Description       :  API Manager for Movie Search
//                       1. Manages requests and response from themoviedb
//  Architecture      :  Uncle Bob's Clean Architecture {MVVM}
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  21st Sep 2018
//  Copyright (c) 2018 Rathish Kannan. All rights reserved.
//-----------------------------------------------------------------------------------

import Foundation

/// RequestParams
struct SearchQuery: Equatable{
    // MARK: Search
    var query: String
    var page: String
    var id: String
    var count: String
}

func ==(lhs: SearchQuery, rhs: SearchQuery) -> Bool{
    return lhs.query == rhs.query
        && lhs.page == rhs.page
        && lhs.id == rhs.id
        && lhs.count == rhs.count
}

//API Response Type Enum
enum SResults<T>{
    case Success(result: T)
    case Failure(error: SErrorType)
}

// MARK: - SError
enum SErrorCodes: String{
    case OK
    case ERROR
    case UNAUTHORISED
}

// MARK: - SError
enum SErrorType: Equatable, Error{
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}

// MARK: SResultsProtocol
protocol SResultsProtocol{
    func fetchRecomendations(params: SearchQuery?,completionHandler: @escaping SResultsCompletionHandler)
}

// MARK: completionHandler
typealias SResultsCompletionHandler = (SResults<Meta?>) -> Void

class SearchManager {
    
    let kApiKey = "e46538d8b9bd8e858da9e894eda67212"
    let kMaxRecentItems = 10

    /// Search API Req: https://api.themoviedb.org/3/search/movie?api_key=e46538d8b9bd8e858da9e894eda67212&language=en-US&query=avatarasdqasa&page=2&include_adult=false
    ///
    /// - Parameters:
    ///   - params:{ query }
    ///   - completionHandler: SResults<[Meta]>
    func fetchMovies(params: SearchQuery?,completionHandler: @escaping SResultsCompletionHandler){
        guard let param = params else {
            assertionFailure("SearchQuery Missing")
            return
        }
        let url = setURL(model: param)
        print("Requesting 🚀 \(url)")
        
        SearchManager.getDataRequest(url: url, token: nil, contentType: nil, auth: false) { (data, err) in
            guard let response = data else {
                completionHandler(SResults.Failure(error: SErrorType.CannotFetch("An Error Occured")))
                return
            }
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(Meta.self, from: response)
                if decoded.results?.count ?? 1 < 1{
                    let errored = try decoder.decode(SError.self, from: response)
                    do{
                        completionHandler(SResults.Failure(error: SErrorType.CannotFetch(errored.status_message ?? "")))
                    }
                }else{
                    completionHandler(SResults.Success(result: decoded))
                }
            }catch _ {
                completionHandler(SResults.Failure(error: SErrorType.CannotFetch("An Error Occured")))
            }
        }
    }
    
    /// getDataRequest - Decodable Result
    ///
    /// - Parameters:
    ///   - url: API url
    ///   - parameters: Body - Pararms
    ///   - token: token - Default : None
    ///   - auth: if token not required send §false§
    ///   - completionHandler: Data/Err
    class func getDataRequest(url:String,token:String?,contentType:String?, auth:Bool,completionHandler:@escaping (Data?, Error?) -> ()) -> (){
        let ephemeralConfiguration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: ephemeralConfiguration)
        guard let urlStr = URL(string: url.replacingOccurrences(of: " ", with: "")) else {
           /*assertionFailure("Malformed URL")*/
            completionHandler( nil, nil)
            return
        }
        var request = URLRequest(url: urlStr)
        request.httpMethod = "GET"
        if let content = contentType {
            request.addValue(content.isEmpty ? "application/json":content, forHTTPHeaderField: "Content-Type")
        }else{
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else{
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            do {
                completionHandler(data, error)
            }
        })
        task.resume()
    }

    
    func searchMovies(query :String, page:String, completion: @escaping (Meta?) -> Void){
        let param = SearchQuery(query: query, page: page, id: "", count: "")
        self.fetchMovies(params: param) { (result: SResults<Meta?>) -> Void in
            switch (result) {
            case .Success(let movies):
                completion(movies )
                print("Success  ✅ \n Total \(movies?.results?.count ?? 1) \n PageTotal \(movies?.total_pages ?? 1)")
            case .Failure(_):
                completion(nil)
                print("Failure  ❌\(SErrorType.CannotFetch("Error"))")
            }
        }
    }
    
    func setURL(model : SearchQuery) -> String {
        let baseurl  = "https://api.themoviedb.org/3/search/movie?"
        let key      = "api_key=\(kApiKey)&"
        let lang     = "language=en-US&"
        let age      = "include_adult=false&"
        
        //It's a Dynamic World
        let page       = "page=\(model.page)&"
        let query      = "query=\(model.query)"

        let url = baseurl + key + lang + age + page + query
        
        return url
    }
}

//MARK: - Recent searches
extension SearchManager {
    enum UserDefaultsKeys:StringLiteralType {
        case recentSearch
    }
    
    func saveRecentSearches (array : Array<Any>) {
        let defaults = UserDefaults.standard
        defaults.set(array, forKey: UserDefaultsKeys.recentSearch.rawValue)
    }
    
    func retriveRecentSearch() -> Array<Any> {
        let defaults = UserDefaults.standard
        let myarray = defaults.stringArray(forKey: UserDefaultsKeys.recentSearch.rawValue) ?? [String]()
        return myarray
    }
    
    func clearOlderRecentSearchItem(){
        var array = self.retriveRecentSearch() as! [String]
        if array.count == kMaxRecentItems {
            array.remove(at: kMaxRecentItems - 1)
            self.saveRecentSearches(array: array)
        }
    }
    
    func saveRecentSearch(searchString : String) {
        clearOlderRecentSearchItem()
        var array = self.retriveRecentSearch() as! [String]
        if !(array.contains(searchString)) && !searchString.isEmpty {
            if array.count == 0 {
                array.append(searchString)
            }
            else{
                array.insert(searchString, at: 0)
            }
            self.saveRecentSearches(array: array)
        }
    }
}
