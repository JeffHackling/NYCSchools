import UIKit

final class SchoolDetailsViewController: UIViewController {
    
    // MARK: - Storyboard Outlets
    
    @IBOutlet var schoolNameLabel: UILabel!
    @IBOutlet var schoolIDLabel: UILabel!
    @IBOutlet var scoresTitleLabel: UILabel!
    @IBOutlet var mathLabel: UILabel!
    @IBOutlet var readingLabel: UILabel!
    @IBOutlet var writingLabel: UILabel!
    
    // MARK: - Properties
    
    var school: School!
    
    // MARK: - Initialization
    
    convenience init(school: School) {
        self.init(nibName: "SchoolDetailsViewController",
                  bundle: nil)
        self.school = school
    }
    
    // MARK: - UIViewController Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    // MARK: - Setup Method
    
    private func setupUI() {
        let formatter = SchoolFormatter(school)
        schoolNameLabel.text = formatter.name
        schoolIDLabel.text = formatter.id
        mathLabel.text = formatter.math
        readingLabel.text = formatter.reading
        writingLabel.text = formatter.writing
    }
    
}
