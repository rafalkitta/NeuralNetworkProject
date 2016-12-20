//
//  Layer.swift
//  NeuralNetwork
//
//  Created by Rafal Kitta on 23/11/2016.
//  Copyright © 2016 Rafal Kitta. All rights reserved.
//

import Foundation


/// Neural network layer structure
public struct Layer {
    
    /// Perceptron
    public var perceptron: Perceptron
    
    /// Values vector with values count equal to perceptron culumns number
    ///
    /// - Note: Defaultly initialized with values: 0.0
    public lazy var values: [Double] = [Double](repeating: Double(), count: self.perceptron.columns)
    
    
    /// Defult initializer
    ///
    /// - parameter perceptron: `Perceptron` instance
    ///
    /// - returns: `Layer` instance
    public init(perceptron: Perceptron) {
        // Store perceptron
        self.perceptron = perceptron
        // Randomize perceptron values with range -5...5
        self.perceptron.randomizeMatrix()
    }
}


// MARK: - CustomStringConvertible
extension Layer: CustomStringConvertible {
    
    /// Structure instance description format
    public var description: String {
        return "\(perceptron)"
    }
}

