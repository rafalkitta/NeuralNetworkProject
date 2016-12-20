//
//  CrossValidation.swift
//  NeuralNetwork
//
//  Created by Adrian Moczulski on 13.12.2016.
//  Copyright © 2016 Rafal Kitta. All rights reserved.
//

import Foundation


/// Cross validation class
class CrossValidation {
    
    /// Neural network
    var neuralNetwork: NeuralNetwork
    
    /// Heberman`s survival data set
    var dataSet: HebermanSurvivalDataSet
    
    /// Neural network init parameters
    var nnParameters: NeuralNetworkInitParameters
    
    
    /// Default initializer
    ///
    /// - Parameters:
    ///   - neuralNetworkParameters: Neural network init parameters
    ///   - dataSet:                 Heberman`s survival data set
    init(_ neuralNetworkParameters: NeuralNetworkInitParameters, dataSet: HebermanSurvivalDataSet) {
        self.neuralNetwork = NeuralNetwork(withNNInitParameters: neuralNetworkParameters)
        self.dataSet = dataSet
        self.nnParameters = neuralNetworkParameters
    }
    
    
    /// Performs Leave-one-out cross-validation
    ///
    /// - Returns: delta value
    func validate() -> [Double] {
        // the array with diffrences between calculated value and target value
        var deltaValues = [Double]()
        
        // skip index is the index of data set using for validating
        // it's skipped during training
        for skipIndex in 0..<dataSet.samples.count {
            // every test we should use a new Neural Network
            self.neuralNetwork = NeuralNetwork(withNNInitParameters: self.nnParameters)
            
            // data used for validation
            let validationItem = dataSet.samples[skipIndex]
            
            // training loop
            for (i,sample) in dataSource.samples.enumerated() {
                
                // skipping the item usesd for validating
                guard i != skipIndex else { continue }
                neuralNetwork.backPropagate(trainingData: TrainingData(vectorIn: [sample.age, sample.surgeryYear, sample.positiveAuxiliaryNodes], vectorOut: [sample.didSurvive]))
            }
            
            // after training, calculating the results for skipIndex
            let result = neuralNetwork.propagate(trainingData: TrainingData(vectorIn: [validationItem.age, validationItem.surgeryYear, validationItem.positiveAuxiliaryNodes], vectorOut: []))
            
            // appending delta value to the output array
            deltaValues.append(result[0] - validationItem.didSurvive)
        }
        
        return deltaValues
    }
}
