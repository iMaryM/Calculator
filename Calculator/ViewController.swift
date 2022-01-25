//
//  ViewController.swift
//  Calculator
//
//  Created by Мария Манжос on 23.01.22.
//

enum Operations {
    case plus
    case minus
    case multiplication
    case division
    case none
    
    static func convertToOperation (from buttonTitle: String) -> Operations {
        switch buttonTitle {
        case "+":
            return .plus
        case "-":
            return .minus
        case "x":
            return .multiplication
        case "/":
            return .division
        default:
            return .none
        }
    }
}

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var enterNumberLabel: UILabel!
    var isDoubleNumber = false
    var firstNumber: Double?
    var secondNumber: Double?
    var result: Double?
    var operation: Operations = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func enterNumber(_ sender: UIButton) {
        
        guard let titleLabelText = sender.titleLabel?.text,
              let labelText = enterNumberLabel.text,
              labelText.count < 9 else {
            return
        }
        
        if result != nil || labelText == "Error" {
            enterNumberLabel.text = "0"
            result = nil
        }
        
        let numberText = enterNumberLabel.text ?? ""
        
        if enterNumberLabel.text == "0" {
            if titleLabelText == ",", !isDoubleNumber {
                enterNumberLabel.text  = numberText + titleLabelText
                isDoubleNumber = true
            } else {
                enterNumberLabel.text = titleLabelText
            }
        } else {
            if titleLabelText != "," {
                enterNumberLabel.text  = numberText + titleLabelText
            } else if titleLabelText == ",", !isDoubleNumber {
                enterNumberLabel.text  = numberText + titleLabelText
                isDoubleNumber = true
            }
        }
        
        if operation != .none {
            secondNumber = convertStringToDouble(str: enterNumberLabel.text ?? "")
        }
    }
    
    @IBAction func operationAction(_ sender: UIButton) {
        
        guard let buttonTitle = sender.titleLabel?.text else {
            return
        }
        
        operation = Operations.convertToOperation(from: buttonTitle)
  
        if operation != .none {
            firstNumber = convertStringToDouble(str: enterNumberLabel.text ?? "")
            enterNumberLabel.text = ""
            isDoubleNumber = false
        }
        
    }
    
    @IBAction func showResult(_ sender: UIButton) {
        
        guard let firstNumber = firstNumber,
              let secondNumber = secondNumber else {
            return
        }

        switch operation {
        case .plus:
            result = firstNumber + secondNumber
        case .minus:
            result = firstNumber - secondNumber
        case .multiplication:
            result = firstNumber * secondNumber
        case .division:
            if secondNumber != 0 {
                result = firstNumber / secondNumber
            } else {
                enterNumberLabel.text = "Error"
            }
        case .none:
            break
        }
        
        operation = .none
        
        if let resultText = result {
            if isDoubleNumber(number: resultText) {
                var str: String = ""
                for char in String(resultText) {
                    if char == "." {
                        str += ","
                    } else {
                        str += String(char)
                    }
                }
                enterNumberLabel.text = "\(str)"
            } else {
                enterNumberLabel.text = "\(Int(resultText))"
            }
        }
        
        isDoubleNumber = false
    
    }
    
    @IBAction func clearAction(_ sender: UIButton) {
        clear()
    }
    
    func clear () {
        enterNumberLabel.text = "0"
        isDoubleNumber = false
        operation = .none
    }
    
    func convertStringToDouble (str: String) -> Double {
        var tempString = ""
        var newDouble: Double
        for char in str {
            if char == "," {
                tempString += "."
            } else {
                tempString += String(char)
            }
        }
        
        newDouble = Double(tempString) ?? 0.0
        return newDouble
    }
    
    func isDoubleNumber (number: Double) -> Bool {
        
        if number - Double(Int(number)) == 0 {
            return false
        }
        
        return true
    }
    
}

