
import Foundation
import FirebaseFirestore

class BookingFormModel {
    
    private let priceListReference = Firestore.firestore().collection("priceList")
    private let bookingsReference = Firestore.firestore().collection("bookings")
    
    private var instruments = [String]()
    private var instrumentPrices = [Int]()
    private var extraServices = [String]()
    private var extraServicesPrices = [Int]()
    private var elementsQuantity = [String : Int]()
    private var fullPrice = 0
    var startTime = Int()
    var endTime = Int()
    var selectedDate = String()
    var editingBooking: Booking?
    
    func getDateString() -> String {
        return "\(startTime):00 - \(endTime):00 \(selectedDate)"
    }
    
    func getPriceList(completion: @escaping () -> Void) {
        priceListReference.document("priceList").getDocument { (document, error) in
            guard error == nil else {
                completion()
                return
            }
            self.instruments = document?.data()?["instruments"] as? [String] ?? []
            self.instrumentPrices = document?.data()?["instrumentPrices"] as? [Int] ?? []
            self.extraServices = document?.data()?["extraServices"] as? [String] ?? []
            self.extraServicesPrices = document?.data()?["extraServicesPrices"] as? [Int] ?? []
            completion()
        }
    }
    
    func bookTime(surname: String?,
                  name: String?,
                  phoneNumber: String?,
                  completion: @escaping (String?) -> Void) {
        
        guard let surname = surname, surname.trimmingCharacters(in: .whitespacesAndNewlines) != "",
              let name = name, name.trimmingCharacters(in: .whitespacesAndNewlines) != "",
              let phoneNumber = phoneNumber, phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            completion("Заполнены не все поля")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh.mm.ss"
        let creationDate = dateFormatter.string(from: Date())
        bookingsReference.document(creationDate).setData(["creationDate" : creationDate,
                                                          "bookDate" : selectedDate,
                                                          "timeArray" : getTimeArray(),
                                                          "clientSurname" : surname,
                                                          "clientName" : name,
                                                          "clientPhoneNumber" : phoneNumber,
                                                          "elementsQuantity" : elementsQuantity,
                                                          "fullPrice" : fullPrice])
        deleteOldBooking()
        completion(nil)
    }
    
    private func deleteOldBooking() {
        if let oldBooking = editingBooking {
            bookingsReference.document(oldBooking.creationDate).delete()
        }
    }
    
    private func getTimeArray() -> [String] {
        var timeArray = [String]()
        for hour in startTime..<endTime {
            timeArray.append("\(hour):00")
        }
        return timeArray
    }
    
    func getFullPriceString() -> String {
        var fullPrice = 0
        for pair in elementsQuantity {
            let name = pair.key
            if let instrumentIndex = instruments.firstIndex(of: name) {
                fullPrice += instrumentPrices[instrumentIndex] * (endTime - startTime) * pair.value
            }
            if let extraServiceIndex = extraServices.firstIndex(of: name) {
                fullPrice += extraServicesPrices[extraServiceIndex] * (endTime - startTime) * pair.value
            }
        }
        self.fullPrice = fullPrice
        return "Общая стоимость: \(fullPrice) руб."
    }
    
    func updateElementsQuantity(indexPath: IndexPath, value: Int) {
        var key = String()
        switch indexPath.section {
        case 0:
            key = instruments[indexPath.row]
        case 1:
            key = extraServices[indexPath.row]
        default:
            key = ""
        }
        elementsQuantity[key] = value
    }
    
    func getNumberOfInstruments() -> Int {
        return instruments.count
    }
    
    func getNumberOfExtrServices() -> Int {
        return extraServices.count
    }
    
    func getInstrumentName(for index: Int) -> String {
        return instruments[index]
    }
    
    func getExtraServiceName(for index: Int) -> String {
        return extraServices[index]
    }
    
    func getInstrumentPrice(for index: Int) -> String {
        let instrumentName = instruments[index]
        return "\(instrumentPrices[index] * (endTime - startTime) * (elementsQuantity[instrumentName] ?? 0))"
    }
    
    func getExtraServicePrice(for index: Int) -> String {
        let serviceName = extraServices[index]
        return "\(extraServicesPrices[index] * (endTime - startTime) * (elementsQuantity[serviceName] ?? 0))"
    }
    
    func getQuantityOfElements(for index: IndexPath) -> String {
        switch index.section {
        case 0:
            let instrumentName = instruments[index.row]
            return "\(elementsQuantity[instrumentName] ?? 0)"
        case 1:
            let serviceName = extraServices[index.row]
            return "\(elementsQuantity[serviceName] ?? 0)"
        default: return "0"
        }
    }
    
    //MARK: - Editing
    
    func isBookingEditing() -> Bool {
        return editingBooking != nil
    }
    
    func getClientSurname() -> String? {
        return editingBooking?.clientSurname
    }
    
    func getClientName() -> String? {
        return editingBooking?.clientName
    }
    
    func getClientPhoneNumber() -> String? {
        return editingBooking?.clientPhoneNumber
    }
    
    func fulfillEditingData() {
        fullPrice = editingBooking?.fullPrice ?? 0
        elementsQuantity = editingBooking?.elementsQuantity ?? [:]
    }
}
