//
//  GuestListTableViewController.swift
//  Hotel Manzana
//
//  Created by Иван longrail on 14/05/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class GuestListTableViewController: UITableViewController {

    // MARK: - Properties
    var fileName = "guestList"
    var guestList = GuestList()
    var newGuest: Registration? {
        didSet {
            guard let guest = newGuest else { return }
            guestList.add(guest)
            uploadGuestList()
            tableView.reloadData()
        }
    }
    var editingIndexPath: IndexPath?
    var detailCellIndexPath: IndexPath? = nil
    static var wifiPricePerDay = 10
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGuestList()
        let bundle = Bundle(for: DetailGuestListCell.self)
        let detailCellNib = UINib(nibName: "DetailGuestListCell", bundle: bundle)
        tableView.register(detailCellNib, forCellReuseIdentifier: "detailGuestListCell")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: 20)))
        header.backgroundColor = UIColor.groupTableViewBackground

        let mainLabel = UILabel(frame: CGRect(x:10, y: 0, width: 150, height: 20))
       
        
        let nameLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 150, height: 20))
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(12)
        nameLabel.font = font
        nameLabel.text = "Guest Name"
        
        let checkoutLabel = UILabel(frame: CGRect(x: 200, y: 20, width: 150, height: 20))
        font = UIFont.preferredFont(forTextStyle: .body).withSize(12)
        checkoutLabel.font = font
        checkoutLabel.text = "Checkout Date"
        
        
//        let sortButton = UIButton(frame: CGRect(x: 300, y: 20, width: 20, height: 20))
//        sortButton.titleLabel!.text = "Sort"
//        sortButton.backgroundColor = UIColor.blue
       
        switch section {
        case 0:
            mainLabel.text = "Staying Guests"
            nameLabel.textColor = .black
            checkoutLabel.textColor = .black
        case 1:
            mainLabel.text = "Archive Guests"
            mainLabel.textColor = .darkGray
            nameLabel.textColor = UIColor.darkGray
            checkoutLabel.textColor = .darkGray
        default:
            break
        }
        
        header.addSubview(mainLabel)
        header.addSubview(nameLabel)
        header.addSubview(checkoutLabel)

        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if detailCellIndexPath?.section == section {
                return guestList.currentGuests.count + 1
            } else {
                return guestList.currentGuests.count
            }
            
        case 1:
            if detailCellIndexPath?.section == section {
                return guestList.archiveGuests.count + 1
            } else {
                return guestList.archiveGuests.count
            }
            
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath != detailCellIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOfGuestList", for: indexPath) as! GuestListTableViewCell
            setup(cell, with: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailGuestListCell", for: indexPath) as! DetailGuestListCell
            setup(cell, with: indexPath.prevRow)
            return cell
        }
    }

    // MARK: - Table View Delegate Methods
    /* Detail Guest List Cell */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard detailCellIndexPath != indexPath else { return }
        
        if detailCellIndexPath == nil {
            insertDetailCell(at: indexPath.nextRow)
        } else
        if detailCellIndexPath == indexPath.nextRow {
            deleteDetailCell(at: indexPath.nextRow)
        } else {
            var insertingCellIndexPath = indexPath
            if indexPath.row > detailCellIndexPath!.row {
                insertingCellIndexPath.row -= 1
            }
            deleteDetailCell(at: detailCellIndexPath!)
            insertDetailCell(at: insertingCellIndexPath.nextRow)
        }
            
    }
    
    private func insertDetailCell(at indexPath: IndexPath) {
        detailCellIndexPath = indexPath
        tableView.insertRows(at: [detailCellIndexPath!], with: .automatic)
    }
    private func deleteDetailCell(at indexPath: IndexPath) {
        detailCellIndexPath = nil
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath != detailCellIndexPath else { return false }
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        switch indexPath.section {
        case 0:
            let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { (_, indexPath) in

                self.editingIndexPath = indexPath
                self.performSegue(withIdentifier: "editGuestSegue", sender: indexPath)
            })

            let toArchiveAction = UITableViewRowAction(style: .destructive, title: "Archive") { (_, indexPath) in
                self.guestList.addToArchive(from: indexPath.row)
                self.uploadGuestList()

                tableView.reloadData()
            }

            return [toArchiveAction, editAction]

        case 1:
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
                self.guestList.remove(from: indexPath.row)
                self.uploadGuestList()

                tableView.reloadData()
            }
            return [deleteAction]

        default:
            return nil
        }
    }
    
    // MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "editGuestSegue" else { return }
        guard sender is IndexPath else { return }
        let addRegistrationViewController = segue.destination as! AddRegistrationTableViewController
        let indexPath = sender as! IndexPath
        addRegistrationViewController.guest = guestList.currentGuests[indexPath.row]
    }

    // MARK: - Unwind Method
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard segue.identifier == "AddGuest" else { return }
        
        let addRegistrationTableViewController = segue.source as! AddRegistrationTableViewController
        
        if addRegistrationTableViewController.saveButton.title == "Add" {
            
            let g = addRegistrationTableViewController.guest
            newGuest = addRegistrationTableViewController.guest
        } else {
            guestList.change(at: editingIndexPath!.row, by: addRegistrationTableViewController.guest!)
            uploadGuestList()
        }

        tableView.reloadData()
    }

}

