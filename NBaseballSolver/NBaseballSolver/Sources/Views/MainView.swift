import SwiftUI

struct MainView: View {
    @StateObject private var gameController = NBaseballController()
    @State private var inputNumber = ""
    @State private var strikes = 0
    @State private var balls = 0
    
    var body: some View {
        HStack(spacing: 0) {
            // 왼쪽: 가능한 답 목록
            VStack(spacing: 0) {
                Text("가능한 답 목록 (\(gameController.possibleAnswers.count)개)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                
                List {
                    ForEach(gameController.possibleAnswers.chunks(of: 8), id: \.self) { chunk in
                        HStack {
                            ForEach(chunk, id: \.self) { number in
                                Text(number)
                                    .font(.system(.title2, design: .monospaced))
                                    .frame(minWidth: 48)
                                    .padding(.vertical, 4)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            // 오른쪽: 시도 기록과 입력
            VStack(spacing: 0) {
                // 시도 기록
                VStack(spacing: 0) {
                    Text("시도 기록")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                    
                    List {
                        ForEach(gameController.guessHistory) { guess in
                            HStack {
                                Text(guess.number)
                                    .font(.system(.title3, design: .monospaced))
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(guess.strikes)S \(guess.balls)B")
                                    .font(.system(.title3, design: .rounded))
                                    .foregroundColor(guess.strikes == 3 ? .green : .blue)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                Divider()
                    .padding(.vertical, 1)
                
                // 입력 영역
                VStack(spacing: 24) {
                    TextField("숫자 입력", text: $inputNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(.title2, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .onChange(of: inputNumber) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                inputNumber = filtered
                            }
                            if filtered.count > 3 {
                                inputNumber = String(filtered.prefix(3))
                            }
                            
                            let uniqueChars = Array(filtered)
                            if Set(uniqueChars).count != uniqueChars.count {
                                inputNumber = String(Array(Set(uniqueChars)).prefix(3))
                            }
                        }
                    
                    HStack(spacing: 40) {
                        VStack(spacing: 8) {
                            Text("스트라이크")
                                .font(.headline)
                            Stepper("\(strikes)", value: $strikes, in: 0...3)
                                .font(.title3)
                        }
                        
                        VStack(spacing: 8) {
                            Text("볼")
                                .font(.headline)
                            Stepper("\(balls)", value: $balls, in: 0...3)
                                .font(.title3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack(spacing: 20) {
                        Button("랜덤 추천") {
                            if let randomNumber = gameController.getRandomNumber() {
                                inputNumber = randomNumber
                            }
                        }
                        .buttonStyle(CustomButtonStyle(backgroundColor: .blue))
                        .disabled(gameController.possibleAnswers.isEmpty)
                        
                        Button("결과 입력") {
                            guard inputNumber.count == 3 else { return }
                            gameController.addGuess(number: inputNumber, strikes: strikes, balls: balls)
                            inputNumber = ""
                            strikes = 0
                            balls = 0
                        }
                        .buttonStyle(CustomButtonStyle(backgroundColor: .green))
                        .disabled(inputNumber.count != 3)
                        
                        Button("리셋") {
                            inputNumber = ""
                            strikes = 0
                            balls = 0
                            gameController.reset()
                        }
                        .buttonStyle(CustomButtonStyle(backgroundColor: .red))
                    }
                }
                .padding(24)
                .background(Color(NSColor.controlBackgroundColor))
            }
            .frame(width: 330)
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}
