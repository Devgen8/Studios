
import Foundation
import FirebaseFirestore

class SettingsModel {
    
    private let priceListReference = Firestore.firestore().collection("priceList")
    
    private var instruments = [String]()
    private var instrumentPrices = [Int]()
    private var extraServices = [String]()
    private var extraServicesPrices = [Int]()
    private var serviceType: ServiceType?
    
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
    
    func addService(name: String?, price: String?, completion: @escaping (String?) -> Void) {
        guard
            let name = name, name.trimmingCharacters(in: .whitespacesAndNewlines) != "",
            let priceString = price, priceString.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            completion("Заполнены не все поля")
            return
        }
        guard let priceNumber = Int(priceString) else {
            completion("Цена содержит недопустимые символы. Введите число")
            return
        }
        if let serviceType = serviceType, serviceType == .instrument {
            instruments.append(name)
            instrumentPrices.append(priceNumber)
            priceListReference.document("priceList").updateData(["instruments" : instruments,
                                                                 "instrumentPrices" : instrumentPrices])
        }
        if let serviceType = serviceType, serviceType == .extraService {
            extraServices.append(name)
            extraServicesPrices.append(priceNumber)
            priceListReference.document("priceList").updateData(["extraServices" : extraServices,
                                                                 "extraServicesPrices" : extraServicesPrices])
        }
        completion(nil)
    }
    
    func setServiceType(_ newType: ServiceType) {
        serviceType = newType
    }
    
    func getNumberOfServices(for section: Int) -> Int {
        switch section {
        case 0: return instruments.count
        case 1: return extraServices.count
        default: return 0
        }
    }
    
    func getServiceName(for indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0: return instruments[indexPath.row]
        case 1: return extraServices[indexPath.row]
        default: return ""
        }
    }
    
    func getPriceString(for indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0: return "\(instrumentPrices[indexPath.row])"
        case 1: return "\(extraServicesPrices[indexPath.row])"
        default: return ""
        }
    }
    
    func deleteService(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            instruments.remove(at: indexPath.row)
            instrumentPrices.remove(at: indexPath.row)
            priceListReference.document("priceList").updateData(["instruments" : instruments,
                                                                 "instrumentPrices" : instrumentPrices])
        case 1:
            extraServices.remove(at: indexPath.row)
            extraServicesPrices.remove(at: indexPath.row)
            priceListReference.document("priceList").updateData(["extraServices" : extraServices,
                                                                 "extraServicesPrices" : extraServicesPrices])
        default: print()
        }
    }
    
    func editService(name: String?, price: String?, indexPath: IndexPath, completion: @escaping (String?) -> Void) {
        guard
            let name = name, name.trimmingCharacters(in: .whitespacesAndNewlines) != "",
            let priceString = price, priceString.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            completion("Заполнены не все поля")
            return
        }
        guard let priceNumber = Int(priceString) else {
            completion("Цена содержит недопустимые символы. Введите число")
            return
        }
        if indexPath.section == 0 {
            instruments[indexPath.row] = name
            instrumentPrices[indexPath.row] = priceNumber
            priceListReference.document("priceList").updateData(["instruments" : instruments,
                                                                 "instrumentPrices" : instrumentPrices])
        }
        if indexPath.section == 1 {
            extraServices[indexPath.row] = name
            extraServicesPrices[indexPath.row] = priceNumber
            priceListReference.document("priceList").updateData(["extraServices" : extraServices,
                                                                 "extraServicesPrices" : extraServicesPrices])
        }
        completion(nil)
    }
}
