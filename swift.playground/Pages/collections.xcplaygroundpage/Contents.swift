//: [Previous](@previous)

import Foundation

// MARK: COLLECTION = Collections of stuff

// Let's start with arrays

let numbers = [1,2,3,4]
numbers.count
numbers.map(-)

var mutatingNumbers = [4,5,6]
mutatingNumbers.append(7)
mutatingNumbers.insert(3, at:0)
mutatingNumbers.insert(contentsOf: [1,2], at: 0)

for value in numbers where value % 2 == 0 {
    value
}

numbers.map({(value:Int) -> String in String(value * 2)}) // allows you to return ANY TYPE

numbers.filter({(value: Int) -> Bool in value >= 3}) // recall closures!

// compact map (map + filter) returns an optional, if nil not included
numbers.compactMap({(value: Int) -> String? in
    value % 2 == 0 ? String(value) : nil // recall ternary operator
})

let numbers2: [Int?] = [1,2,nil,4,5]
numbers2.count
let notNils = numbers2.filter {(value: Int?) -> Bool in value != nil} // however, since filter doesn't allow changing datatype this is still of type [Int?]
let notNils2 = numbers.compactMap({(value: Int?) -> Int? in value})

let stuff1 = [1, "Hello", 2, "World"] as [Any] // heterogenous array, or using let stuff 1: [Any] = [] to specify datatype
let intsInStuff1 = stuff1.compactMap({(value: Any) -> Int? in value as? Int}) // compare value to Int and optionally returns only if is Int

// Now it's time to look at "sets" -- only include unique values

let uniqueNumbers = Set([1,2,1,2,3]) // order is NOT guaranteed, duplicate removed
uniqueNumbers.count
uniqueNumbers.map(-)

let stuff2: Set<AnyHashable> = [1,2,3, "Vandad"] // heterogenous sets
let intsInStuff2 = stuff2.compactMap({(value: AnyHashable) -> Int? in value as? Int}) // compact mapping on set returns an ARRAY, no longer a SET

// Sets use the "hashable" protocol to calculate uniqueness

struct Person : Hashable {
    let id: UUID
    let name: String
    let age: Int
}

let fooID = UUID()
let foo = Person(id: fooID, name: "Foo", age: 20)
let bar = Person(id: fooID, name: "Bar", age: 30)
let person: Set<Person> = [foo, bar] // still a set of two people
// Swift calculates hash by assigning a "hash value" to each variable and comparing if everything is equal (foo and bar are not even if use the same ID)

// therefore we have to implemenent our own hash logic
struct Person2: Hashable {
    let id: UUID
    let name: String
    let age: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // this specifies that ONLY id is hashed
    }
    
    // we also have to change how equality works for two person
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
}

let bazId = UUID()
let baz = Person2(id: bazId, name: "Baz", age: 20)
let qux = Person2(id: bazId, name: "Qux", age: 30)
let people2 = Set([baz, qux]) // now it is a set of only one object, qux not inserted into the set (same id)

// finally dictionaries! (aka JSON objects)

let userInfo = [
    "name": "Foo",
    "age": 20,
    "address": [
        "line1": "Address line 1",
        "postCode": "12345"
    ]
] as [String: Any] // for heterogenous must declare key and value type

userInfo["name"] // retrieving values with keys
userInfo.keys
userInfo.values

// multiple conditions
for (key, value) in userInfo where value is Int && key.count > 2 {
    print(key)
    print(value)
}

// MARK: EQUALITY, and EQUATABLE
// Equality using an "Equatable" protocol, must have a equality operator defined

struct Person3: Equatable {
    let id: String
    let name: String
}

let foo1 = Person3(id: "1", name: "Foo")
let foo2 = Person3(id: "1", name: "Bar")
 
// Swift will go through all properties and compare them one by one
if foo1 == foo2 {
    "They are equal!"
} else {
    "They are not equal"
}

// defining your own custom equality
extension Person3 {
    static func == (lhs: Self, rhs: Self) -> Bool { // both argument will have the type of "Self" which means the type of the argument lol
        lhs.id == rhs.id
    }
}

// similar for enum
enum AnimalType {
    case dog(breed:String), cat(breed:String), bird
}

