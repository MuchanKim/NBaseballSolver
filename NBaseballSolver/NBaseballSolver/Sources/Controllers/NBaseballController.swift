import Foundation

class NBaseballController: ObservableObject {
    @Published private(set) var possibleAnswers: [String] = []
    @Published private(set) var guessHistory: [GuessResult] = []
    
    init() {
        generateInitialNumbers()
    }
    
    private func generateInitialNumbers() {
        for i in 0...9 {
            for j in 0...9 {
                for k in 0...9 {
                    if i != j && j != k && i != k {
                        possibleAnswers.append(String(format: "%d%d%d", i, j, k))
                    }
                }
            }
        }
    }
    
    func addGuess(number: String, strikes: Int, balls: Int) {
        let newGuess = GuessResult(number: number, strikes: strikes, balls: balls)
        guessHistory.append(newGuess)
        filterPossibleAnswers(guess: newGuess)
    }
    
    private func filterPossibleAnswers(guess: GuessResult) {
        possibleAnswers = possibleAnswers.filter { possibleAnswer in
            let (s, b) = calculateStrikeAndBall(answer: possibleAnswer, guess: guess.number)
            return s == guess.strikes && b == guess.balls
        }
    }
    
    private func calculateStrikeAndBall(answer: String, guess: String) -> (strikes: Int, balls: Int) {
        var strikes = 0
        var balls = 0
        
        for i in 0..<3 {
            let guessDigit = guess[guess.index(guess.startIndex, offsetBy: i)]
            if guessDigit == answer[answer.index(answer.startIndex, offsetBy: i)] {
                strikes += 1
            } else if answer.contains(guessDigit) {
                balls += 1
            }
        }
        
        return (strikes, balls)
    }
    
    func reset() {
        guessHistory.removeAll()
        possibleAnswers.removeAll()
        generateInitialNumbers()
    }
    
    func getRandomNumber() -> String? {
        return possibleAnswers.randomElement()
    }
}