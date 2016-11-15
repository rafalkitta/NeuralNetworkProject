//: Playground - noun: a place where people can play

// https://docs.google.com/spreadsheets/d/1MvN26jmL0nDYLbBryRWuqoJht7f45-7En-0RenmmpBg/edit#gid=0

// Fix multiplications:
// http://pastebin.com/Z0QV3YSf


import Foundation


///
struct TrainingData {
    var vectorIn: [Double] = []
    var vectorOut: [Double] = []
}


///
class NeuralNetwork {
    var trainingData: [TrainingData] = []
    
    var layers: [Layer] = []
    
    var sizeIn: Int = 0
    var sizeOut: Int = 0
    
    
    static let unipolarFunc: (_ a: Double, _ x: Double, _ deriv: Bool) -> (Double) = { (a, x, _) in
        return x >= a ? 1 : 0
    }
    
    static let sigmoidalFunc: (_ β: Double, _ x: Double, _ deriv: Bool) -> (Double) = { (β, x, deriv) in
        if deriv == true {
            return x * (1 - x)
        }
        return 1 / (1 + pow(M_E, (-1) * β * x)) // β should be -1 !!!
    }
    
    
    init (sizeIn: Int, sizeOut: Int) {
        self.sizeIn = sizeIn
        self.sizeOut = sizeOut
        
        // Append first layer, initially empty - start
        self.layers.append(Layer(perceptron: Perceptron(m: 0, n: sizeIn, activateFunc: NeuralNetwork.sigmoidalFunc)))
        
        // Append last layer -
        self.layers.append(Layer(perceptron: Perceptron(m: sizeIn, n: sizeOut, activateFunc: NeuralNetwork.sigmoidalFunc)))
        
    }
    
    
    func appendLayer(n: Int) {
        var newLayers: [Layer] = []
        var last = 0
        
        // Rewrite all layers except last one
        for i in 0..<(layers.count - 1) {
            newLayers.append(layers[i])
            last = layers[i].perceptron.n
        }
        
        // Insert new layer
        newLayers.append(Layer(perceptron: Perceptron(m: last, n: n, activateFunc: NeuralNetwork.sigmoidalFunc)))
        newLayers.append(Layer(perceptron: Perceptron(m: n, n: sizeOut, activateFunc: NeuralNetwork.sigmoidalFunc)))
        layers = newLayers
    }
    
    
    func propagate(trainingData: TrainingData) -> [Double] {
        var vector: [Double] = trainingData.vectorIn
        
        for i in 0..<layers.count {
            // Ommit first layer
            guard i != 0 else { continue }
            
            // Multiply
            let matrixA = [vector]
            let matrixB = layers[i].perceptron.matrix
            
            // Multiply vectr (as one-dimentional matrix) with i-th layer
            let multiplicationResult = multiplyMatrixes(a: matrixA, b: matrixB)
            // Slice first row in result matrix
            vector = multiplicationResult[0]
            
            // Last layer
//            guard i != layers.count - 1 else { break }
            
            // Activate func
            vector = layers[i].perceptron.performActivateFunction(onVector: vector, -1.0, false)
            layers[i].values = vector
        }
        
        return vector
    }
    
    
    func calculateError(trainingData: TrainingData) -> [Double] {
        let y = trainingData.vectorOut
        let ysim = propagate(trainingData: trainingData)
        return zip(y, ysim).map { $0 - $1 }
        
    }
    
    func backPropagate(trainingData: TrainingData) {
        var error = calculateError(trainingData: trainingData)
        let layersCount = layers.count - 1
        
        for i in 0..<layersCount {
            let activatedValuesMatix = layers[layersCount - i].perceptron.performActivateFunction(onVector: layers[layersCount - i].values, -1.0, true)
            
            let delta = zip(error, activatedValuesMatix).map { $0 * $1 }
            
            let transposedPerceptronMatrix = transpose(input: layers[layersCount - i].perceptron.matrix)
            error = multiplyMatrixes(a: [delta], b: transposedPerceptronMatrix)[0]
            
            let matrix1 = layers[layersCount - i].perceptron.matrix
            let matrix2 = multiplyMatrixes2(a: [layers[layersCount - i - 1].values], b: transpose(input: [delta]))
            layers[layersCount - i].perceptron.matrix = matrixDifferences(a: matrix1, b: transpose(input: matrix2))
        }
    }
    
