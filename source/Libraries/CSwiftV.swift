//
//  CSwiftV.swift
//  CSwiftV
//
//  Created by Daniel Haight on 30/08/2014.
//  Copyright (c) 2014 ManyThings. All rights reserved.
//
//  Refactored by Rafał Kitta
//

import class Foundation.NSCharacterSet


// MARK: - String extension
extension String {
    
    /// Flag indicates if `String` instance is empty or whitespace
    var isEmptyOrWhitespace: Bool {
        return isEmpty || trimmingCharacters(in: .whitespaces) == ""
    }
    
    /// Flag indicates if `String` instance is not empty and is not whitespace
    var isNotEmptyOrWhitespace: Bool {
        return !isEmptyOrWhitespace
    }

}


/// CSV files parser. 
/// Conformes to [RFC4180](http://tools.ietf.org/html/rfc4180#section-2)
///
/// - Note: All data is sored in-memory, do not parse large files.
public class CSwiftV {

    /// The number of columns in the data
    internal let columnCount: Int
    
    /// The headers from the data, an Array of String.
    /// First row of .csv file.
    ///
    /// e.g:
    /// ```
    /// ["Year","Make","Model","Description","Price"]
    /// ```
    public let headers: [String]
    
    /// An array of Dictionaries with the values of each row keyed to the header.
    ///
    /// e.g:
    /// ```
    /// [
    ///     ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
    ///     ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another, description","Price":"4900.00"]
    /// ]
    /// ```
    public let keyedRows: [[String: String]]?
    
    /// An Array of the rows in an Array of String form, equivalent to `keyedRows`, but without the keys
    ///
    /// e.g:
    /// ```
    /// [
    ///     ["1997","Ford","E350","descrition","3000.00"],
    ///     ["1999","Chevy","Venture","another description","4900.00"]
    /// ]
    /// ```
    public let rows: [[String]]
    
    
    /// MARK: - Initializers
    
    /// Creates an instance containing the data extracted from the `stringData` String parameter.
    ///
    /// - Parameters:
    ///   - stringData: The String obtained from reading the csv file.
    ///   - separator:  The separator used in the csv file, defaults to ","
    ///   - headers:    The array of headers from the file. If not included, it will be populated with the ones from the first line
    public init(with stringData: String, separator: String = ",", headers: [String]? = nil) {
        // Parse each line in `stringData`
        var parsedLines = CSwiftV
            .records(from: stringData.replacingOccurrences(of: "\r\n", with: "\n"))
            .map {
                CSwiftV.cells(forRow: $0, separator: separator)
            }
        
        self.headers = headers ?? parsedLines.removeFirst()
        rows = parsedLines
        columnCount = self.headers.count

        let tempHeaders = self.headers
        keyedRows = rows.map { field -> [String: String] in
            var row = [String: String]()
            
            // Only store value which are not empty
            for (index, value) in field.enumerated() where value.isNotEmptyOrWhitespace {
                if index < tempHeaders.count {
                    row[tempHeaders[index]] = value
                }
            }
            return row
        }
    }
    
    /// Creates an instance containing the data extracted from the `stringData` String
    ///
    /// - Parameters:
    ///   - stringData: The string obtained from reading the csv file.
    ///   - headers:    The array of headers from the file. I f not included, it will be populated with the ones from the first line
    ///
    /// - Attention: In this conveniennce initializer, we assume that the separator between fields is ","
    public convenience init(with stringData: String, headers: [String]?) {
        self.init(with: stringData, separator:",", headers:headers)
    }
    
    /// Analizes a row and tries to obtain the different cells contained as an Array of String
    ///
    /// - Parameters:
    ///   - string:    The string corresponding to a row of the data matrix
    ///   - separator: The string that delimites the cells or fields inside the row. Defaults to ","
    /// - Returns: Array of string elements
    internal static func cells(forRow string: String, separator: String = ",") -> [String] {
        return CSwiftV.split(separator, string: string).map { element in
            if let first = element.characters.first, let last = element.characters.last , first == "\"" && last == "\"" {
                let range = element.characters.index(after: element.startIndex) ..< element.characters.index(before: element.endIndex)
                return element[range]
            }
            return element
        }
    }
    
    
    /// Analizes the CSV data as an String, and separates the different rows as an individual String each.
    ///
    /// - Attention: Assumes "\n" as row delimiter, needs to filter string for "\r\n" first
    ///
    /// - Parameter string: The string corresponding the whole data
    /// - Returns: Array of records
    internal static func records(from string: String) -> [String] {
        return CSwiftV.split("\n", string: string).filter { $0.isNotEmptyOrWhitespace }
    }
    
    
    /// Tries to preserve the parity between open and close characters for different formats. Analizes the escape character count to do so
    ///
    /// - Parameters:
    ///   - separator: The string that delimites the cells or fields inside the row.
    ///   - string:    The string corresponding the whole data
    /// - Returns: Array of splitted strings
    private static func split(_ separator: String, string: String) -> [String] {
        func oddNumberOfQuotes(_ string: String) -> Bool {
            return string.components(separatedBy: "\"").count % 2 == 0
        }

        let initial = string.components(separatedBy: separator)
        var merged = [String]()
        for newString in initial {
            guard let record = merged.last , oddNumberOfQuotes(record) == true else {
                merged.append(newString)
                continue
            }
            merged.removeLast()
            let lastElem = record + separator + newString
            merged.append(lastElem)
        }
        return merged
    }

}
