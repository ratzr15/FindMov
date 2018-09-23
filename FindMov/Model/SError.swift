//----------------------------------------------------------------------------------
//  File Name         :  SErrorCodes
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
struct SError : Codable {
	let status_code : Int?
	let status_message : String?
	let success : Bool?

	enum CodingKeys: String, CodingKey {

		case status_code = "status_code"
		case status_message = "status_message"
		case success = "success"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
		status_message = try values.decodeIfPresent(String.self, forKey: .status_message)
		success = try values.decodeIfPresent(Bool.self, forKey: .success)
	}

}
