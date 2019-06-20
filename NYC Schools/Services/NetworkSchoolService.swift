/**************************************
 Test/Proxy School Service
 
 - loads schools from remote source
 - uses generic Decodable-supported NetworkService
 **************************************/

import Foundation

final class NetworkSchoolService: SchoolService {
    
    private let networkService = NetworkService()
    private var schools = [School]()
    private var detailsLoaded = false
    var queue: DispatchQueue
    
    init(_ queue: DispatchQueue = DispatchQueue.main) {
        self.queue = queue
    }
}

extension NetworkSchoolService {
    
    /// Fetch Schools Information
    func getSchools(_ completion: @escaping SchoolCompletion) {
        let comp: SchoolCompletion = { [weak self] (schools) in
            guard let strongSelf = self else { return }
            strongSelf.queue.async {
                completion(schools)
            }
        }
        networkService.makeRequest(url: APIs.highSchools.url,
                            type: [School].self,
                            params: nil)
        { [weak self] (schools) in
            guard let sch = schools,
                let strongSelf = self else {
                return
            }
            strongSelf.schools = sch
            comp(strongSelf.schools)
        }
    }
    
    /// Fetch Schools Details Information
    func loadDetailsIfNeeded(_ completion: @escaping (Bool)->()) {
        let comp: (Bool)->() = { [weak self] (bool) in
            guard let strongSelf = self else { return }
            strongSelf.queue.async {
                completion(bool)
            }
        }
        if detailsLoaded == false {
            getScores { (schools) in
                guard let schools = schools else {
                    comp(false)
                    return
                }
                comp(!schools.isEmpty)
            }
        }
        else {
            comp(true)
        }
    }
    
    /// Fetch Scores Information
    /// Also, map scores information to the corresponding schools
    func getScores(_ completion: @escaping SchoolCompletion) {
        guard schools.isEmpty == false else {
            completion(nil)
            return
        }
        let comp: SchoolCompletion = { [weak self] (schools) in
            guard let strongSelf = self else { return }
            strongSelf.queue.async {
                completion(schools)
            }
        }
        networkService.makeRequest(url: APIs.sats.url,
                                   type: [SatScores].self,
                                   params: nil)
        { [weak self] (sats) in
            guard let scores = sats,
                let strongSelf = self else {
                    return
            }
            strongSelf.schools.join(with: scores)
            comp(strongSelf.schools)
        }
    }
}
