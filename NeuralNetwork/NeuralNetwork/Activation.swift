//
//  Activation.swift
//  NeuralNetwork
//
//  Created by Rafal Kitta on 23/11/2016.
//  Copyright © 2016 Rafal Kitta. All rights reserved.
//

import Foundation


/// Enum of activation functions
///
/// - Unipolar:       Unipolar activation function
/// - Sigmoidal:      Sigmoidal activation function
/// - SigmoidalDeriv: Derivative sigmoidal activation function
enum ActivationFunction {
    
    case Unipolar(a: Double, x: Double)
    
    case Sigmoidal(β: Double, x: Double)
    
    case SigmoidalDeriv(β: Double, x: Double)
    
    
    /// Perform specific activation function on given parameters
    ///
    /// - returns: Result of activation process
    func perform() -> Double {
        switch self {
        case .Unipolar(let a, let x):
            return x >= a ? 1.0 : 0.0
            
        case .Sigmoidal(let β, let x):
            return 1 / (1 + pow(M_E, (-1) * β * x))
            
        case .SigmoidalDeriv(_, let x):
            return x * (1 - x)
        }
    }
}



