/*

 Use to swap between DEBUG and NORMAL behavior
 Default is ENABLED = 'false', uses normal webservices

*/

import UIKit

struct GlobalDebugConstants {
    private init() { }
    static let ENABLED = false
    static let color = UIColor.green
    static let message = "DEBUG"
}

