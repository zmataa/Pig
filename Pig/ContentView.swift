import SwiftUI

struct ContentView: View {
    @State var turnScore = 0
    @State var gameScore = 0
    @State var randomValue = 0
    @State var rotation = 0.0
    @State var gameOver = false

    var body: some View {
        NavigationView() {
            ZStack {
                Color.gray.opacity(0.7).ignoresSafeArea()
                VStack {
                    Image("Pig").resizable().frame(width: 150, height: 150)
                    CustomText(text: "Pig")
                    Image("pips \(randomValue)")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(rotation))
                        .rotation3DEffect(.degrees(rotation), axis: (x: 1, y: 1, z: 1))
                        .padding(50)
                    CustomText(text: "Turn Score: \(turnScore)")
                    
                    HStack {
                        Button("Roll") {
                            chooseRandom(times: 3)
                            withAnimation(.interpolatingSpring(stiffness: 10, damping: 2)) {
                                rotation += 360
                            }
                        }
                        .buttonStyle(CustomButtonStyle())
                        
                        Button("Hold") {
                            gameScore += turnScore
                            endTurn()
                            withAnimation(.easeInOut(duration: 1)) {
                                rotation += 360
                            }
                            if gameScore >= 100 {
                                gameOver = true
                            }
                        }
                        .buttonStyle(CustomButtonStyle())
                    }
                    
                    CustomText(text: "Game Score: \(gameScore)")
                    NavigationLink("How to Play", destination: InstructionsView())
                        .font(Font.custom("Marker Felt", size: 24))
                        .padding()
                    Button("Reset") {
                        endTurn()
                        gameScore = 0
                    }
                    .font(Font.custom("Marker Felt", size: 24))
                    
                    Spacer()
                }
            }
            .alert(isPresented: $gameOver, content: {
                Alert(
                    title: Text("You won the game!"),
                    dismissButton: .destructive(Text("Play Again!"), action: {
                        withAnimation {
                            gameScore = 0
                            gameOver = false
                        }
                    })
                )
            })
        }
    }
    
    // Move these functions outside the body
    func endTurn() {
        turnScore = 0
        randomValue = 0
    }

    func chooseRandom(times: Int) {
        if times > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                randomValue = Int.random(in: 1...6)
                chooseRandom(times: times - 1)
            }
        } else {
            if randomValue == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    endTurn()
                }
            } else {
                turnScore += randomValue
            }
        }
    }


    struct CustomText: View {
        let text: String
        var body: some View {
            Text(text).font(Font.custom("Marker Felt", size: 36))
        }
    }

    struct CustomButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: 50)
                .font(Font.custom("Marker Felt", size: 24))
                .padding()
                .background(.red).opacity(configuration.isPressed ? 0.0 : 1.0)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    struct InstructionsView: View {
        var body: some View {
            ZStack {
                Color.gray.opacity(0.7).ignoresSafeArea()
                VStack {
                    Image("Pig").resizable().frame(width: 150, height: 150)
                    CustomText(text: "Pig")
                    VStack(alignment: .leading) {
                        Text("In the game of Pig, players take individual turns. Each turn, a player repeatedly rolls a single die until either a pig is rolled or the player decides to \"hold\".")
                            .padding()
                        Text("If a player rolls a pig, they score nothing and it is the next player's turn.")
                            .padding()
                        Text("If the player rolls any other number, it is added to their turn total, and the player's turn continues.")
                            .padding()
                        Text("If the player chooses to \"hold\", their turn total is added to the game score, and it becomes the next player's turn.")
                            .padding()
                        Text("A player wins the game when their score becomes 100 or more on their turn.")
                            .padding()
                    }
                    Spacer()
                }
            }
        }
    }
}
