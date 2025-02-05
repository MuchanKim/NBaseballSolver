import Foundation

struct GuessResult: Identifiable {
    var id: String { number }
    let number: String
    let strikes: Int
    let balls: Int
} 