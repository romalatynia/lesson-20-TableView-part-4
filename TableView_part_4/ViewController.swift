//
//  ViewController.swift
//  TableView_part_4
//
//  Created by Harbros47 on 29.01.21.
//

import UIKit
private enum Constants {
    static let indentifire = "MyCell"
    static let formatter = DateFormatter()
    static let Dateformatter: DateFormatter = {
        Constants.formatter.dateFormat = "dd.MM.yyyy"
        return Constants.formatter
    }()
    static let monthFormatter: DateFormatter = {
        Constants.formatter.dateFormat = "MMMM"
        return Constants.formatter
    }()
    static let sortingControl: UISegmentedControl = {
        var control = UISegmentedControl(items: ["Date", "Name", "LastName"])
        control.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        control.selectedSegmentIndex = 0
        return control
    }()
    static let search = "Search"
    static let title = "Students"
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private var studentArray = [Student]()
    private var sortedStudent = [GroupStudent]()
    private var myTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        createStudents()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         sortedStudent.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         sortedStudent[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         sortedStudent[section].student.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: Constants.indentifire)
        let section = sortedStudent[indexPath.section]
        let row = section.student[indexPath.row]
        cell.textLabel?.text = "\(row.name) \(row.lastName)"
        cell.detailTextLabel?.text = "\(Constants.Dateformatter.string(from: row.dateOfBirth))"
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var arrayOfTitles = [String]()
        sortedStudent.forEach { arrayOfTitles.append("\($0.name.first ?? Character(""))") }
        return arrayOfTitles
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.placeholder = Constants.search
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        sortedStudent = devideInSection(
            sourse: studentArray,
            filter: "",
            andSender: Constants.sortingControl.selectedSegmentIndex
        )
        myTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sortedStudent = devideInSection(
            sourse: studentArray,
            filter: searchText,
            andSender: Constants.sortingControl.selectedSegmentIndex
        )
        myTableView.reloadData()
    }
    
    // MARK: - создание таблицы
    private func createTable() {
        myTableView = UITableView(frame: view.bounds, style: .plain)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.indentifire)
        Constants.sortingControl.addTarget(self, action: #selector(sortedStudents), for: .valueChanged)
        myTableView.delegate = self
        myTableView.dataSource = self
        view.addSubview(myTableView)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        searchController.automaticallyShowsScopeBar = true
        navigationItem.searchController = searchController
        Constants.sortingControl.addTarget(self, action: #selector(sortedStudents(sender:)), for: .valueChanged)
        let barControl = UIBarButtonItem(customView: Constants.sortingControl)
        navigationItem.rightBarButtonItem = barControl
        navigationItem.title = Constants.title
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - создание студентов
    private func createStudents() {
        for _ in 0...Int.random(in: 0...50) {
            let student = Student()
            student.randomStudents()
            studentArray.append(student)
        }
        studentArray = sortedDate(student: studentArray)
        
        sortedStudent = devideInSection(
            sourse: studentArray,
            filter: "",
            andSender: Constants.sortingControl.selectedSegmentIndex
        )
    }
    
    // MARK: - сортировка студентов
    private func sortedDate(student: [Student]) -> [Student] {
         student.sorted { (s1, s2) -> Bool in
            if s1.name == s2.name && s1.dateOfBirth == s2.dateOfBirth {
                return s1.lastName < s2.lastName
            } else if s1.dateOfBirth == s2.dateOfBirth {
                return s1.name < s2.name
            }
            return s1.dateOfBirth < s2.dateOfBirth
        }
    }
    
    private func sortedName(student: [Student]) -> [Student] {
         student.sorted { (s1, s2) -> Bool in
            if s1.name == s2.name && s1.lastName == s2.lastName {
                return s1.dateOfBirth < s2.dateOfBirth
            } else if s1.name == s2.name {
                return s1.lastName < s2.lastName
            }
            return s1.name < s2.name
        }
    }
    
    private func sortedLastName(student: [Student]) -> [Student] {
         student.sorted { (s1, s2) -> Bool in
            if s1.lastName == s2.lastName && s1.dateOfBirth == s2.dateOfBirth {
                return s1.name < s2.name
            } else if s1.lastName == s2.lastName {
                return s1.dateOfBirth < s2.dateOfBirth
            }
            return s1.lastName < s2.lastName
        }
    }
    
    @objc private func sortedStudents(sender: UISegmentedControl) {
        var student = [Student]()
        sortedStudent.forEach { student.append(contentsOf: $0.student) }
        
        switch sender.selectedSegmentIndex {
        case 0:
            student = sortedDate(student: student)
            sortedStudent = devideInSection(
                sourse: student,
                filter: "",
                andSender: Constants.sortingControl.selectedSegmentIndex
            )
        case 1:
            student = sortedName(student: student)
            sortedStudent = devideInSection(
                sourse: student,
                filter: "",
                andSender: Constants.sortingControl.selectedSegmentIndex
            )
        case 2:
            student = sortedLastName(student: student)
            sortedStudent = devideInSection(
                sourse: student,
                filter: "",
                andSender: Constants.sortingControl.selectedSegmentIndex
            )
        default:
            break
        }
        myTableView.reloadData()
    }
    
    // MARK: - создание титульников для всех сегментед контрол
    private func nameOfIndexTitles(student: Student, sender: Int) -> String {
        var name = String()
        switch sender {
        case 0:
            name = Constants.monthFormatter.string(from: student.dateOfBirth)
        case 1:
            name = "\(student.name.first ?? Character(""))"
        case 2:
            name = "\(student.lastName.first ?? Character(""))"
        default:
            break
        }
        return name
    }
    
    // MARK: - распределение студентов по сегментед контрол
    private func devideInSection(sourse: [Student], filter: String, andSender: Int) -> [GroupStudent] {
        var array = [GroupStudent]()
        let sectionName = NSMutableOrderedSet()
        
        for student in sourse {
            let name = nameOfIndexTitles(student: student, sender: andSender)
            if !filter.isEmpty && !student.fullName.contains(filter) {
                continue
            }
            if sectionName.contains(name) {
                let section = array[sectionName.index(of: name)]
                section.student.append(student)
            } else {
                let section = GroupStudent()
                section.name = name
                section.student.append(student)
                array.append(section)
                sectionName.add(name)
            }
        }
        return array
    }
}
