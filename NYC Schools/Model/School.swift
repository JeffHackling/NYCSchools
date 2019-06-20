import Foundation

class School: Decodable {
    let id: String
    let name: String
    var satScores: SatScores?
    enum CodingKeys: String, CodingKey {
        case id = "dbn"
        case name = "school_name"
    }
    init(id: String, name: String) {
        self.id = id; self.name = name
    }
}
extension School {
    var description: String {
        let formatter = SchoolFormatter(self)
        return "\(id)\n\(name)\n\(formatter.participants)\n\(formatter.math)\n\(formatter.reading)\n\(formatter.writing)"
    }
}

struct SatScores: Decodable {
    let id: String
    let participants: String
    let reading: String
    let writing: String
    let math: String
    enum CodingKeys: String, CodingKey {
        case id = "dbn"
        case participants = "num_of_sat_test_takers"
        case reading = "sat_critical_reading_avg_score"
        case writing = "sat_writing_avg_score"
        case math = "sat_math_avg_score"
    }
}

// utility extension, joins scores to existing schools
extension Array where Element == School {
    var description: String {
        return self.map { return $0.description }.joined(separator: "\n")
    }
    
    func join(with scores: [SatScores]) {
        var scoresIndex = [String: Int]()
        for (i, school) in self.enumerated() {
            scoresIndex[school.id] = i
        }
        for score in scores {
            guard let schoolIndex = scoresIndex[score.id] else {
                continue
            }
            self[schoolIndex].satScores = score
        }
    }
}
