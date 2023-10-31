import UIKit


extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}


var greeting = "Hello, playground"

var today = Date()

var day = "2023-04-23".toDate()!

day < today
