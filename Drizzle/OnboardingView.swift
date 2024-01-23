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
    @State private var isNameValid: Bool = false

    var body: some View {
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
                    .overlay(RoundedRectangle(cornerSize: CGSize(width: 1, height: 1)).frame(height: 1).padding(.top, 35))
                    .padding(10)
                    
                    if isNameValid {
                        Button(action: {
                            showOnboarding = false
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

#Preview {
    OnboardingView()
}
