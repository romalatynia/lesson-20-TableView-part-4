//
//  Student.swift
//  TableView_part_4
//
//  Created by Harbros47 on 29.01.21.
//

import Foundation

class Student: NSObject {
    
    var name: String
    var lastName: String
    var dateOfBirth: Date
    var fullName: String {
        name + " " + lastName
    }
    
    override init() {
        name = ""
        lastName = ""
        dateOfBirth = Date()
    }
    
    static let firstNames = [
        "Tran", "Lenore", "Bud", "Fredda", "Katrice",
        "Clyde", "Hildegard", "Vernell", "Nellie", "Rupert",
        "Billie", "Tamica", "Crystle", "Kandi", "Caridad",
        "Vanetta", "Taylor", "Pinkie", "Ben", "Rosanna",
        "Eufemia", "Britteny", "Ramon", "Jacque", "Telma",
        "Colton", "Monte", "Pam", "Tracy", "Tresa",
        "Willard", "Mireille", "Roma", "Elise", "Trang",
        "Ty", "Pierre", "Floyd", "Savanna", "Arvilla",
        "Whitney", "Denver", "Norbert", "Meghan", "Tandra",
        "Jenise", "Brent", "Elenor", "Sha", "Jessie"
    ]
    
    static let lastNames = [
        "Farrah", "Laviolette", "Heal", "Sechrest", "Roots",
        "Homan", "Starns", "Oldham", "Yocum", "Mancia",
        "Prill", "Lush", "Piedra", "Castenada", "Warnock",
        "Vanderlinden", "Simms", "Gilroy", "Brann", "Bodden",
        "Lenz", "Gildersleeve", "Wimbish", "Bello", "Beachy",
        "Jurado", "William", "Beaupre", "Dyal", "Doiron",
        "Plourde", "Bator", "Krause", "Odriscoll", "Corby",
        "Waltman", "Michaud", "Kobayashi", "Sherrick", "Woolfolk",
        "Holladay", "Hornback", "Moler", "Bowles", "Libbey",
        "Spano", "Folson", "Arguelles", "Burke", "Rook"
    ]
    
    var components: DateComponents = {
        var value = DateComponents()
        value.calendar = Calendar.current
        return value
    }()
    
    func randomStudents() {
        name = Student.firstNames.randomElement() ?? ""
        lastName = Student.lastNames.randomElement() ?? ""
        
        components.day = Int.random(in: 0...365)
        components.year = Int.random(in: 1970...2010)
        dateOfBirth = components.date ?? Date()
    }
}
