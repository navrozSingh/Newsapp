/*
Credits http://www.json4swift.com
*/


import Foundation

struct SourcesModal : Codable {
	let status : String?
	let sources : [Sources]?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case sources = "sources"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		sources = try values.decodeIfPresent([Sources].self, forKey: .sources)
	}

}

struct Sources : Codable,Identifiable, Equatable, Hashable {
    let id  = UUID()
    var stringID  = ""
    let name : String?
    let description : String?
    let url : String?
    let category : String?
    let language : String?
    let country : String?
    
    static func == (rhs: Sources ,lhs : Sources) -> Bool {
        lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {

        case stringID = "id"
        case name = "name"
        case description = "description"
        case url = "url"
        case category = "category"
        case language = "language"
        case country = "country"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stringID = try (values.decodeIfPresent(String.self, forKey: .stringID) ?? "NA")
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }

}
