//: [Previous](@previous)

import Foundation

// MARK: GENERICS
// avoid writing the same code multiple types

// the function takes two numerical values (of any type) and a function that acts on the two inputs
// int, double, etc. all conform to a protocol called "Numeric" -- use generics
func perform<N: Numeric>(
    _ op: (N, N) -> N,
    on lhs: N,
    and rhs: N
) -> N {
    op(lhs, rhs)
}

let x = perform(+, on: 10, and: 20) // compiler infers the type of x based on the two inputs
let y = perform(-, on: 10.2, and: 6) // automatically promotes 6 to double

// can also define generic parameters at the end of function signature
func perform2<N> (
    _ op: (N, N) -> N,
    on lhs: N,
    and rhs: N
    ) -> N where N: Numeric {
    op(lhs, rhs)
}

protocol CanJump {
    func jump()
}

protocol CanRun {
    func run()
}

struct Person: CanJump, CanRun {
    func jump() {
        "Jumping..."
    }
    func run() {
        "Running..."
    }
}

// combining multiple protocols to create a generic function signature to gain access to more than one protocol data
func jumpAndRun<T: CanJump & CanRun> (_ value: T) {
    value.jump()
    value.run()
}

let person = Person()
jumpAndRun(person)

// extending generic types example -- arrays

let names: [String] = ["A", "B"] // [String] or Array<String> is the type of string array

extension [String] {
    func longestString() -> String? { // optional -- can be nil if empty
        self.sorted { (lhs: String, rhs: String) -> Bool in
            lhs.count > rhs.count
        }.first
    }
}

extension [Int] {
    func average() -> Double {
        return Double(self.reduce(0, +)) / Double(self.count)
    }
}
[1,2,3,4].average()

["Foo", "Bar Baz", "Qux"].longestString()

// associated types in protocols & generic protocols (everything below here are kinda complicated lol)

protocol View {
    func addSubView(_ view: View)
}

extension View {
    func addSubView(_ view: View) {
        
    }
}

struct Button: View {
    
}

struct Person2 {
    let name: String
}

protocol PresentableAsView {
    associatedtype ViewType: View // turn a protocol into a generic protocol
    func produceView() -> ViewType
    func configure(superView: View, thisView: ViewType)
    func present(view: ViewType, on superView: View)
}

extension PresentableAsView {
    func configure(superView: View, thisView: ViewType) {
        
    }
    func present(view: ViewType, on superView: View) {
        superView.addSubView(view)
    }
}

struct MyButton: PresentableAsView {
    func produceView() -> Button {
        Button()
    }
    func configure(superView: any View, thisView: Button) {
        
    }
}

extension PresentableAsView where ViewType == Button {
    // only objects that conform to PresentableAsView AND have viewtype as button will get these ext
    func doSomethingWithButton() {
        "This is a button"
    }
}

let button = MyButton()
button.doSomethingWithButton()

// MARK: OPTIONALS
// a value that might or might not be present

func multiplyByTwo(_ value: Int? = nil) -> Int { // value is optional, default is not present
    if let value { // if value is present
        return value * 2
    } else {
        return 0
    }
}

multiplyByTwo()
multiplyByTwo(2)

let age : Int? = nil
if age != nil { // comparison also works with == 0 without wrapping
    "Age is there!"
} else {
    "Age is nil"
}

func checkAge() {
    // guard mechanism: indicates that that variable is CRUCIAL to the functionality of the func
    guard age != nil else { // opposite of condition listed executed
        "Age is nil as expected"
        return // MUST return
    }
    
    "Age is not nil here. Strange!"
}

checkAge()

let age2: Int? = 0
func checkAge2() {
    guard let age2 else { // "guard let" unwraps the optional
        "Age is nil."
        return
    }
    
    "Age2 is not nil, value = \(age2)" // now you can access the variable
}
checkAge2()

switch age {
case .none: // optional is an enum with two cases
    "Age has no value"
    break
case let .some(value): // unwrap
    "Age has the value of \(value)"
    break
}

if age2 == .some(0) { // same as age2 == 0
    "Age2 is 0 as expected"
}

struct Person3 {
    let name: String
    let address: Address?
    struct Address { // optional within optional
        let firstLine: String?
    }
}

let foo: Person3 = Person3(name: "Foo", address: nil)
if let foolFirstAddressLine = foo.address?.firstLine { // if optional is present unwrap it
    foolFirstAddressLine // print it out
} else {
    "Foo doesn't have an address with first line"
}
if let fooAddress = foo.address,
let firstLine = fooAddress.firstLine { // alternative way
    fooAddress
    firstLine
}

let bar: Person3? = Person3(name: "Bar", address: Person3.Address(firstLine: nil)) // bar is optional!
if bar?.name == "Bar", bar?.address?.firstLine == nil {
    // optionality continues until it cannot continue anymore
    "Bar's name is bar and has no first line of address"
} else {
    "Seem like something isn't working right"
}

let baz: Person3? = Person3(name: "Baz", address: Person3.Address(firstLine: "Baz first line"))
// switching an optional with enum values
switch baz?.address?.firstLine {
case let .some(firstLine) where firstLine.starts(with: "Baz"):
    "Baz first address line = \(firstLine)"
case let .some(firstLine):
    "Baz first address line that didn't match the previous case"
    firstLine
case .none:
    "Baz first address line is nil? Weird"
}

func getFullName(firstName: String, lastName: String?) -> String? {
    guard let lastName else { // reads: "Make sure lastName is present, or else -> return nil"
        return nil
    }
    return "\(firstName) \(lastName)" // statements after guard let will have the optional unwrapped
}
getFullName(firstName: "Foo", lastName: nil)

//: [Next](@next)
