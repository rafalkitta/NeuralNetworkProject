//
//  main.swift
//  NeuralNetwork
//
//  Created by Rafal Kitta on 23/11/2016.
//  Copyright © 2016 Rafal Kitta. All rights reserved.
//

import Foundation


// 
let dataSource = HebermanSurvivalDataSet()


// Create neural network instance
let neuralNetwork = NeuralNetwork(sizeIn: 3, sizeOut: 2)

// Add layer with 5 columns
neuralNetwork.appendLayer(n: 5)


// Back propagate
for sample in dataSource.samples {
    neuralNetwork.backPropagate(trainingData: TrainingData(vectorIn: [sample.age, sample.surgeryYear, sample.positiveAuxiliaryNodes], vectorOut: [sample.died, sample.survive]))
}


// 0.509433962264151;0.272727272727273;0.961538461538462;0;1
let result = neuralNetwork.propagate(trainingData: TrainingData(vectorIn: [0.509433962264151, 0.272727272727273, 0.961538461538462], vectorOut: []))

print("Result: \(result)")


