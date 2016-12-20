//
//  DataSource.swift
//  NeuralNetwork
//
//  Created by Rafal Kitta on 30/11/2016.
//  Copyright © 2016 Rafal Kitta. All rights reserved.
//

import Foundation


/// Struct represents data set of Haberman’s survival data.
/// Creating instance of `HebermanSurvivalDataSet` is eqivalent to reading `normalized_data.csv` file and parsing data 
/// from this file into Array of `HebermanSurvivalSample` models.
public struct HebermanSurvivalDataSet {
    
    /// Array of `HebermanSurvivalSample` objects. 
    /// Contains objects parsed from `normalized_data.csv` file.
    public let samples: [HebermanSurvivalSample]
    
    
    /// Default initializer.
    /// Reads data from `normalized_data.csv` file, parses them into `HebermanSurvivalSample` objects and populates 
    /// `samples` property.
    ///
    /// - Note: If file `normalized_data.csv` is not reachable or parsable, prints error in default output, `samples`
    ///     property leaves empty.
    init() {
        guard let path = Bundle.main.path(forResource: "normalized_data", ofType: "csv") else {
            print("Error with finding path to normalized_data.csv file")
            self.samples = []
            return
        }

        do {
            let straingData = try String(contentsOfFile: path, encoding: .utf8)
            let csv = CSwiftV(with: straingData, separator: ";", headers: [String](repeating: "", count: 5))
            var samples: [HebermanSurvivalSample] = []
            
            // Iterate over csv rows
            for row in csv.rows {
                let sample = HebermanSurvivalSample(age: Double(row[0])!, surgeryYear: Double(row[1])!, positiveAuxiliaryNodes: Double(row[2])!, didSurvive: Double(row[3])!)
                samples.append(sample)
            }
            
            self.samples = samples
            
        } catch {
            self.samples = []
            print("Error with reading file: \(error)")
        }
    }
}


/// Structure represents single sample of Heberman's survival data. Describes singe sample of `HebermanSurvivalDataSet`.
/// Contains informations about patient age, surgery year, number of positive axillary nodes detected and flag determines 
/// if patient survived 5 yeares or longer.
public struct HebermanSurvivalSample {
    
    /// Age of patient at time of operation
    var age: Double
    
    /// Patient's year of surgery (year - 1900)
    var surgeryYear: Double
    
    /// Number of positive axillary nodes detected
    var positiveAuxiliaryNodes: Double
    
    /// Flag indicates that patient survived 5 yeares or longer
    var didSurvive: Double
}



