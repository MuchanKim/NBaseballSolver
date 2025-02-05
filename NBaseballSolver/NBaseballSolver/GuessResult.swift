import Foundation

struct GuessResult: Identifiable {
    var id: String { number } // number를 id로 사용
    let number: String
    let strikes: Int
    let balls: Int
} 