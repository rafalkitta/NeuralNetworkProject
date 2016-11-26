//
//  Perceptron.swift
//  NeuralNetwork
//
//  Created by Rafal Kitta on 23/11/2016.
//  Copyright © 2016 Rafal Kitta. All rights reserved.
//

import Foundation


/// Neural network perceptron structure
public struct Perceptron {
    
    // Matrix size
    
    /// Number of `matrix` rows
    public var m: Int = 0
    
    /// Number of `matrix` columns
    public var n: Int = 0
    
    /// Matrix: m x n
    public var matrix: [[Double]] = [[]]
    
    
    /// Default initializer. Creates empty matrixo on given sizes (m x n). 
    ///
    /// - parameter m:            Number of matrix rows
    /// - parameter n:            Number of matrics colums
    /// - parameter defaultValue: Default value of matrix
    ///
    /// - returns: `Perceptron` instance
    public init(m: Int, n: Int, defaultValue: Double = 0.0) {
        self.m = m // rows
        self.n = n // columns
        self.matrix = [[Double]](repeating: [Double](repeating: defaultValue, count: n), count: m)
    }
    
    
    /// Populates matrix with random values from range: -5...5
    public mutating func randomizeMatrix() {
        // Iterate through rows
        for i in 0..<matrix.count {
            // Iterate through columns
            for j in 0..<matrix[i].count {
                matrix[i][j] = Double(arc4random_uniform(10)) - 5.0
            }
        }
    }
}


// MARK: - CustomStringConvertible
extension Perceptron: CustomStringConvertible {
    
    /// Structure instance description format
    public var description: String {
        return "\nrows(m): \(m), colums(n): \(n), \(matrix)"
    }
}


