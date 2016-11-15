import Foundation

// podstawowe funkcje
public func actSigmUnipolar (x:Double) -> Double { return  1.0 / ( 1 + pow(M_E,-1 * x)) }
public func detSigmUnipolar (x:Double) -> Double { return  actSigmUnipolar(x: x) * (1 - actSigmUnipolar(x: x)) }

public func actUnipolar(x:Double) -> Double { if x<0.5 { return 0 } else {return 1 } }
public func randomW()->Double { return Double(Float(arc4random()) / Float(UINT32_MAX)) }

// wykorzystywana funkcja aktywacji
func activationFunction(x: Double) -> Double {
    //return actUnipolar(x: x)
    return actSigmUnipolar(x: x)
}

// podstawowe struktury
// wstaw komentarz
class Perceptron {
    var inputs = [Double]()
    var weights : [Double] {
        get {
            while _weights.count < inputs.count {
                let random = randomW()
                _weights.append(random)
            }
            return _weights
        }
        set (data){
            self._weights = data
        }
    }
    private var _weights = [Double]()
    var output : Double {
        get {
            var output = 0.0
            for (iWeight,weight) in weights.enumerated() {
                output += weight * inputs[iWeight]
            }
            return actSigmUnipolar(x: output)
        }
    }
    var weightedSum : Double {
        get {
            var output = 0.0
            for (iWeight, weight) in weights.enumerated() {
                output += weight * inputs[iWeight]
            }
            return output
        }
    }
}
// wstaw komentarz
class Layer {
    init (perceptrons: [Perceptron]) {
        self.perceptrons = perceptrons
    }
    var isFirstLayer = false
    var perceptrons = [Perceptron]()
    var input : [Double] {
        set (data) {
            for i in 0..<perceptrons.count {
                perceptrons[i].inputs = data
            }
        }
        get {
            return perceptrons.last!.inputs
        }
    }
    
    var output : [Double] {
        get {
            var output = [Double]()
            for perceptron in perceptrons {
                output.append(perceptron.output)
            }
            if !self.isFirstLayer {
                return output
            } else {
                return self.perceptrons.first!.inputs
            }
        }
    }
}

// wstaw komentarz
class NeuralNetwork {
    var layers = [Layer]()
    init(createSizedNetwork sizes: [Int]) {
        for layer in sizes {
            var perceptrons = [Perceptron]()
            for _ in 1...layer {
                perceptrons.append(Perceptron())
            }
            layers.append(Layer(perceptrons: perceptrons))
        }
    }
    
    var output : Double? {
        get {
            populate()
            return layers.last!.output.last!
        }
    }
    
    var input : [Double] {
        get {
            return layers[0].input
        }
        set(data) {
            if data.count == layers[0].perceptrons.count {
                layers[0].input = data
                layers[0].isFirstLayer = true
            }
        }
    }
    
    func populate() {
        for i in 1..<self.layers.count {
            layers[i].input = layers[i-1].output
        }
    }
    func calculate(data: [Double]) {
        self.input = data
    }
    
    func train(input: [Double], realOutput: Double) {
        // obliczanie błędu
        self.input = input
        let calculatedOutput = self.output
        let outputSumMarginOfError = realOutput - calculatedOutput!
        
        
        // propagacja wstecz (warstwa ukryta)
        
        let deltaOutputSum = detSigmUnipolar(x: self.layers.last!.perceptrons[0].weightedSum) * outputSumMarginOfError
        let hiddenLayerResults = self.layers[1].output
        let hiddenToOuterWeights = self.layers.last!.perceptrons.last!.weights
        
        for (i,hiddenLayerResult) in hiddenLayerResults.enumerated() {
            let deltaWeight = deltaOutputSum / hiddenLayerResult
            self.layers.last!.perceptrons[0].weights[i] += deltaWeight
        }
        
        // propagacja wstecz (warstwa wejściowa)
        for (i, hiddenToOuterWeight) in hiddenToOuterWeights.enumerated() {
            let deltaHiddenSum = deltaOutputSum / hiddenToOuterWeight * detSigmUnipolar(x: self.layers[1].perceptrons[i].weightedSum)
            
            for (j, singleInput) in self.input.enumerated() {
                let deltaWeight = deltaHiddenSum / singleInput
                self.layers[1].perceptrons[i].weights[j] += deltaWeight
            }
        }
    }
}

struct TrainigSet {
    var trainingData : [TrainingData]
    mutating func normalizeDataStandard() {
        var maxY = trainingData[0].y
        var minY = trainingData[0].y
        for element in trainingData {
            if maxY < element.y { maxY = element.y }
            if minY > element.y { minY = element.y }
        }
        let space = fabs(maxY) + fabs(minY)
        
        for i in 0..<trainingData.count {
            trainingData[i].scaledY = trainingData[i].y / space - minY/space
        }
    }
}

struct TrainingData {
    var x : [Double]
    var y : Double
    var scaledY : Double
}

var nn = NeuralNetwork(createSizedNetwork: [1,3,1])

var td = [TrainingData]()
for i in 1...10 {
    td.append(TrainingData(x: [Double(i)], y: Double(3*i + 3), scaledY: 0))
}
var ts = TrainigSet(trainingData: td)
ts.normalizeDataStandard()

for i in 1...100000 {
    nn.train(input: [0.2], realOutput: 0.3)
    //nn.train(input: [0.4], realOutput: 0.5)
}

nn.calculate(data: [0.4])
print (nn.output!)

