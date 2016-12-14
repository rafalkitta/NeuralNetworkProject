//
//  DataSource.swift
//  NeuralNetwork
//
//  Created by Rafal Kitta on 30/11/2016.
//  Copyright © 2016 Rafal Kitta. All rights reserved.
//

import Foundation


struct HebermanSurvivalDataSet {
    var samples: [HebermanSurvivalSample] = []
    
    init() {
        if let path = Bundle.main.path(forResource: "normalized_data", ofType: "csv") {
            do {
                let straingData = try String(contentsOfFile: path, encoding: .utf8)
                let csv = CSwiftV(with: straingData, separator: ";", headers: [String](repeating: "", count: 5))
                
                // Iterate over csv rows
                for row in csv.rows {
                    let sample = HebermanSurvivalSample(age: Double(row[0])!, surgeryYear: Double(row[1])!, positiveAuxiliaryNodes: Double(row[2])!, didSurvive: Double(row[3])!)
                    samples.append(sample)
                }
                
            } catch {
                print("Error with reading file: \(error)")
            }
        }
    }
}



struct HebermanSurvivalSample {
    var age: Double
    var surgeryYear: Double
    var positiveAuxiliaryNodes: Double
    var didSurvive: Double
}