extension AnimalType: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        // review enum chapter if anything seems unfamiliar
        switch (lhs, rhs){
        case let (.dog(lhsBreed), .dog(rhsBreed)), 
            let (.cat(lhsBreed), .cat(rhsBreed)):
            return lhsBreed == rhsBreed
        default: return false
        }
    }
}

struct Animal : Equatable {
    let name: String
    let type: AnimalType
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type // only look at type of animals (which then looks at breed defined in above)
    }
}

let cat1 = Animal(name: "Whiskers", type: .cat(breed: "Street Cat"))
let cat2 = Animal(name: "Whoosh", type: .cat(breed: "Street Cat"))

if cat1 == cat2 {
    "They are equal because of their type"
}

// MARK: HASHABLE
// also looks at all properties of that struct or class

struct House: Hashable {
    let number: Int
    let numberOfBedrooms: Int
}

let house1 = House(number: 123, numberOfBedrooms: 2)
house1.hashValue
let house2 = House(number: 123, numberOfBedrooms: 3)
house2.hashValue // different, but if both properties same hashValue is same
let houses = Set([house1, house2])
houses.count

struct NumberedHouse: Hashable {
    let number: Int
    let numberOfBedrooms: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(number) // hash value only depends on number
    }
    
    static func == (lhs: Self, rhs: Self) {
        lhs.number == rhs.number
    }
}
// if you repeat the above example with this struct, there will only be one element in the Set "houses" (covered in Set Unit)

// enums are by default hashable and equitable even without raw values
enum CarPart {
    case roof
    case tire
    case trunk
}

let uniqueParts: Set<CarPart> = [.roof, .tire, .roof, .trunk]

// you can change hash mechanism of enums with associated values
enum HouseType: Hashable {
    case bigHouse(NumberedHouse)
    case smallHouse(NumberedHouse)
}

let bigHouse1 = HouseType.bigHouse(NumberedHouse(number: 1, numberOfBedrooms: 1))
let bigHouse2 = HouseType.bigHouse(NumberedHouse(number: 1, numberOfBedrooms: 1))
let smallHouse1 = HouseType.smallHouse(NumberedHouse(number: 1, numberOfBedrooms: 1))

let allHouses: Set<HouseType> = [bigHouse1, bigHouse2, smallHouse1] 
/// bigHouse1 and bigHouse2 are considered to have the same Hash Value
/// but since both enum cases have their own hash value, big and small not the same

// MARK: CUSTOM OPERATORS

let firstName: String? = "Foo"
let lastName: String? = "Bar"
let fullName = firstName + lastName // + for optional strings not defined

// binary infix operator
func + (lhs: String?, rhs: String?) -> String? {
    switch (lhs, rhs) {
    case (.none, .none):
        return nil
    case let (.some(value), .none), let (.none, .some(value)):
        return value
    case let (.some(value1), .some(value2)):
        return value1 + value2
    }
}

// unary prefix operator
prefix operator ^ // declare its type first
prefix func ^ (value: String) -> String {
    value.uppercased()
}

let lowercaseName = "Foo Bar"
let uppercaseName = ^lowercaseName

// unary postfix operator
postfix operator *
postfix func * (value: String) -> String {
    "*** \(value) ***"
}

let withStars = lowercaseName*

// binary infix with different types on two sides

struct Person4 {
    let name: String
}

struct Family {
    let members: [Person4]
}

let mom = Person4(name: "mom")
let dad = Person4(name: "dad")
let family = mom + dad

func + (lhs: Person4, rhs: Person4) -> Family {
    Family(members: [lhs, rhs])
}

let son = Person4(name: "son")
let familyWithSon = family + son // need to write another "+" for this type

func + (lhs: Family, rhs: Person4) -> Family {
    var members = lhs.members
    members.append(rhs)
    return Family(members: members)
}

let daughter1 = Person4(name: "daughter1")
let daughter2 = Person4(name: "daughter2")
let familyWithDaughters = familyWithSon + [daughter1, daughter2] // define again
func + (lhs: Family, rhs: [Person4]) -> Family {
    var members = lhs.members
    members.append(contentsOf: rhs)
    return Family(members: members)
}

//: [Next](@next)
