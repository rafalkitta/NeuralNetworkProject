//
//  NeuralNetwork.swift
//  NeuralNetwork
//
//  Created by Rafal Kitta on 23/11/2016.
//  Copyright © 2016 Rafal Kitta. All rights reserved.
//

import Foundation


/// Neural network
public class NeuralNetwork {
    
    /// Trainig data
    private var trainingData: [TrainingData] = []
    
    /// Layers array. Settable only via `appendLayer(n: Int)` method
    public var layers: [Layer] = []
    
    /// Input size
    public var sizeIn: Int = 0
    
    /// Output size
    public var sizeOut: Int = 0
    
    
    /// Default initializer
    ///
    /// - parameter sizeIn:  Input size
    /// - parameter sizeOut: Output size
    ///
    /// - returns: `NeuralNetwork` instance
    public init(sizeIn: Int, sizeOut: Int) {
        // Store sizes
        self.sizeIn = sizeIn
        self.sizeOut = sizeOut
        
        // Append first layer, initially empty - start
        self.layers.append(Layer(perceptron: Perceptron(rows: 0, columns: sizeIn)))
        
        // Append last layer -
        self.layers.append(Layer(perceptron: Perceptron(rows: sizeIn, columns: sizeOut)))
    }
    
    
    /// Appends new layer to `layers` variable. New layer is inserted to pre-last position in `layers` array.
    /// Sets layer's perceptrons to appropriate sizes.
    ///
    /// - parameter n: New `Layer` instance
    public func appendLayer(n: Int) {
        var newLayers: [Layer] = []
        var last = 0
        
        // Rewrite all layers except last one
        for i in 0..<(layers.count - 1) {
            newLayers.append(layers[i])
            last = layers[i].perceptron.columns
        }
        
        // Insert new layer
        newLayers.append(Layer(perceptron: Perceptron(rows: last, columns: n)))
        newLayers.append(Layer(perceptron: Perceptron(rows: n, columns: sizeOut)))
        
        // Store new layers array
        layers = newLayers
    }
    
    
    /// Performes propagation on training data.
    ///
    /// - parameter trainingData: Trainig data
    ///
    /// - returns: Result vector of propagation
    public func propagate(trainingData: TrainingData) -> [Double] {
        // Input vector from training data
        var vector: [Double] = trainingData.vectorIn
        
        // Iterate through layers
        for i in 0..<layers.count {
            // Ommit first layer
            guard i != 0 else { continue }
            
            // Multiply
            let matrixA = [vector]
            let matrixB = layers[i].perceptron.matrix
            
            // Multiply vector (as one-dimentional matrix) with i-th layer
            let multiplicationResult = multiplyMatrixes(a: matrixA, b: matrixB)
            // Slice first row in result matrix
            vector = multiplicationResult[0]
            
            // Perform activate function
            vector = vector.map { ActivationFunction.Sigmoidal(β: -1, x: $0).perform() }
            layers[i].values = vector
        }
        
        return vector
    }
    
    
    /// Calculates error.
    ///
    /// - parameter trainingData: Training data
    ///
    /// - returns: Error vector
    private func calculateError(trainingData: TrainingData) -> [Double] {
        // Output vector from training data
        let y = trainingData.vectorOut
        // Propagation result on traning data
        let ysim = propagate(trainingData: trainingData)
        // Vectors difference
        return zip(y, ysim).map { $0 - $1 }
        
    }
    
    
    /// Performes back propagation on training data.
    ///
    /// - parameter trainingData: Training data
    public func backPropagate(trainingData: TrainingData) {
        // Calculate error
        var error = calculateError(trainingData: trainingData)
        let layersCount = layers.count - 1
        
        // Iterates through layers, except last one
        for i in 0..<layersCount {
            // Performing activation function on layers values matrix
            let activatedValuesMatix = layers[layersCount - i].values.map { ActivationFunction.SigmoidalDeriv(β: -1, x: $0).perform() }
            
            // Vectors multiplication
            let delta = zip(error, activatedValuesMatix).map { $0 * $1 }
            
            let transposedPerceptronMatrix = transpose(input: layers[layersCount - i].perceptron.matrix)
            error = multiplyMatrixes(a: [delta], b: transposedPerceptronMatrix)[0]
            
            let matrix1 = layers[layersCount - i].perceptron.matrix
            let matrix2 = multiplyMatrixes2(a: [layers[layersCount - i - 1].values], b: transpose(input: [delta]))
            layers[layersCount - i].perceptron.matrix = matrixDifferences(a: matrix1, b: transpose(input: matrix2))
        }
    }
}


// MARK: - Initializer with NeuralNetworkInitParameters
extension NeuralNetwork {
    
    /// Convenience initializer
    /// Allows to initialize `NeuralNetwork` instance with `NeuralNetworkInitParameters` object.
    ///
    /// - Parameter initParameters: All init parameters in single object
    convenience init(withNNInitParameters initParameters: NeuralNetworkInitParameters) {
        self.init(sizeIn: initParameters.sizeIn, sizeOut: initParameters.sizeOut)
        
        for layerSize in initParameters.layersSizes {
            self.appendLayer(n: layerSize)
        }
    }
}


/// Structure contains `NuralNetwork` init parameters, all required to properly create `NeuralNetwork` instance
struct NeuralNetworkInitParameters {
    
    /// Input layer vector size
    let sizeIn: Int
    
    /// Output layer vector size
    let sizeOut: Int
    
    /// Hidden layers sizes
    let layersSizes: [Int]
}


// MARK: - CustomStringConvertible
extension NeuralNetwork: CustomStringConvertible {
    
    /// Class instance description format
    public var description: String {
        return "\(layers)"
    }
}

