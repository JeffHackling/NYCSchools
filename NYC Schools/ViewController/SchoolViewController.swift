/**************************************
    Main ViewController
 
    - loads schools on start
    - displays schools
    - transitions to detailed schools view
 **************************************/

import UIKit

private let CELL_ID =  "cell"

final class SchoolViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private var tableView: UITableView!
    private var loadingSpinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var service: SchoolService!
    private var schools = [School]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    // MARK: - Initializers
    
    convenience init(service: SchoolService) {
        self.init()
        self.service = service
    }
    
    // MARK: - UIViewController Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        setupTableView()
        setupLoadingView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadSchools()
    }
}

extension SchoolViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! SchoolTableViewCell
        cell.schoolLabel.text = schools[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let school = schools[indexPath.row]
        showDetails(for: school) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

// setup methods
extension SchoolViewController {
    
    private func setupLoadingView() {
        loadingSpinner = UIActivityIndicatorView(style: .whiteLarge)
        loadingSpinner.color = .red
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.isHidden = true
        loadingSpinner.stopAnimating()
        loadingSpinner.setupToCenter(superView: view)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.setupToFill(superView: view)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(SchoolTableViewCell.nib,
                           forCellReuseIdentifier: CELL_ID)
    }
    
    private func downloadSchools() {
        showLoadingUI()
        service.getSchools { [weak self] (schools) in
            guard let strongSelf = self else { return }
            strongSelf.schools = schools ?? []
            strongSelf.hideLoadingUI()
        }
    }
    
}

// loading & navigation methods
extension SchoolViewController {
    
    private func showLoadingUI() {
        tableView.alpha = 0.5
        loadingSpinner.startAnimating()
        tableView.isUserInteractionEnabled = false
    }
    private func hideLoadingUI() {
        DispatchQueue.main.async { [unowned self] in
            self.loadingSpinner.stopAnimating()
            self.tableView.isUserInteractionEnabled = true
            self.tableView.alpha = 1.0
        }
    }
    
    private func showDetails(for school: School,
                             _ completion: (()->())? = nil) {
        showLoadingUI()
        
        // if downloading is sucessful, show details VC
        let success: ()->() = { [weak self] in
            guard let strongSelf = self else { return }
            let vc = SchoolDetailsViewController(school: school)
            strongSelf.show(vc, sender: nil)
        }
        // if downloading is failure, show error message
        let failure: ()->() = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showAlert(text: "Error-Could not load details.")
        }
        // animation for when downloading task is completed,
        // also determine success/failure case and call appropriate
        // closure associated
        let completionAnimation: (Bool)->() = { [unowned self] (loaded) in
            UIView.animate(withDuration: 1.0,
                           animations: {
                            self.tableView.alpha = 1.0
            }, completion: { (completed) in
                if (completed) {
                    self.hideLoadingUI()
                    loaded ? success() : failure()
                    completion?()
                }
            })
        }
        // finally, perform the download task
        service.loadDetailsIfNeeded { (loaded) in
            DispatchQueue.main.async {
                completionAnimation(loaded)
            }
        }
    }
}
