//
//  OnboardingView.swift
//  Drizzle
//
//  Created by Meelunae on 23/01/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var preferences: AppPreferences
    @State private var showLogo = true
    var body: some View {
        if showLogo {
                OnboardingLogoView()
                .background(IdleGradientBackground())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    showLogo = false
                }
            }
        } else {
            OnboardingFormView()
                .environmentObject(preferences)
            .background(IdleGradientBackground())
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
                    Image("AppLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .transition(.opacity)
                        .frame(width: 64, height: 64)
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
    @EnvironmentObject var preferences: AppPreferences
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
                        TextField("Name", text: $preferences.userName)
                        .frame(width: 250)
                        .onChange(of: preferences.userName) { newValue in
                            validateInputAsync(newValue)
                        }
                        .monospaced()
                        .font(.title3)
                        .disableAutocorrection(true)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 10)
                        .overlay(
                            RoundedRectangle(
                                cornerSize: CGSize(width: 1, height: 1)
                            )
                            .frame(height: 1)
                            .padding(.top, 35)
                        )
                        .padding(8)
                        Button(action: {
                            transitionToNextView = true
                        }, label: {
                            Image(systemName: "arrow.right.circle")
                        })
                        .monospaced()
                        .font(.title3)
                        .buttonStyle(.plain)
                        .padding(.vertical, 10)
                        .disabled(!isNameValid)
                        Spacer()
                    }
                }
                Spacer()
                HStack { Spacer() }
            }
        } else {
            OnboardingDurationPickerView()
                .environmentObject(preferences)
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
    @EnvironmentObject var preferences: AppPreferences
    @State private var isNameValid: Bool = false
    @State private var showUsernameGreeting: Bool = false
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Nice to meet you, \(preferences.userName)!")
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
                                    currentValue: $preferences.studyDuration
                        )
                            .monospaced()
                            .font(.title3)
                            .padding()
                        StepperView(label: "Resting sprints:",
                                    minValue: 5,
                                    maxValue: 30,
                                    currentValue: $preferences.restingDuration)
                            .monospaced()
                            .font(.title3)
                            .padding()
                        HStack {
                            Spacer()
                            Button(action: {
                                preferences.showOnboarding = false
                            }, label: {
                                Text("Get started")
                            })
                            .monospaced()
                            .font(.title3)
                            .padding()
                            .buttonStyle(PlainButtonStyle())
                            .overlay(
                                RoundedRectangle(
                                    cornerRadius: 12,
                                    style: .continuous
                                )
                                .stroke(Color.white, lineWidth: 1)
                                .background(Color.clear)
                            )
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
    @State var hasReachedMin: Bool = true
    @State var hasReachedMax: Bool = false
    @Binding var currentValue: Int
    var body: some View {
        HStack {
            Text("\(label)")
            Text("\(currentValue) mins")
            Spacer()
            .frame(width: 10)
            Button(action: {
                currentValue -= 1
            }, label: {
                Text("\(Image(systemName: "minus"))")
            })
            .disabled(hasReachedMin)
            .padding(4)
            .buttonStyle(.plain)
            Divider().frame(width: 1) // vertical divider
            Button(action: {
                currentValue += 1
            }, label: {
                Text("\(Image(systemName: "plus"))")
            })
            .disabled(hasReachedMax)
            .padding(4)
            .buttonStyle(.plain)
        }
        .onChange(of: currentValue) { newValue in
            if newValue < minValue {
                currentValue = minValue
            } else if newValue == minValue {
                hasReachedMin = true
            } else if newValue == maxValue {
                hasReachedMax = true
            } else if newValue > maxValue {
                currentValue = maxValue
            } else {
                hasReachedMin = false
                hasReachedMax = false
            }
        }
        .frame(height: 20)
    }
}

#Preview {
    OnboardingView()
}