// MARK: - Setup UI Methods
extension GuestListTableViewController {
    
    func getGuest(from indexPath: IndexPath) -> Registration? {
        var index = -1
        if detailCellIndexPath != nil {
            index = detailCellIndexPath!.row <= indexPath.row ? indexPath.row - 1 : indexPath.row
        } else {
            index = indexPath.row
        }
        switch indexPath.section {
        case 0:
            return guestList.currentGuests[index]
        case 1:
            return guestList.archiveGuests[index]
        default:
            return nil
        }
    }
    
    func setup(_ cell: GuestListTableViewCell, with indexPath: IndexPath) {
        guard let guest = getGuest(from: indexPath) else { return }
        setupGuestListCellOutlets(in: cell, with: guest)
        setupColors(of: cell, withTypeCell: indexPath.section)
    }
    
    func setup(_ cell: DetailGuestListCell, with indexPath: IndexPath) {
        guard let guest = getGuest(from: indexPath) else { return }
        setupDetailCellOutlets(in: cell, with: guest)
        setupColors(of: cell, withTypeCell: 2)
    }
    
    private func setupGuestListCellOutlets(in cell: GuestListTableViewCell, with guest: Registration) {
        cell.guestName.text = guest.firstName + " " + guest.lastName
        cell.roomId.text = guest.roomType.shortName + " ID: " + String(guest.roomType.id)
        cell.checkOutDate.text = guest.checkOutDate.guestListDateFormatString
    }
    
    private func setupDetailCellOutlets(in cell: DetailGuestListCell, with guest: Registration) {
        cell.firstNameLabel?.text = guest.firstName
        cell.lastNameLabel?.text = guest.lastName
        cell.emailLabel?.text = guest.emailAddress
        cell.checkInDateLabel?.text = guest.checkInDate.guestListDateFormatString
        cell.checkOutDateLabel?.text = guest.checkOutDate.guestListDateFormatString
        cell.numberOfAdultsLabel?.text = String(guest.numberOfAdults)
        cell.numberOfChildrenLabel?.text = String(guest.numberOfChildren)
        cell.roomNameLabel?.text = "'" + guest.roomType.name + "'"
        cell.idLabel?.text = String(guest.roomType.id)
        cell.pricePerDayLabel?.text = String(guest.roomType.price) + "$"
        cell.wifiPricePerDayLabel?.text = guest.wifi ? String(GuestListTableViewController.wifiPricePerDay) + "$" : "Off"
        let numberOfDays = guest.checkInDate.numberOfDays(between: guest.checkOutDate)
        cell.totalDaysLabel?.text = String(numberOfDays)
        let totalPrice = guest.totalPrice(wifiPricePerDay: GuestListTableViewController.wifiPricePerDay)
        cell.totalPriceLabel?.text = String(totalPrice) + "$"
    }
    
    /// Setup color of cell subviews
    ///
    /// - Parameters:
    ///   - cell: current cell
    ///   - typeCell:
    ///
    ///             0: current guest - section 0 of guest list table
    ///             1: archive guest - section 1 of guest list table
    ///             2: detail cell
    private func setupColors(of cell: UITableViewCell, withTypeCell: Int) {
        switch withTypeCell {
            
        case 0:
            setTextColor(in: cell, with: .black)
            cell.backgroundColor = .white
            
        case 1:
            setTextColor(in: cell, with: .darkGray)
            cell.backgroundColor = .groupTableViewBackground
            
        case 2:
            setTextColor(in: cell, with: .white)
            cell.backgroundColor = .lightGray
        default:
            break
        }
    }
    
    private func setTextColor(in view: UIView, with color: UIColor) {
        view.subviews.forEach { view in
            setTextColor(in: view, with: color)
            guard let label = view as? UILabel else { return }
            label.textColor = color
        }
    }
}


// MARK: - Load & Upload Data Methods
extension GuestListTableViewController {
    func loadGuestList() {
        guard let loadedGuestList = load("\(GuestList.self)", from: fileName) as? GuestList else { return }
        guestList = loadedGuestList
    }
    
    func uploadGuestList() {
        write(guestList, to: fileName)
    }
}

// MARK: - Permanent plist files storage
extension GuestListTableViewController {
    func write(_ guestList: GuestList?, to fileName: String) {
        
        guard let encodedGuestList = guestList?.encode else { return }
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileURL = documentDirectory.appendingPathComponent(fileName).appendingPathExtension("plist")
        
        try? encodedGuestList.write(to: fileURL, options: .noFileProtection)
    }
    
    func load(_ typeName: String, from fileName: String) -> Any? {
        
        switch typeName {
            
        case "GuestList":
            
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentDirectory.appendingPathComponent(fileName).appendingPathExtension("plist")
            
            guard let dataFromFile = try? Data(contentsOf: fileURL) else { return nil }
            guard let decodedGuestList: GuestList = .getGuestList(from: dataFromFile) else { return nil}
            
            return  decodedGuestList
            
        default:
            return nil
        }
    }
}
