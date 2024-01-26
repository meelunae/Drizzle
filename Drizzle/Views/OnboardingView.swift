//
//  OnboardingView.swift
//  Drizzle
//
//  Created by Meelunae on 23/01/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var showLogo = true
    var body: some View {
        if showLogo {
            OnboardingLogoView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        showLogo = false
                    }
                }
        } else {
            OnboardingFormView()
        }
    }
}

struct OnboardingLogoView: View {
    @State private var showText = true
    var body: some View {
        VStack {
            Spacer()
            VStack {
                if !showText {
                    Image(systemName: "cloud.rain.circle.fill")
                        .font(.largeTitle)
                        .transition(.opacity)
                        .padding([.bottom], 4)
                    Text("Welcome to Drizzle")
                        .fontWeight(.bold)
                        .font(.title)
                        .transition(.opacity)
                        .monospaced()
                }
            }
            .onAppear {
                withAnimation(.smooth(duration: 3)) {
                        self.showText.toggle()
                }
            }
            Spacer()
            // This ensures the parent is kept wide to avoid the shift.
                   HStack { Spacer() }
        }
    }
}

struct OnboardingFormView: View {
    @AppStorage("showUserOnboarding") var showOnboarding: Bool = true
    @AppStorage("userName") private var name: String = ""
    @State private var transitionToNextView = false
    @State private var isNameValid: Bool = false

    var body: some View {
        if !transitionToNextView {
            VStack {
                 Spacer()
                 VStack {
                     Text("What is your name?")
                         .font(.title)
                         .fontWeight(.semibold)
                         .monospaced()

                     HStack {
                         Spacer()
                         TextField(
                             "Name",
                             text: $name
                         )
                         .frame(width: 250)
                         .onChange(of: name) { newValue in
                             validateInputAsync(newValue)
                          }
                         .monospaced()
                         .font(.title3)
                         .disableAutocorrection(true)
                         .textFieldStyle(.plain)
                         .padding(.vertical, 10)
                         .overlay(
                             RoundedRectangle(
                                 cornerSize: CGSize(width: 1, height: 1))
                                 .frame(height: 1).padding(.top, 35)
                         )
                         .padding(10)

                         if isNameValid {
                             Button(action: {
                                 transitionToNextView = true
                             }, label: {
                                 Image(systemName: "arrow.right.circle")
                             })
                             .monospaced()
                             .font(.title3)
                             .buttonStyle(.plain)
                             .padding(.vertical, 10)
                         }
                         Spacer()
                     }
                 }
                 Spacer()
                 HStack { Spacer() }
             }
        } else {
            OnboardingDurationPickerView()
        }
    }

    // Asynchronous validation to avoid thread unresponsiveness
    func validateInputAsync(_ input: String) {
          DispatchQueue.global().async {
              let isValid = validateInput(input)
              DispatchQueue.main.async {
                  self.isNameValid = isValid
              }
          }
      }

    func validateInput(_ input: String) -> Bool {
           let letterCharacterSet = CharacterSet.letters
           let inputCharacterSet = CharacterSet(charactersIn: input)
           return input.count >= 3 && inputCharacterSet.isSubset(of: letterCharacterSet)
       }
}

struct OnboardingDurationPickerView: View {

    @AppStorage("showUserOnboarding") var showOnboarding: Bool = true
    @AppStorage("userName") private var name: String = ""
    @AppStorage("studyDuration") private var studyDuration: Int = 5
    @AppStorage("restingDuration") private var restingDuration: Int = 5
    @State private var isNameValid: Bool = false
    @State private var showUsernameGreeting: Bool = false
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Nice to meet you, \(name)!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .monospaced()
                Text("Now let's pick your preferred durations for study and resting sprints.")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .monospaced()
                HStack {
                    VStack {
                        StepperView(label: "Study sprints:",
                                    minValue: 5,
                                    maxValue: 30,
                                    currentValue: $studyDuration
                        )
                            .monospaced()
                            .font(.title3)
                            .padding()
                        StepperView(label: "Resting sprints:",
                                    minValue: 5,
                                    maxValue: 30,
                                    currentValue: $restingDuration)
                            .monospaced()
                            .font(.title3)
                            .padding()
                        HStack {
                            Button(action: {
                                showOnboarding = false
                            }, label: {
                                Text("Let's get started")
                            })
                            .monospaced()
                            .font(.title3)
                            .background(Color.orange)
                            .clipShape(Capsule())
                            .padding()
                            Spacer()
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
            Spacer()
            HStack { Spacer() }
        }
    }
}

struct StepperView: View {
    let label: String
    let minValue: Int
    let maxValue: Int
    @Binding var currentValue: Int
    var body: some View {
        HStack {
            Text("\(label)")
            Text("\(currentValue) mins")
            Spacer()
                .frame(width: 10)
            Button(action: {
                currentValue -= 1
                print("Pressed minus button")
            }, label: {
                Text("\(Image(systemName: "minus"))")
            })
            .padding(4)
            .buttonStyle(.plain)
            Divider().frame(width: 1) // vertical divider
            Button(action: {
                currentValue += 1
            }, label: {
                Text("\(Image(systemName: "plus"))")
            })
            .padding(4)
            .buttonStyle(.plain)
        }
        .onAppear {
            currentValue = minValue
        }
        .onChange(of: currentValue) { newValue in
            if newValue < minValue {
                currentValue = minValue
            } else if newValue == minValue {
                // disable minus
            } else if newValue == maxValue {
                // disable plus
            } else if newValue > maxValue {
                currentValue = maxValue
            }
        }
        .frame(height: 20)
    }
}

#Preview {
    OnboardingView()
}
