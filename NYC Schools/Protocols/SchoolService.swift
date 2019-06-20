/**************************************
 SchoolService Protocol
 
 - defines basic functionality for consumers of service
 - getSchools:completion loads initial School call
 - loadDetailsIfNeeded:completion downloads Scores for schools if needed, perhaps more
 - getScores:completion loads scores for a school, should probably also map it to the existing schools
                        currenly needs getSchools to be called first. May reroute in the future.
 **************************************/

import Foundation

typealias SchoolCompletion = ([School]?) -> ()

/// basic protocol for easy injections for testing
protocol SchoolService {
    var queue: DispatchQueue { get set }
    
    func getSchools(_ completion: @escaping SchoolCompletion)
    func loadDetailsIfNeeded(_ completion: @escaping (Bool)->())
    func getScores(_ completion: @escaping SchoolCompletion)
}
