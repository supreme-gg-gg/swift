//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import _Concurrency

PlaygroundPage.current.needsIndefiniteExecution = true // don't stop the code after one run

// async function will not immediately return a result

func calculateFullName(firstName: String, lastName: String) async -> String {
    try? await Task.sleep(for: .seconds(1))
    return "\(firstName) \(lastName)"
}

Task { // create a Task to run the async function
    let result1 = await calculateFullName(firstName: "Foo", lastName: "Bar")
    async let result2 = calculateFullName(firstName: "Foo", lastName: "Bar")
    await result2 // must manually await by yourself
}

enum Clothe {
    case socks, shirt, trousers
}

func buySocks() async throws -> Clothe {
    try await Task.sleep(for: .seconds(1))
    return Clothe.socks
}

func buyShirt() async throws -> Clothe {
    try await Task.sleep(for: .seconds(1))
    return Clothe.shirt
}

struct Ensemble: CustomDebugStringConvertible {
    let clothes: [Clothe]
    let totalPrice: Double
    
    var debugDescription: String { // print this to debug console
        "Clothes = \(clothes), price = \(totalPrice)"
    }
}

func buyWholeEnsemble() async throws -> Ensemble {
    async let socks = buySocks()
    async let shirt = buyShirt()
    let ensemble = Ensemble(clothes: await [try socks, try shirt], totalPrice: 200)
    return ensemble
}

Task {
    if let ensemble = try? await buyWholeEnsemble() {
        print(ensemble)
    } else {
        "Something went wrong"
    }
}

// "async let" can only be used in an async closure/function or a task that is being run - kinda weird only to Swift

func getFullName(delay: Duration, calculator: () async -> String) async -> String {
    try? await Task.sleep(for: delay)
    return await calculator() // await on calculator which is async
}

func fullName() async -> String { "Foo Bar" }

Task {
    await getFullName(delay: .seconds(1)) {
        async let name = fullName()
        return await name
    } // recall trailing closure syntax
}

//: [Next](@next)
