/**************************************
 Test/Proxy School Service
 
 - loads schools from files included:
    * schools.json
    * scores.json
 **************************************/

import Foundation

private enum ProxyResources {
    case schools, scores
}

extension ProxyResources {
    var path: URL {
        switch (self) {
        case .schools:
            guard let path = Bundle.main.path(forResource: "schools",
                                              ofType: "json") else {
                                                fatalError("schools.json is missing")
            }
            return URL(fileURLWithPath: path)
        case .scores:
            guard let path = Bundle.main.path(forResource: "scores",
                                              ofType: "json") else {
                                                fatalError("scores is missing")
            }
            return URL(fileURLWithPath: path)
        }
    }
}

final class ProxySchoolService: SchoolService {
    
    private var schools = [School]()
    private var detailsLoaded = false
    var queue: DispatchQueue
    
    init(_ queue: DispatchQueue = .global(qos: .background)) {
        self.queue = queue
    }
}

extension ProxySchoolService {
    
    func getSchools(_ completion: @escaping SchoolCompletion) {
        let comp: SchoolCompletion = { [weak self] (schools) in
            guard let strongSelf = self else { return }
            strongSelf.queue.async {
                completion(schools)
            }
        }
        queue.async { [weak self] in
            guard let strongSelf = self else { return }
            guard let data = try? Data(contentsOf: ProxyResources.schools.path) else {
                comp(nil)
                return
            }
            let decoder = JSONDecoder()
            let schools = try? decoder.decode([School].self, from: data)
            strongSelf.schools = schools ?? []
            comp(schools)
        }
    }
    
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
    
    func getScores(_ completion: @escaping SchoolCompletion) {
        let comp: SchoolCompletion = { [weak self] (schools) in
            guard let strongSelf = self else { return }
            strongSelf.queue.async {
                completion(schools)
            }
        }
        queue.async { [weak self] in
            guard let data = try? Data(contentsOf: ProxyResources.scores.path) else {
                comp(nil)
                return
            }
            let decoder = JSONDecoder()
            let decodedScores = try? decoder.decode([SatScores].self,
                                                    from: data)
            guard let scores = decodedScores,
                let strongSelf = self else {
                    return
            }
            strongSelf.schools.join(with: scores)
            comp(strongSelf.schools)
        }
    }
}
