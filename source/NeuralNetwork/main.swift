//
//  main.swift
//  NeuralNetwork
//
//  Created by Rafal Kitta on 23/11/2016.
//  Copyright © 2016 Rafal Kitta. All rights reserved.
//

import Foundation


// Create neural network instance
let neuralNetwork = NeuralNetwork(sizeIn: 3, sizeOut: 3)

// Add layer with 5 columns
neuralNetwork.appendLayer(n: 5)


// Back propagate
for i in 0..<1000 {
    neuralNetwork.backPropagate(trainingData: TrainingData(vectorIn: [3, 4, 5], vectorOut: [0.1, 0.2, 0.3]))
}

let result = neuralNetwork.propagate(trainingData: TrainingData(vectorIn: [3, 4, 5], vectorOut: []))

print("Result: \(result)")


