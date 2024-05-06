//: [Previous](@previous)

import Foundation

struct Person {
    let firstName: String?
    let lastName: String?
    
    // errors should be defined within the struct
    enum Errors: Error {
        case firstNameIsNil, lastNameIsNil, bothNamesAreNil
    }
    // notice that you can also use multiple enum for different cases for different func
    
    func getFullName() throws -> String { // throws error within the func
        switch (firstName, lastName) { // switching two optionals
        case (.none, .none):
            throw Errors.bothNamesAreNil
        case (.none, .some):
            throw Errors.firstNameIsNil
        case (.some, .none):
            throw Errors.lastNameIsNil
        case let (.some(firstName), .some(lastName)):
            return "\(firstName) \(lastName)" // powerful pattern matching
        }
        
        // inside a throw function you can directly use try without "do and catch"
    }
}

let foo = Person(firstName: "Foo", lastName: nil)

// do & catch for error handling
do {
 let fullName = try foo.getFullName()
} catch let e {
    "Got an error = \(e)" // "error" object also comes by default
}

let bar = Person(firstName: nil, lastName: nil)

// catching specific errors
do {
 let fullName = try bar.getFullName()
} catch Person.Errors.firstNameIsNil, Person.Errors.lastNameIsNil {
    "First name OR Last name is nil"
} catch Person.Errors.bothNamesAreNil {
    "Both names are nil"
} catch {
    "Some other errors"
}

// errors can also be thrown in constructors (e.g. data validation)
struct Car {
    let manufacturer: String
    
    enum Errors: Error {
        case invalidManufacturer
    }
    
    init(manufacturer: String) throws {
        if manufacturer.isEmpty {
            throw Errors.invalidManufacturer
        }
        self.manufacturer = manufacturer
    }
}

do {
    let myCar = try Car(manufacturer: "")
    // nothing will be executed here if try fails
} catch Car.Errors.invalidManufacturer {
    "Invalid manufacturer"
}

if let yourCar = try? Car(manufacturer: "Tesla") { // optional try
    "success, your car = \(yourCar)"
} else {
    "failed"
}

let theirCar = try! Car(manufacturer: "Ford") // MARK: IF THIS FAILS, THE APP WILL CRASH!
theirCar.manufacturer

func fullName(
    firstName: String?,
    lastName: String?,
    calculator: (String?, String?) throws -> String?
    // for a function to be marked rethrows, it must contain an argumen that is a closure which throws and it should call that argument
) rethrows -> String? { 
    // "rethrows" tells Swift that the func invokes another func that throws
    try calculator(firstName, lastName)
}

enum NameErrors: Error {
    case firstNameIsInvalid, lastNameIsInvalid
}

// define a function to pass into fullName as the closure argument "calculator
func + (firstName: String?, lastName: String?) throws -> String { // promotion works, demotion error
    guard let firstName, !firstName.isEmpty else {
        // make sure first name is present AND it is not empty, otherwise:
        throw NameErrors.firstNameIsInvalid
    }
    guard let lastName, !lastName.isEmpty else {
        // make sure first name is present AND it is not empty, otherwise:
        throw NameErrors.lastNameIsInvalid
    }
    return "\(firstName) \(lastName)" // always gives string or throws error
}

do {
    let fooBar = try fullName(firstName: nil, lastName: nil, calculator: +)
} catch NameErrors.firstNameIsInvalid {
    "First name is invalid"
} catch NameErrors.lastNameIsInvalid {
    "Last name is invalid"
} catch let err {
    "Some other error = \(err)"
}

// a function that gets the previous positive integer -> error when input 0, how to catch that?
enum IntegerErrors: Error {
    case noPositiveIntBefore(thisValue: Int)
}

func getPrevious(from int: Int) -> Result<Int, IntegerErrors> { // if it works, returns an integer, otherwise carries with it a (specific) type of error
    guard int > 0 else {
        return Result.failure(IntegerErrors.noPositiveIntBefore(thisValue: int)) // if fails
    }
    return Result.success(int - 1) // if works
}

func performGet(forValue value: Int) {
    // result returned is a enum that can be used for pattern matching
    switch getPrevious(from: value) {
    case let .success(previousValue):
        "Previous value is \(previousValue)"
    case let .failure(error):
        // error itself is a enum that can be switched!
        switch error {
        case let .noPositiveIntBefore(thisValue):
            "No positive integer before \(thisValue)"
        }
    }
}

performGet(forValue: 0)
performGet(forValue: 2)

//: [Next](@next)
