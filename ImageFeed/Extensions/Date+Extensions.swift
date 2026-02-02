import Foundation

extension Date {
    var longDateString: String { DateFormatter.longDate.string(from: self) }
}

private extension DateFormatter {
    static let longDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
}
