//
//  Activation.swift
//  NeuralNetwork
//
//  Created by Rafal Kitta on 23/11/2016.
//  Copyright © 2016 Rafal Kitta. All rights reserved.
//

import Foundation


/// Enum of activation functions. To use activation function, use `perform()` method directly on activation fuction.
///
/// Example:
/// ```swift
/// let result = ActivationFunction.Sigmoidal(β: -1, x: 1.2345).perform()
/// ```
///
/// - Unipolar:       Unipolar activation function
/// - Sigmoidal:      Sigmoidal activation function
/// - SigmoidalDeriv: Derivative sigmoidal activation function
/// - Softmax:        Softmax activation function
public enum ActivationFunction {
    
    /// Unipolar activation function
    case Unipolar(a: Double, x: Double)
    
    /// Sigmoidal activation function
    case Sigmoidal(β: Double, x: Double)
    
    /// Derivateve sigmoidal function
    case SigmoidalDeriv(β: Double, x: Double)
    
    /// Softmax function.
    /// Calculates e^x / ∑(e^xi). In denominator is sum of e to the power of each value in vector.
    case Softmax(vector: [Double], x: Double)
    
    
    /// Perform specific activation function on given parameters
    ///
    /// - returns: Result of activation process
    public func perform() -> Double {
        switch self {
        case .Unipolar(let a, let x):
            return x >= a ? 1.0 : 0.0
            
        case .Sigmoidal(let β, let x):
            return 1 / (1 + pow(M_E, (-1) * β * x))
            
        case .SigmoidalDeriv(_, let x):
            return x * (1 - x)
            
        case .Softmax(let vector, let x):
            let denominator = vector
                .map { pow(M_E, $0) }
                .reduce(0, +)
            return pow(M_E, x) / denominator
        }
    }
}



