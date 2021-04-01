import SwiftUI

struct FlagImage: View {
    var countryName: String
    
    var body : some View {
        Image(countryName)
            .renderingMode(.original)
            .clipShape(Capsule())
                .overlay(Capsule().stroke(Color
                .black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
        @State private var countries = ["Estonia", "France", "Germany",
                                        "Ireland", "Italy", "Nigeria",
                                        "Poland", "Russia", "Spain",
                                        "UK", "US"].shuffled()
        
        
        @State private var correctAnswer = Int.random(in: 0...2)
        @State private var showingScore = false
        @State private var animationAmount = 0.0
        @State private var userTapped = 0
        @State private var offset = CGFloat.zero
        @State private var disabled = false
        @State private var opacity = 1.0
        @State private var score = 0
        
        func flagTapped(_ number: Int) {
            if number == correctAnswer {
                self.score += 1
            } else {
                showingScore = true
            }
        }

        func askQuestion() {
            self.disabled = false
            self.opacity = 1
            self.offset = .zero
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }

        
            var body: some View {
                
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.gray, .blue]),
                                  startPoint: .top, endPoint: .bottom)
                                  .edgesIgnoringSafeArea(.all)
                
                    VStack(spacing: 30) {
                        VStack {
                            Text("Tap the flag of")
                                .foregroundColor(.white)
                            Text(countries[correctAnswer])
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .fontWeight(.black)
                        }
                        
                        Spacer()

                        ForEach(0 ..< 3) { number in Button(action: {
                            if number == self.correctAnswer {
                                self.flagTapped(number)
                                self.userTapped = number
                                withAnimation(.easeOut(duration: 2)) {
                                    self.animationAmount += 360
                                    self.opacity -= 0.75
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                                { self.askQuestion() }
                            
                            } else {
                                self.flagTapped(number)
                                self.userTapped = number
                                withAnimation(.easeInOut(duration: 0.5)){
                                    self.offset = -205
                                }
                            }
                            self.disabled = true
                            
                        }) {
                            FlagImage(countryName: self.countries[number])
                            }
                        .rotation3DEffect(.degrees(self.animationAmount), axis: (x: 0, y: number == self.userTapped ? 1 : 0, z: 0))
                        .offset(x: number != self.correctAnswer ? self.offset : .zero, y: .zero)
                        .clipped()
                        .opacity(number != self.userTapped ? self.opacity : 5.0)
                        .disabled(self.disabled)
                }
                Spacer()
                    
                        ZStack{
                            Color.green
                            .clipShape(Rectangle())
                                .frame(width: 150, height: 100)
                                .cornerRadius(10)
                            Text("\(score)")
                        }
                        .foregroundColor(.white)
                        .font(.largeTitle)
            }
        }
        .alert(isPresented: $showingScore){
            Alert(title: Text("Wrong"), message: Text("This is the flag of \(countries[userTapped])"), dismissButton: .default(Text("Continue")){
                self.askQuestion()
            })
        }
    }
}

struct COntentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
