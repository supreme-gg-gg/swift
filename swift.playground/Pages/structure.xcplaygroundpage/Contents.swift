//: [Previous](@previous)

import Foundation

// MARK: STRUCTURE

struct Person {
    // constructors are implicitly created by the compiler
    let name: String
    let age: Int
}

let foo = Person(name: "Foo", age: 20) // creating an instance
// structures are immutable, only its instances can be changed
let name = foo.name

struct CommodoreComputer {
    let name: String
    let manufacturer: String
    init(name: String, manufacturer: String) { // customise a constructor
        self.name = name
        self.manufacturer = "Commodore" // default manufactuer value
    }
    // Alternatively: let manufacturer = "Commodore"
}

struct Person2 {
    let firstName: String
    let lastName: String
    var fullName: String { // computed properties, function within variable
        "\(firstName) \(lastName)"
    }
}
let fooBar = Person2(firstName: "Foo", lastName: "Bar")

struct Car {
    var currentSpeed: Int
    mutating func drive(speed: Int) { // usually structures are immutable though
        "Driving..."
        currentSpeed = speed
    }
}

let immutableCar = Car(currentSpeed: 10) // recall difference between var and let!
var mutableCar = Car(currentSpeed: 10)
mutableCar.drive(speed: 30)
// copy of a structure is another instance (value type) of that structure

// Swift structure do not accept subclassing (no inheritance)
struct Bike {
    let manufacturer: String
    let currentSpeed: Int
    func copy(currentSpeed: Int) -> Bike { // creating a function to change properties
        Bike(manufacturer: self.manufacturer, currentSpeed: currentSpeed)
    }
}
let bike1 = Bike(manufacturer: "HD", currentSpeed: 20)
let bike2 = bike1.copy(currentSpeed: 30)

// MARK: ENUMERATIONS
// enumerations are categorisation of similar values that are named

enum Animals {
    case cat, dog, rabbit // case are like types
}
let cat = Animals.cat
switch cat {
    case .cat:
        "This is a cat"
        break
    case .dog:
        "This is a dog"
        break
    default: // similar to else statement, no need to cover all cases
        "This is something else"
}

// enumerations with Associated Values
enum Shortcut {
    case fileOrFolder(path: URL, name: String)
    case wwwUrl(path: URL) // assigned values associated with enum cases
    case song(artist: String, songName: String)
}
let wwwApple = Shortcut.wwwUrl(path: URL(string:"https://apple.com")!)

// unpacking associated values of enumerations
switch wwwApple {
    case let .fileOrFolder(path, name):
        path
        name
        break
    case let .wwwUrl(path):
        path
        break
    case let .song(artist, songName):
        artist
        songName
        break
}

// only to handle one specific case:
if case let .wwwUrl(path) = wwwApple {path}

let withoutYou = Shortcut.song(artist: "Symphony X", songName: "Without You")
if case let .song(_, songName) = withoutYou {songName} // ignore the artist "_"

enum Vehicle {
    case car(manufacturer: String, model: String)
    case bike(manufacturer: String, yearMade: Int)
    
    // extracting manufacturer info (using computed property), or use function
    /*
    func getManufacturer() -> String {
        switch self {
        case let .car(manufacturer, _):
            return manufacturer
        case let .bike(manufacturer, _):
            return manufacturer
        }
    } */
    
    // even more advanced pattern matching syntax
    var manufacturer: String {
        switch self {
        case let .car(manufacturer, _),
            let .bike(manufacturer, _):
            return manufacturer
        }
    }
}

let car = Vehicle.car(manufacturer: "Tesla", model: "X")
car.manufacturer

let bike = Vehicle.bike(manufacturer: "HD", yearMade: 1984)
bike.manufacturer

enum FamilyMember: String { // enumeration with raw value -- define type
    case father = "Dad"
    case mother = "Mom"
}

FamilyMember.father.rawValue

enum FavoriteEmoji: String, CaseIterable {
    case blush = "😊"
    case rocket = "🚀"
}
FavoriteEmoji.allCases
FavoriteEmoji.allCases.map(\.rawValue)

