
import UIKit
import FSCalendar

class StudiosViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var scheduleCollectionView: UICollectionView!
    @IBOutlet weak var timePickingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var startTimeCellIndex: Int? {
        didSet {
            colorBetweenDates()
        }
    }
    
    var endTimeCellIndex: Int? {
        didSet {
            colorBetweenDates()
        }
    }
    
    var model = StudiosModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationItem()
        configureScreenElements()
        configureCalendar()
        setupBookButton()
        getStudioStatus()
    }
    
    private func getStudioStatus() {
        let isEmpty = model.isStudioEmptyNow()
        statusLabel.backgroundColor = isEmpty ? #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) : #colorLiteral(red: 0.7611784935, green: 0, blue: 0.06764990836, alpha: 1)
        statusLabel.text = isEmpty ? "Время свободно" : "Забронировано"
    }
    
    private func configureCalendar() {
        calendar.locale = Locale(identifier: "ru")
        calendar.dataSource = self
        calendar.delegate = self
    }
    
    private func configureNavigationItem() {
        let bookButton = UIBarButtonItem(title: "Просмотр", style: .plain, target: self, action: #selector(changeModeTapped))
        self.navigationItem.rightBarButtonItem  = bookButton
    }
    
    @objc private func changeModeTapped() {
        let adminMode = model.getAdminMode()
        if adminMode == .read {
            model.setAdminMode(.edit)
            navigationItem.rightBarButtonItem?.title = "Бронирование"
        } else {
            model.setAdminMode(.read)
            navigationItem.rightBarButtonItem?.title = "Просмотр"
        }
        configureScreenElements()
    }
    
    private func configureCollectionView() {
        let nibCell = UINib(nibName: "TimeCollectionViewCell", bundle: nil)
        scheduleCollectionView.register(nibCell, forCellWithReuseIdentifier: "TimeCollectionViewCell")
        scheduleCollectionView.collectionViewLayout = getCellsLayout()
        scheduleCollectionView.delegate = self
        scheduleCollectionView.dataSource = self
    }
    
    @IBAction func statusDetailsTapped(_ sender: UIButton) {
    }
    
    func getCellsLayout() -> UICollectionViewFlowLayout {
        let itemSize = UIScreen.main.bounds.width / 3 - 23
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: 60)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        return layout
    }
    
    func configureScreenElements() {
        if model.getAdminMode() == .read {
            timePickingSegmentedControl.isHidden = true
            cancelButton.isHidden = true
        } else {
            timePickingSegmentedControl.isHidden = false
            cancelButton.isHidden = false
        }
    }
    
    func setupBookButton() {
        bookButton.isHidden = !(startTimeCellIndex != nil && endTimeCellIndex != nil)
    }
    
    @IBAction func timeMarkChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            model.setTimeMark(.start)
        } else {
            model.setTimeMark(.end)
        }
    }
    
    @IBAction func bookTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
    }
}

extension StudiosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.getNumberOfTimes()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollectionViewCell", for: indexPath) as! TimeCollectionViewCell
        let timeString = model.getTimeString(for: indexPath.row)
        cell.timeLabel.text = "\(timeString):00"
        return cell
    }
}

extension StudiosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if model.getAdminMode() == .edit {
            if model.isStudioEmpty(at: indexPath.row) {
                if model.getTimeMark() == .start {
                    if let index = startTimeCellIndex {
                        collectionView.cellForItem(at: IndexPath(row: index, section: 0))?.backgroundColor = .white
                    }
                    startTimeCellIndex = indexPath.row
                } else {
                    if let index = endTimeCellIndex {
                        collectionView.cellForItem(at: IndexPath(row: index, section: 0))?.backgroundColor = .white
                    }
                    endTimeCellIndex = indexPath.row
                }
                collectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                setupBookButton()
            } else {
                
            }
        }
    }
    
    func colorBetweenDates() {
        guard let startIndex = startTimeCellIndex,
              let endIndex = endTimeCellIndex,
              startIndex != endIndex else {
            return
        }
        for cellIndex in 0..<model.getNumberOfTimes() {
            if cellIndex == startIndex || cellIndex == endIndex {
                continue
            }
            if ((startIndex + 1)..<endIndex).contains(cellIndex) {
                scheduleCollectionView.cellForItem(at: IndexPath(row: cellIndex, section: 0))?.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else {
                scheduleCollectionView.cellForItem(at: IndexPath(row: cellIndex, section: 0))?.backgroundColor = .white
            }
        }
    }
}

extension StudiosViewController: FSCalendarDataSource {
    
}

extension StudiosViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        model.setSelectedDay(day: date)
    }
}
