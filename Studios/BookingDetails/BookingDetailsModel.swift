
import Foundation

class BookingDetailsModel {
    private var booking = Booking()
    private var services = [String]()
    
    func getDateString() -> String {
        let endTime = getFinishTime()
        return "\(booking.timeArray.first ?? "") - \(endTime) \(booking.bookDate)"
    }
    
    private func getFinishTime() -> String {
        var hours = [Character]()
        let startTime = booking.timeArray.first ?? ""
        for letter in startTime {
            if letter == ":" {
                break
            } else {
                hours.append(letter)
            }
        }
        let endHour = (Int(String(hours)) ?? 0) + booking.timeArray.count
        return "\(endHour):00"
    }
    
    func getSurname() -> String {
        return booking.clientSurname
    }
    
    func getName() -> String {
        return booking.clientName
    }
    
    func getPhoneNumber() -> String {
        return booking.clientPhoneNumber
    }
    
    func getFullPrice() -> String {
        return "К оплате: \(booking.fullPrice) руб."
    }
    
    func convertDictToArray() {
        for pair in booking.elementsQuantity {
            services.append("\(pair.key) х\(pair.value)")
        }
    }
    
    func setBooking(_ newBooking: Booking) {
        booking = newBooking
    }
    
    func getNumberOfServices() -> Int {
        return services.count
    }
    
    func getServiceString(for index: Int) -> String {
        return services[index]
    }
}
