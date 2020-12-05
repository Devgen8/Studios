
import Foundation
import FirebaseFirestore

class StudiosModel {
    
    private let bookingsReference = Firestore.firestore().collection("bookings")
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    private var selectedDay = String()
    private var mode = AdminMode.read
    private let studioOpenTime = 8
    private var timeMark = TimeMark.start
    private let numberOfTimes = 15
    private var bookings = [Booking]()
    private var betweenTimes = [String]()
    private var edgeTimes = [String]()
    private var currentBooking: Booking?
    private var editingBooking: Booking?
    
    func getSudioSchedule(completion: @escaping () -> Void) {
        bookingsReference.whereField("bookDate", isEqualTo: selectedDay).getDocuments { (snapshot, error) in
            guard error == nil, let documents = snapshot?.documents else {
                completion()
                return
            }
            self.bookings = []
            self.edgeTimes = []
            self.betweenTimes = []
            for document in documents {
                var booking = Booking()
                booking.bookDate = document.data()["bookDate"] as? String ?? ""
                booking.clientName = document.data()["clientName"] as? String ?? ""
                booking.clientPhoneNumber = document.data()["clientPhoneNumber"] as? String ?? ""
                booking.clientSurname = document.data()["clientSurname"] as? String ?? ""
                booking.creationDate = document.data()["creationDate"] as? String ?? ""
                booking.elementsQuantity = document.data()["elementsQuantity"] as? [String:Int] ?? [:]
                booking.fullPrice = document.data()["fullPrice"] as? Int ?? 0
                booking.timeArray = document.data()["timeArray"] as? [String] ?? []
                self.parseTimeTypes(booking.timeArray)
                self.bookings.append(booking)
            }
            let currentHour = Calendar.current.component(.hour, from: Date())
            if let currentBook = self.bookings.first(where: { $0.timeArray.contains("\(currentHour):00") }) {
                self.currentBooking = currentBook
            }
            completion()
        }
    }
    
    private func parseTimeTypes(_ times: [String]) {
        var newTimes = times
        if newTimes.count > 0 {
            edgeTimes.append(newTimes.remove(at: 0))
        }
        if newTimes.count > 0 {
            edgeTimes.append(newTimes.remove(at: newTimes.count - 1))
        }
        betweenTimes += newTimes
    }
    
    func isTimeEdge(_ time: String) -> Bool? {
        if edgeTimes.contains(time) {
            return true
        }
        if betweenTimes.contains(time) {
            return false
        }
        return nil
    }
    
    func isStudioEmptyNow() -> Bool? {
        guard selectedDay == dateFormatter.string(from: Date()) else {
            return nil
        }
        let hourNumber = Calendar.current.component(.hour, from: Date())
        return isStudioEmpty(at: hourNumber - studioOpenTime)
    }
    
    func isStudioEmpty(at cellIndex: Int) -> Bool {
        let bookingTime = edgeTimes + betweenTimes
        let currentHour = getTimeString(for: cellIndex)
        let bookingTimeString = "\(currentHour):00"
        return !bookingTime.contains(bookingTimeString)
    }
    
    func isStudioBooked() -> Bool {
        return currentBooking != nil
    }
    
    func isStudioEmptyBetween(_ startIndex: Int, and endIndex: Int) -> Bool {
        var possibleTimeArray = [String]()
        let bookingTime = edgeTimes + betweenTimes
        for hour in (startIndex + studioOpenTime)..<(endIndex + studioOpenTime) {
            possibleTimeArray.append("\(hour):00")
        }
        for possibleTime in possibleTimeArray {
            if bookingTime.contains(possibleTime) {
                return false
            }
        }
        return true
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
    
    func transportData(to model: BookingFormModel, startTimeIndex: Int, endTimeIndex: Int) {
        model.selectedDate = selectedDay
        model.startTime = startTimeIndex + studioOpenTime
        model.endTime = endTimeIndex + studioOpenTime + 1
        if editingBooking != nil {
            model.editingBooking = editingBooking
        }
    }
    
    func transportCurrentData(to model: BookingDetailsModel) {
        model.setBooking(currentBooking ?? Booking())
    }
    
    func transportData(to model: BookingDetailsModel, cellIndex: Int) {
        if let lookingBooking = bookings.first(where: { $0.timeArray.contains("\(cellIndex + studioOpenTime):00") }) {
            model.setBooking(lookingBooking)
        }
    }
    
    //MARK: - Editing
    
    func getEditingTimeIndecies(for index: Int) -> (Int, Int) {
        let timeString = "\(index + studioOpenTime):00"
        var startIndex = 0
        var endIndex = 0
        if let editingBook = bookings.first(where: { $0.timeArray.contains(timeString) }) {
            editingBooking = editingBook
            let timeArray = editingBook.timeArray
            let firstIndex = getStartIndex(of: timeArray.first ?? "")
            startIndex = firstIndex
            endIndex = firstIndex + timeArray.count - 1
        }
        return (startIndex, endIndex)
    }
    
    func removeBookedTimeForEditing() {
        if let booking = editingBooking {
            edgeTimes = edgeTimes.filter({ !booking.timeArray.contains($0) })
            betweenTimes = betweenTimes.filter({ !booking.timeArray.contains($0) })
        }
    }
    
    func addBookedTimeForEditing() {
        parseTimeTypes(editingBooking?.timeArray ?? [])
    }
    
    func stopEditingBooking() {
        editingBooking = nil
    }
    
    private func getStartIndex(of timeString: String) -> Int {
        var hours = [Character]()
        for letter in timeString {
            if letter == ":" {
                break
            } else {
                hours.append(letter)
            }
        }
        return (Int(String(hours)) ?? 0) - studioOpenTime
    }
    
    func isBookingEditing() -> Bool {
        return editingBooking != nil
    }
    
    //MARK: - Delete booking
    
    func deleteBooking(at cellIndex: Int) {
        let seletedTime = "\(cellIndex + studioOpenTime):00"
        if let deletingBooking = bookings.first(where: { $0.timeArray.contains(seletedTime) }) {
            edgeTimes = edgeTimes.filter({ !deletingBooking.timeArray.contains($0) })
            betweenTimes = betweenTimes.filter({ !deletingBooking.timeArray.contains($0) })
            bookings = bookings.filter({ $0.creationDate != deletingBooking.creationDate })
            deleteFromFirestore(deletingBooking)
        }
    }
    
    private func deleteFromFirestore(_ deleteBooking: Booking) {
        bookingsReference.document(deleteBooking.creationDate).delete()
    }
}