// the reverse: creating an instance of FavEmoji using the value
if let blush = FavoriteEmoji(rawValue: "😊") {
    "Found the blush emoji"
    blush
} else {
    "This emoji doesn't exist"
}

// mutating members of enum
enum Height {
    case short, medium, long
    mutating func makeLong() {
        self = Height.long
    }
}

var myHeight = Height.medium
myHeight.makeLong()

// recursive or indirect enumerations (case referring to itself)
indirect enum IntOperation {
    case add(Int, Int)
    case subtract(Int, Int)
    case freehand(IntOperation) // freehand operation on IntOperation
    
    // function on this enum that calculates the result based on cases
    func calculateResult(
        of operation: IntOperation? = nil
    ) -> Int {
        switch operation ?? self {
        case let .add(lhs, rhs):
            return lhs + rhs
        case let .subtract(lhs, rhs):
            return lhs - rhs
        case let .freehand(operation):
            return calculateResult(of: operation)
        }
    }
}

let freeHand = IntOperation.freehand(.add(2,4))
freeHand.calculateResult()

// MARK: CLASSES
// struct, enum, classes -- reference types, allow for mutability

class Person3 {
    // unlike struct, classes require you to create an constructor
    var name: String
    var age: Int
    
    init(age: Int, name: String) {
        self.name = name
        self.age = age
    }
    
    func increaseAge() { // no need mutating prefix!
        self.age += 1
    }
}

let fooo = Person3(age: 20, name: "Foo")
fooo.age
fooo.increaseAge() // a class can change internally -- therefore it changes value even if declared using "let" (still cannot reassign)

let bar = fooo // bar is a pointer/ reference to fooo (same memory)
bar.increaseAge() // age of both increased

if fooo === bar { // == will give error, === means same memory allocation
    "Foo and Bar point to the same memory"
}

// classes, unlike structures, have inheritance!
class Vehicle2 {
    func goVroom() {
        "Vroom vroon"
    }
}

class Car2: Vehicle2 { // inheritance, like "extends"
    
}

let car2 = Car2()
car2.goVroom() // inherited function from Vehicle2 class

class Person4 {
    private(set) var age: Int // age can ONLY be changed inside the class
    init(age:Int) {
        self.age = age
    }
    func increaseAge() {
        self.age += 1
    }
}
let baz = Person4(age: 20)
baz.increaseAge() // BUT baz.age += 1 will give error

// designated vs convenience initialisers (latter delegates work to former)
class Tesla {
    let manufacturer = "Tesla"
    let model: String
    let year: Int
    
    init() { // designated initialiser
        self.model = "X"
        self.year = 2023
        // init(model = "X", year: 2023") would give error as it must do the work by itself
    }
    
    init (model: String, year: Int) { // designated
        self.model = model
        self.year = year
    }
    
    convenience init(model: String) {
        self.init(model: model, year: 2023) // delegating work to designated
    }
}

class TeslaModelY: Tesla {
    override init() { // init already defined first in Tesla class
        super.init(model:"Y", year: 2023)
        // super.init(model:"Y") would give error
        // inside a designated initialiser you cannot call a convenience
    }
    
    /// General rule: Designated initialiser in subclasses can only call designated initaliser in superclass
    /// Inside any class a designated initialiser CANNOT delegate to any other initialiser
    /// Convenience initialiser CAN, inside subclasses and their own classes, call a designated initialiser
}

let modelY = TeslaModelY()

let fooBar2 = Person4(age: 20)
func doSomething(with person: Person4){
    person.increaseAge()
}
doSomething(with: fooBar2)
fooBar2.age // this is also changed due to reference type passing

// deinitialisers -- remove from memory
class MyClass {
    init() {
        "Initialised"
    }
    func doSomething() {
        "Do Something"
    }
    deinit {
        "Deinitialised"
    }
}

let myClosure = { // if we use a closure
    // after this is out of scope deinitialiser is called
    let myClass = MyClass()
    myClass.doSomething()
}
myClosure()

//: [Next](@next)
