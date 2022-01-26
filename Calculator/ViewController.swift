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
        
        var numberText = labelText
        
        if result != nil || labelText == "Error" {
            enterNumberLabel.text = "0"
            result = nil
        }
        
        if operation != .none && secondNumber == nil {
            enterNumberLabel.text  = "0"
        }
        
        numberText = enterNumberLabel.text ?? ""
        
        if enterNumberLabel.text == "0" {
            if titleLabelText == ",", (numberText.filter({$0 == ","}).count < 1) {
                enterNumberLabel.text  = numberText + titleLabelText
            } else {
                enterNumberLabel.text = titleLabelText
            }
        } else {
            if titleLabelText != "," {
                enterNumberLabel.text  = numberText + titleLabelText
            } else if titleLabelText == ",", (numberText.filter({$0 == ","}).count < 1) {
                enterNumberLabel.text  = numberText + titleLabelText
            }
        }
        
        if operation != .none {
            secondNumber = convertStringToDouble(enterNumberLabel.text)
        } else {
            firstNumber = convertStringToDouble(enterNumberLabel.text)
        }
    
    }
    
    @IBAction func operationAction(_ sender: UIButton) {
        
        guard let buttonTitle = sender.titleLabel?.text else {
            return
        }
        
        operation = Operations.convertToOperation(from: buttonTitle)
        
    }
    
    @IBAction func showResult(_ sender: UIButton) {
        
        guard let firstNumberO = firstNumber,
              let secondNumberO = secondNumber else {
            return
        }

        switch operation {
        case .plus:
            result = firstNumberO + secondNumberO
        case .minus:
            result = firstNumberO - secondNumberO
        case .multiplication:
            result = firstNumberO * secondNumberO
        case .division:
            if secondNumber != 0 {
                result = firstNumberO / secondNumberO
            } else {
                enterNumberLabel.text = "Error"
            }
        case .none:
            break
        }
        
        operation = .none
        
        guard let result = result else {
            return
        }

        let resultDecimal = Decimal(result)
        
        if isDoubleNumber(result) {
            let newString = resultDecimal.formatted().replacingOccurrences(of: ".", with: ",")
            enterNumberLabel.text = "\(newString)"
        } else {
            enterNumberLabel.text = "\(Int(result))"
        }
        
        secondNumber = nil
        firstNumber = result
    
    }
    
    @IBAction func clearAction(_ sender: UIButton) {
        clear()
    }
    
    func clear () {
        enterNumberLabel.text = "0"
        firstNumber = nil
        secondNumber = nil
        result = nil
        operation = .none
    }
    
    func convertStringToDouble (_ value: String?) -> Double? {
        
        guard let stringValue = value else {
            return nil
        }
        
        let tempString = stringValue.replacingOccurrences(of: ",", with: ".")
        
        return Double(tempString)
    }
    
    func isDoubleNumber (_ number: Double) -> Bool {
        
        return !(number.truncatingRemainder(dividingBy: 1) == 0)
    }
    
}

