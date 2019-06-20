// Reference:
/*
     High School data here: https://data.cityofnewyork.us/Education/DOE-High-School-Directory-2017/s3k6-pzi2
     SAT data here: https://data.cityofnewyork.us/Education/SAT-Results/f9bf-2cp4
*/

import Foundation

struct APIs {
    private init() { }

    static let root = "https://data.cityofnewyork.us"
    static let highSchools = APIs.root + "/resource/s3k6-pzi2.json"
    static let sats = APIs.root + "/resource/f9bf-2cp4.json"
}

extension String {
    var url: URL? {
        return URL(string: self)
    }
}