    private func multiplyMatrixes(a: [[Double]], b: [[Double]]) -> [[Double]] {
        let r1 = a.count
        let r2 = b.count
        let c1 = a[0].count
        let c2 = b[0].count
        guard c1 == r2 else {
            print("Try to mulitiply matixes: (\(r1)x\(c1) * \(r2)x\(c2))")
            return [[]]
        }
        
        var result: [[Double]] = [[Double]](repeating: [Double](repeating: Double(), count: c2), count: r1)
        
        for i in 0..<r1 {
            for j in 0..<c2 {
                for k in 0..<c1 {
                    result[i][j] += a[i][k] * b[k][j]
                }
            }
        }
        
        return result
    }
    
    // like * in Python
    // 1x5 * 3x1 = 3x5
    private func multiplyMatrixes2(a: [[Double]], b: [[Double]]) -> [[Double]] {
//        let r1 = a.count
        let r2 = b.count
        let c1 = a[0].count
//        let c2 = b[0].count
//        print("Try to multiply matixes(2): (\(r1)x\(c1) * \(r2)x\(c2))")
        
        var result: [[Double]] = [[Double]](repeating: [Double](repeating: Double(), count: c1), count: r2)
        
        for i in 0..<r2 {
            for j in 0..<c1 {
                result[i][j] = a[0][j] * b[i][0]
            }
        }
        
        return result
    }
    
    private func matrixDifferences(a: [[Double]], b: [[Double]]) -> [[Double]] {
        let r1 = a.count
        let r2 = b.count
        let c1 = a[0].count
        let c2 = b[0].count
        guard c1 == c2 && r1 == r2 else {
            print("Try to difference matixes: (\(r1)x\(c1) * \(r2)x\(c2))")
            return [[]]
        }
        
        var result: [[Double]] = [[Double]](repeating: [Double](repeating: Double(), count: c1), count: r1)
        
        for i in 0..<r1 {
            for j in 0..<c1 {
                result[i][j] = a[i][j] - b[i][j]
            }
        }
        
        return result
    }
    
    private func transpose<T>(input: [[T]]) -> [[T]] {
        if input.isEmpty { return [[T]]() }
        let count = input[0].count
        var out = [[T]](repeating: [T](), count: count)
        for outer in input {
            for (index, inner) in outer.enumerated() {
                out[index].append(inner)
            }
        }
        
        return out
    }
}

extension NeuralNetwork: CustomStringConvertible {
    var description: String {
        return "\(layers)"
    }
}


///
struct Perceptron {
    typealias ActivateFunction = ((_ param1: Double, _ param2: Double, _ deriv: Bool) -> (Double))
    
    var m: Int = 0
    var n: Int = 0
    var matrix: [[Double]] = [[]]
    var activateFunc: ActivateFunction
    
    
    init(m: Int, n: Int, defaultValue: Double = 0.0, activateFunc: ActivateFunction) {
        self.m = m // rows
        self.n = n // columns
        self.matrix = [[Double]](repeating: [Double](repeating: defaultValue, count: n), count: m)
        self.activateFunc = activateFunc
    }
    
    mutating func randomizeMatrix() {
        for i in 0..<matrix.count {
            for j in 0..<matrix[i].count {
                matrix[i][j] = Double(arc4random_uniform(10)) - 5.0
            }
        }
    }
    
    func performActivateFunction(onVector vector: [Double], _ param1: Double, _ deriv: Bool) -> [Double] {
        var returnVector = vector
        // For all vector elements
        for i in 0..<vector.count {
            returnVector[i] = activateFunc(param1, vector[i], deriv)
        }
        return returnVector
    }
}

extension Perceptron: CustomStringConvertible {
    var description: String {
        return "\nrows(m): \(m), colums(n): \(n), \(matrix)"
    }
}


///
struct Layer {
    var perceptron: Perceptron
    lazy var values: [Double] = [Double](repeating: Double(), count: self.perceptron.n)
    
    init(perceptron: Perceptron) {
        self.perceptron = perceptron
        self.perceptron.randomizeMatrix()
    }
}

extension Layer: CustomStringConvertible {
    var description: String {
        return "\(perceptron)"
    }
}


// Create neural network instance
let neuralNetwork = NeuralNetwork(sizeIn: 3, sizeOut: 3)
//print(neuralNetwork.layers)

// Add layer with 5 columns
neuralNetwork.appendLayer(n: 5)
//print(neuralNetwork.layers)


// Back propagate
for i in 0..<500 {
    neuralNetwork.backPropagate(trainingData: TrainingData(vectorIn: [3, 4, 5], vectorOut: [0.1, 0.2, 0.3]))
}

neuralNetwork.propagate(trainingData: TrainingData(vectorIn: [3, 4, 5], vectorOut: []))





