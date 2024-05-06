//: [Previous](@previous)

import Foundation

// MARK: PROTOCALS
// a set of rules which objects that conform to a protocol must follow, like Interface in Java?

protocol CanBreathe {
    func breathe() // this function has NO body, unlike struct or class!
}

struct Animal: CanBreathe { // struct DOES allow inheritance from protocols
    func breathe() {
        "Animal breathing..."
    }
}

struct Person: CanBreathe {
    func breathe() {
        "Person breathing..."
    }
}

let dog = Animal()
dog.breathe()
let foo = Person()
foo.breathe()

// they can also have function implementations
protocol CanJump {
    func jump()
}

extension CanJump { // adding default implementation
    func jump() {
        "Jumping..."
    }
}

// to invoke the function you must instantiate an object, not protocol
struct Cat: CanJump {
    // all cat objects will get jump function implementation by default, but can change it too
}
let whiskers = Cat()
whiskers.jump()

protocol HasName { // like a blueprint
    // any conforming objects must have a variable called "name" with a getter
    var name: String { get }
    var age: Int { get set }
    mutating func increaseAge()
}

extension HasName { // using extnesion on protocol can access the required variables
    func describeMe() -> String {
        "Your name is \(name) and you are \(age) years old"
    }
    mutating func increaseAge() {
        self.age += 1
    }
}

struct Dog: HasName {
    let name: String
    var age: Int
}

var woof = Dog(name: "Woof", age: 10)
woof.name
woof.age += 1
woof.describeMe()
woof.increaseAge()

protocol Vehicle {
    var speed: Int {get set}
    mutating func increaseSpeed(by value: Int)
}

extension Vehicle {
    mutating func increaseSpeed(by value:Int) {
        self.speed += value
    }
}

struct Bike: Vehicle {
    var speed: Int = 0
}

var bike = Bike()
bike.increaseSpeed(by: 10)

// use "is" syntax to check if an object conforms to any protocols

func describe(obj: Any) { // any type
    if obj is Vehicle {
        "obj conforms to the Vehicle protocol"
    } else {
        "obj does NOT conform to the Vehicle protocol"
    }
}
describe(obj: bike)

func increaseSpeedIfVehicle(obj: Any){
    // increase speed IF the object conforms to Vehicle
    if var vehicle = obj as? Vehicle {
        // this syntax gives access to protocol variables
        vehicle.speed
        vehicle.increaseSpeed(by: 10)
        vehicle.speed
    } else {
        "This was not a vehicle"
    }
}

increaseSpeedIfVehicle(obj: bike)
// notice that since "bike" is a struct it is a value type not a reference type so the speed value in "bike" is not actually changed (passed a copy), unlike class
bike.speed

// MARK: EXTENSION
// extensions can add functionality to existing types

extension Int {
    func plusTwo() -> Int {
        // here self would refer to the "Int" type
        self + 2
    }
}

let two = 2
two.plusTwo()

// add initialisers to existing types (while not replacing Swift's default one)
struct Person2 {
    let firstName: String
    let lastName: String
}

extension Person2 {
    init(fullName: String) { // another way to initialise!
        let components = fullName.components(separatedBy: " ")
        self.init(firstName: components.first ?? fullName, lastName: components.last ?? fullName) // ?? basically means "otherwise"
    }
}

let person = Person2(fullName: "Foo Bar")
person.firstName
person.lastName

protocol GoesVroom {
    var vroomValue: String { get } // recall that "get" means at least readable (let)
    func goVroom() -> String
}

extension GoesVroom {
    func goVroom() -> String {
        "\(self.vroomValue) goes vroom!"
    }
}

struct Car {
    let manufacturer: String
    let model: String
}

let modelX = Car(manufacturer: "Tesla", model: "X")

extension Car: GoesVroom {
    var vroomValue: String { // computed variable
        "\(self.manufacturer) model \(self.model)"
    }
}

modelX.goVroom()

// extension on classes with convenience initialisers

class MyDouble {
    let value: Double
    init(value: Double) {
        self.value = value
    }
}

extension MyDouble {
    convenience init() { // extend existing class with a NEW convenience initialiser
        self.init(value: 0)
    }
}

let myDouble = MyDouble()
myDouble.value

//: [Next](@next)
