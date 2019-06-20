import UIKit

final class SchoolTableViewCell: UITableViewCell {
    @IBOutlet var schoolLabel: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: "SchoolTableViewCell",
                     bundle: nil)
    }
}
