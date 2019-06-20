/**************************************
 School Formatter
 
 - basic formatting object for appearance and UI-related work
 **************************************/

import Foundation

private let UNKNOWN_STRING_DEFAULT = "Unknown"

struct SchoolFormatter {
    
    // MARK: - Properties
    
    let school: School
    let unknownString: String
    
    // MARK: - Initializer
    
    /// optional parameter 'unknownString' uses default value 'Unknown' if omitted
    init(_ school: School,
         _ unknownString: String = UNKNOWN_STRING_DEFAULT) {
        self.school = school
        self.unknownString = unknownString
    }
    
    // MARK: - Formatted Interfaces via Computed Properties
    
    var name: String {
        return school.name
    }
    var id: String {
        return school.id
    }
    var math: String {
        return "Math: " + (school.satScores?.math ?? unknownString)
    }
    var reading: String {
        return "Reading: " + (school.satScores?.reading ?? unknownString)
    }
    var writing: String {
        return "Writing: " + (school.satScores?.writing ?? unknownString)
    }
    var participants: String {
        return  "Participants: " + (school.satScores?.participants ?? unknownString)
    }
}
