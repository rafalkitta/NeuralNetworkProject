# NeuralNetworkProject
Preedicting the class of Haberman's survival with neural networks


# Requirements
- Xcode 8.0+
- Swift 3.0+


# Sample use
```swift
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
```


# Repository structure

Branch | Description
--- | ---
`master` | Main branch of project
`adrian_neural_network` | Source code of Adrian's neural network from lab
`rafal_neural_network`  | Source code of Rafals's neural network from lab


# Project documentation
API reference is located in `/doc` directory. It is a webpage created from source files by [Jazzy](https://github.com/realm/jazzy) tool. Contains descriptions of all classes, structs, enums etc. 

## Updateing API reference
### Install [Jazzy](https://github.com/realm/jazzy) tool
```sh
$ sudo gem install jazzy
```

### Go to project file directory
```sh
cd source/
```

### Generate API reference
```sh
$ jazzy \
--output ../doc \
--min-acl internal \
--author Rafał\ Kitta,\ Adrian\ Moczulski \
--readme ../README.md \
--github_url https://github.com/rafalkitta/NeuralNetworkProject \
--sdk macosx
```

