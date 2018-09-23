//----------------------------------------------------------------------------------
//  File Name         :  Meta.swift
//  Description       :  Model for Model for API req
//                    :  Caller : SearchManager
//                       Manages: requests and response from Search Query
//  Architecture      :  Uncle Bob's Clean Architecture {MVVM}
//  Author            :  Rathish Kannan
//  E-mail            :  rathish.k@sunandsandsports.com
//  Dated             :  21 Sep 2018
//  File Copyrights   :  http://www.json4swift.com
//  Credits           :  https://www.linkedin.com/in/syedabsar
//  Copyright (c) 2018 Rathish Kannan. All rights reserved.
//-----------------------------------------------------------------------------------

import Foundation
struct Meta : Codable {
	let page : Int?
	let total_results : Int?
	let total_pages : Int?
	let results : [Results]?

	enum CodingKeys: String, CodingKey {

		case page = "page"
		case total_results = "total_results"
		case total_pages = "total_pages"
		case results = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		total_results = try values.decodeIfPresent(Int.self, forKey: .total_results)
		total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
		results = try values.decodeIfPresent([Results].self, forKey: .results)
	}

}
