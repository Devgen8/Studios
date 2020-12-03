
import Foundation
import FirebaseFirestore

class BookingFormModel {
    
    let priceListReference = Firestore.firestore().collection("priceList")
    
    var startTime = Int()
    var endTime = Int()
    var selectedDate = String()
    var group = DispatchGroup()
    
    func getDateString() -> String {
        return "\(startTime):00 - \(endTime):00 \(selectedDate)"
    }
    
    func getPriceList(completion: @escaping () -> Void) {
        group.enter()
        getInstruments()
        
        group.enter()
        getExtraServices()
        
        group.notify(queue: .main, execute: { completion() })
    }
    
    private func getInstruments() {
        priceListReference.document("instruments").getDocument { (document, error) in
            guard error == nil else {
                self.group.leave()
                return
            }
            
        }
    }
    
    private func getExtraServices() {
        
    }
}
