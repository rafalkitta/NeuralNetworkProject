//
//  MathHelpers.swift
//  NeuralNetwork
//
//  Created by Rafal Kitta on 23/11/2016.
//  Copyright © 2016 Rafal Kitta. All rights reserved.
//

import Foundation


// MARK: - Math helper methodes

/// Normal mtrixes multiplication - matrix product.
/// If `a` is an n × m matrix and `b` is an m × p matrix, their matrix product `ab` is an n × p matrix, in which the m 
/// entries across a row of `a` are multiplied with the m entries down a columns of `b` and summed to produce an entry 
/// of `ab`.
///
/// - Note: Parameters order does matter.
///
/// - parameter a: First matrix to multiplication
/// - parameter b: Second matrix to multiplication
///
/// - returns: Result of given matrixes multiplication
public func multiplyMatrixes(a: [[Double]], b: [[Double]]) -> [[Double]] {
    // Matrixes sizes
    let aRowsNumber = a.count
    let bRowsNumber = b.count
    let aColumnsNumber = a[0].count
    let bColumnsNumber = b[0].count
    
    // Guard parametr matrixes sizes. For `a` m x n and `b` k x l, n and k should be equal.
    guard aColumnsNumber == bRowsNumber else {
        print("Try to mulitiply matixes: (\(aRowsNumber)x\(aColumnsNumber) * \(bRowsNumber)x\(bColumnsNumber))")
        return [[]]
    }
    
    // Creates result matrix in size `aRowsNumber` x `bColumnsNumber`. Initialize it with 0.0 values.
    var result: [[Double]] = [[Double]](repeating: [Double](repeating: Double(), count: bColumnsNumber), count: aRowsNumber)
    
    // Multiplication
    for i in 0..<aRowsNumber {
        for j in 0..<bColumnsNumber {
            for k in 0..<aColumnsNumber {
                result[i][j] += a[i][k] * b[k][j]
            }
        }
    }
    
    return result
}


/// Matrix multiplication like "*" in Python. Each value from `a` matrix is multiplyed by value in exactly the same 
/// position in `b` matrix.
///
/// - Note: Result size:
/// 1x5 * 3x1 = 3x5
///
/// - parameter a: First matrix to multiplication
/// - parameter b: Second matrix to multiplication
///
/// - returns: Result of given matrixes multiplication
public func multiplyMatrixes2(a: [[Double]], b: [[Double]]) -> [[Double]] {
    // Matrixes sizes
    let bRowsNumber = b.count
    let aColumnsNumber = a[0].count
    
    // Creates result matrix in size `bRowsNumber` x `aColumnsNumber`. Initialize it with 0.0 values.
    var result: [[Double]] = [[Double]](repeating: [Double](repeating: Double(), count: aColumnsNumber), count: bRowsNumber)
    
    // Iterate through `b` rows
    for i in 0..<bRowsNumber {
        // Iterate through `a` columns
        for j in 0..<aColumnsNumber {
            // Multiply values on the same position in both matrixes
            result[i][j] = a[0][j] * b[i][0]
        }
    }
    
    return result
}



/// Matrix difference
///
/// - parameter a: First matrix
/// - parameter b: Second matrix
///
/// - returns: Result of given matrixes difference
public func matrixDifferences(a: [[Double]], b: [[Double]]) -> [[Double]] {
    // Matrixes sizes
    let aRowsNumber = a.count
    let bRowsNumber = b.count
    let aColumnsNumber = a[0].count
    let bColumnsNumber = b[0].count
    
    // Guard matrixes of exactly the same sizes
    guard aColumnsNumber == bColumnsNumber && aRowsNumber == bRowsNumber else {
        print("Try to difference matixes: (\(aRowsNumber)x\(aColumnsNumber) * \(bRowsNumber)x\(bColumnsNumber))")
        return [[]]
    }
    
    // Creates result matrix in size `aRowsNumber` x `aColumnsNumber`. Initialize it with 0.0 values.
    var result: [[Double]] = [[Double]](repeating: [Double](repeating: Double(), count: aColumnsNumber), count: aRowsNumber)
    
    // Iterate through rows
    for i in 0..<aRowsNumber {
        // Iterate through columns
        for j in 0..<aColumnsNumber {
            // Difference of values on the same position in both matrixes
            result[i][j] = a[i][j] - b[i][j]
        }
    }
    
    return result
}


// MARK: - Matrix


/// Matrix transposition. Generic method. 
/// Writes rows of given matrix as a columns.
///
/// - parameter input: Matrix to transpose
///
/// - returns: Transposed matrix
public func transpose<T>(input: [[T]]) -> [[T]] {
    // Guard empty input
    guard !input.isEmpty else { return [[T]]() }
    
    let inputColumsNumber = input[0].count
    
    // Creates result matrix in changed size
    var result = [[T]](repeating: [T](), count: inputColumsNumber)
    
    // Iterate through rows
    for outer in input {
        // Iterate through columns
        for (index, inner) in outer.enumerated() {
            result[index].append(inner)
        }
    }
    
    return result
}



