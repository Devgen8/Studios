
import Foundation

class StudiosModel {
    
    private var bookingTime = [String]()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.mm.yyyy"
        return formatter
    }()
    private var selectedDay = String()
    private var mode = AdminMode.read
    private let studioOpenTime = 8
    private var timeMark = TimeMark.start
    private let numberOfTimes = 15
    
    func isStudioEmptyNow() -> Bool {
        let hourNumber = Calendar.current.component(.hour, from: Date())
        return isStudioEmpty(at: hourNumber - studioOpenTime)
    }
    
    func isStudioEmpty(at cellIndex: Int) -> Bool {
        let currentHour = getTimeString(for: cellIndex)
        let bookingTimeString = "\(currentHour):00"
        return !bookingTime.contains(bookingTimeString)
    }
    
    func setSelectedDay(day: Date) {
        selectedDay = dateFormatter.string(from: day)
    }
    
    func getAdminMode() -> AdminMode {
        return mode
    }
    
    func setAdminMode(_ newMode: AdminMode) {
        mode = newMode
    }
    
    func getTimeMark() -> TimeMark {
        return timeMark
    }
    
    func setTimeMark(_ newTimeMark: TimeMark) {
        timeMark = newTimeMark
    }
    
    func getTimeString(for index: Int) -> Int {
        return index + studioOpenTime
    }
    
    func getNumberOfTimes() -> Int {
        return numberOfTimes
    }
}
