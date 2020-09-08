//
//  ContentView.swift
//  WeSplit
//
//  Created by Larry Nguyen on 9/7/20.
//  Copyright © 2020 Larry Nguyen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tipPercent = 2
    @State private var numberOfPeople = 0
    @State private var checkAmount = "" // Text field values must be strings
    
    let tipPercentages = [0, 10, 15, 18, 20, 25]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2) // Picker for # of people starts at 2
        let tipSelection = Double(tipPercentages[tipPercent])
        let orderAmount = Double(checkAmount) ?? 0
        let billTotal = (orderAmount * (1 + tipSelection/100))
        return billTotal / peopleCount
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Bill Total")) {
                    TextField("Enter check total", text: $checkAmount)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Select percent tip")) {
                    Picker("Tip Percentage", selection: $tipPercent) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 30) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section(header: Text("Bill total + tip")) {
                    Text("$\(totalPerPerson * Double(numberOfPeople + 2), specifier: "%.2f")")
                }
                
                Section(header: Text("Total per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// Dismiss keyboard when tapped outside

class AnyGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touchedView = touches.first?.view, touchedView is UIControl {
            state = .cancelled

        } else if let touchedView = touches.first?.view as? UITextView, touchedView.isEditable {
            state = .cancelled

        } else {
            state = .began
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       state = .ended
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
}

extension SceneDelegate: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
