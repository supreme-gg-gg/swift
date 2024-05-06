import Foundation // imports basics of swift

// MARK: let cannot be assigned again (immutable) but var can be assigned again (mutable)

let myName = "Vandad"
let yourName = "Foo"

var names = [myName, yourName]
names.append("Bar") // if this is declared using let it cannot be mutated

// value types and reference types

let moreNames = ["Foo", "Bar"]
var copy = moreNames // array/structure are value types so this creates a copy
copy.append("Baz")

let oldArray = NSMutableArray( // this is mutable because it is a reference type
    array: [
        "Foo",
        "Bar"
    ]
)
// oldArray.add("Baz")
// however, you still cannot reassign a value to let (e.g. oldArray = [])

func changeTheArray(_ array:NSArray) { // internal mutability
    let copy = array as! NSMutableArray
    copy.add("Baz")
}
changeTheArray(oldArray) // this actually changes outside array since its a reference type

let myAge = 22
let yourAge = 20
if myAge > yourAge {
    "I'm older than you"
} else if myAge < yourAge {
    "I'm younger than you"
} else {
    "Same age"
}
// MARK: OPERATORS
/// 1. unary prefix (unary = working with one value)
let foo = !true
/// 2. unary postfix
let name = Optional("Vandad")
let unaryPostFix = name! // ! operator extracts the value from Optional type String
/// 3. binary infix (infix = in between two values)
let result = 1 + 2
/// 4. ternary operator -- condition?value if met:value if not met
let message = myAge >= 18 ? "You are an adult" : "You are not an adult"

// MARK: FUNCTIONS

func plusTwo(value: Int) { // label data type of parameters
    let newValue = value + 2
}

plusTwo(value:30)

func newPlusTwo(value:Int) -> Int { // -> indicates return type, no "return" needed
    value + 2
}
newPlusTwo(value: 30)

// external and internal labels
func customMinus(_ lhs:Int, _ rhs:Int) -> Int { // external internal: type
    lhs - rhs;
}
let subtracted = customMinus(10, 20) // using "_" lets you to ignore external name, otherwise the name will be both internal and external

// in pure Swift a warning will be shown for function which produces value but its results are not consumed (not used), to fix it:
@discardableResult
func myCustomAdd(_ lhs:Int, _ rhs:Int) -> Int {
    lhs + rhs
}

func doSomething(with value: Int) -> Int {
    func mainLogic(value:Int) -> Int { // inner functionc an only be called by outer
        value + 2
    }
    return mainLogic(value: value + 3)
}
doSomething(with: 30) // with is external label

func getFullName(
    firstName: String = "Foo", // default values
    lastName: String = "Bar"
) -> String {
    "\(firstName) \(lastName)" // similar to `${}` in javascript
}
getFullName(lastName: "Foo")

// MARK: CLOSURES -- functions without func keyword (inline)

let add: (Int, Int) -> Int // indicate parameter and output types
    = { (lhs: Int, rhs: Int) -> Int in // "in" indicates where the function body starts
        lhs + rhs
    }
add(20, 30) // add is now a variable that points to a function

// this is how to pass functions
func customAdd(
    _ lhs:Int,
    _ rhs:Int,
    using myFunction:(Int, Int) -> Int // using and myFunction are just labels
) -> Int {
    myFunction(lhs, rhs)
}

customAdd(20, 30, using: {(lhs: Int, rhs:Int) -> Int in lhs + rhs}) // declare a function in line and this function does the actual calculation

// clean up -- no need to specify data types again (puts strain on compiler & slows down)
customAdd(20, 30) { (lhs, rhs) in lhs + rhs} // also uses trailing closure syntax

let ages = [30, 20, 19, 40]
ages.sorted(by: {(lhs: Int, rhs: Int) -> Bool in lhs > rhs}) // ascending and descending
ages.sorted(by: <) // the binary operator already replaces the closure

func add10(_ value:Int) -> Int {
    value + 10
}
func add20(_ value:Int) -> Int {
    value + 20
}
func addition(
    on value: Int,
    using function: (Int) -> Int
) -> Int {
    return function(value)
}
addition(on: 20) { (value) in value + 30 } // regular way using closure
addition(on: 20, using: add10(_:)) // passing reference to a defined function
