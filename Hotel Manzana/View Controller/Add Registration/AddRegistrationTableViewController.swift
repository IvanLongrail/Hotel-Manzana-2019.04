//
//  AddRegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Denis Bystruev on 22/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    // MARK: - IB Outlet
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    @IBOutlet weak var wifiPricePerDayLabel: UILabel!
    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBOutlet weak var wifiTotalPriceLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    // MARK: - UI Properties
    let saveButtonEditMode = false
    
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    let wifiTotalPriceCellIndexPath = IndexPath(row: 1, section: 3)
    let totalPriceSelectedRoomCellIndexPath = IndexPath(row: 1, section: 4)
    
    var isCheckInDatePickerShown = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    
    var isCheckOutDatePickerShown = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    var isWiFiTotalPriceShown = false
    var isRoomSelect = false
    
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    // MARK: - Data Properties
    var guest: Registration?
    var correctEnteredGuest = false {
        didSet {
            saveButton.isEnabled = correctEnteredGuest
        }
    }
    
    var wifiPricePerDay = GuestListTableViewController.wifiPricePerDay
    var wifiTotalPrice: Int = 0
    var selectedRoom: RoomType? {
        didSet {
            isRoomSelect = selectedRoom != nil ? true : false
            updateCorrectEnteredGuest()
            updateGuest()
        }
    }
    var totalPrice: Int = 0
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Custom UI Methods
    func setupDateViews() {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
    }
    
    func setupWiFiPerDay() {
        wifiPricePerDayLabel.text = "Wi-Fi (" + String(wifiPricePerDay) + "$ per day)"
    }
    
    func setupSaveButton() {
        saveButton.isEnabled = false
        saveButton.title = guest != nil ? "Save" : "Add"
    }
    
    func setupUI() {
        setupSaveButton()
        setupDateViews()
        setupWiFiPerDay()
        updateNumberOfGuests()
    }
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(60 * 60 * 24)
        
        checkInDateLabel.text = checkInDatePicker.date.guestListDateFormatString
        checkOutDateLabel.text = checkOutDatePicker.date.guestListDateFormatString
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateWiFiTotalPrice() {
        let daysNumber = checkInDatePicker.date.numberOfDays(between: checkOutDatePicker.date)
        wifiTotalPrice = isWiFiTotalPriceShown ? wifiPricePerDay * daysNumber : 0
        wifiTotalPriceLabel.text = String(wifiTotalPrice) + "$"
    }
    
    func updateTotalPrice() {
        let daysNumber = checkInDatePicker.date.numberOfDays(between: checkOutDatePicker.date)
        selectLabel.text = selectedRoom?.name ?? "Select"
        totalPrice = selectedRoom != nil ? selectedRoom!.price * daysNumber + wifiTotalPrice : 0
        totalPriceLabel.text = String(totalPrice) + "$"
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateUI() {
        updateDateViews()
        updateUIWithGuest()
    }
    
    func updateUIWithGuest() {
        guard let editingGuest = guest else { return }
        firstNameField.text = editingGuest.firstName
        lastNameField.text = editingGuest.lastName
        emailField.text = editingGuest.emailAddress
        checkInDateLabel.text = guest?.checkInDate.guestListDateFormatString
        checkInDateLabel.isEnabled = false
        checkInDatePicker.isEnabled = false
        checkOutDatePicker.date = editingGuest.checkOutDate
        checkOutDateLabel.text = guest?.checkOutDate.guestListDateFormatString
        numberOfAdultsStepper.value = Double(editingGuest.numberOfAdults)
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenStepper.value = Double(editingGuest.numberOfChildren)
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
        wifiSwitch.isOn = editingGuest.wifi
        selectedRoom = editingGuest.roomType
    }
    
    // MARK: - Custom Methods
    func updateCorrectEnteredGuest() {
        let firstNameValid = resultOfFirstNameValidation()
        let lastNameValid = resultOfLastNameValidation()
        let emailValid = resultOfEmailValidation()
        correctEnteredGuest = isRoomSelect && firstNameValid && lastNameValid && emailValid
    }
    
    func updateGuest() {
        guard correctEnteredGuest else { return }
        
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let email = emailField.text!
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let wifi = wifiSwitch.isOn
        let roomType = selectedRoom!

        guest = Registration(firstName: firstName, lastName: lastName, emailAddress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, roomType: roomType, wifi: wifi)
    }
    
    // MARK: - Text Fields Validation
    func resultOfFirstNameValidation() -> Bool {
        return !firstNameField.text!.isEmpty
    }
    
    func resultOfLastNameValidation() -> Bool {
        return !lastNameField.text!.isEmpty
    }
    
    func resultOfEmailValidation() -> Bool {
        return !emailField.text!.isEmpty
    }
    
    
    // MARK: - IB Actions
    @IBAction func textFieldChanged(_ sender: UITextField) {
        switch sender {
        case firstNameField:
            guard resultOfFirstNameValidation() else { return }
        case lastNameField:
            guard resultOfLastNameValidation() else { return }
        case emailField:
            guard resultOfEmailValidation() else { return }
        default:
            return
        }
        updateGuest()
    }
  
    @IBAction func datePickerValueChanged() {
        updateDateViews()
        updateWiFiTotalPrice()
        updateTotalPrice()
        updateGuest()
    }
    
    @IBAction func stepperValueChanged() {
        updateNumberOfGuests()
        updateGuest()
    }
    
    @IBAction func wifiSwitchChangeValue() {
        isWiFiTotalPriceShown = wifiSwitch.isOn
        updateWiFiTotalPrice()
        updateTotalPrice()
        updateGuest()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - Table View Data Source
extension AddRegistrationTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let autoHeight = UITableView.automaticDimension
        
        switch indexPath {
            
        case checkInDatePickerCellIndexPath:
            return isCheckInDatePickerShown ? autoHeight : 0
            
        case checkOutDatePickerCellIndexPath:
            return isCheckOutDatePickerShown ? autoHeight : 0
            
        case wifiTotalPriceCellIndexPath:
            return isWiFiTotalPriceShown ? autoHeight : 0
            
        case totalPriceSelectedRoomCellIndexPath:
            return isRoomSelect ? autoHeight : 0
            
        default:
            return autoHeight
            
        }
    }
}

// MARK: - Table View Delegate
extension AddRegistrationTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.reuseIdentifier == "RoomSelectCell" {
            performSegue(withIdentifier: "SelectRoomSegue", sender: nil)
        }
        
        switch indexPath {
            
        case checkInDatePickerCellIndexPath.prevRow:
            isCheckInDatePickerShown.toggle()
            isCheckOutDatePickerShown = isCheckInDatePickerShown ? false : isCheckOutDatePickerShown
            
        case checkOutDatePickerCellIndexPath.prevRow:
            isCheckOutDatePickerShown.toggle()
            isCheckInDatePickerShown = isCheckOutDatePickerShown ? false : isCheckInDatePickerShown
            
        default:
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
}

// MARK: - Text Field Delegate
extension AddRegistrationTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Segues
extension AddRegistrationTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SelectRoomSegue" else { return }
        let roomSelectTableViewController = segue.destination as! RoomSelectTableViewController
        
        roomSelectTableViewController.allRoomType = RoomType.all
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        roomSelectTableViewController.countOfDay = checkInDate.numberOfDays(between: checkOutDate)
    }
    
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard segue.identifier == "UnwindSegue" else { return }
        
        let roomSelectTableViewController = segue.source as! RoomSelectTableViewController
        
        if let selectedRoomIndexPath = roomSelectTableViewController.selectedСellIndexPath {
            selectedRoom = RoomType.all[selectedRoomIndexPath.row]
            //updateTotalPrice()
            //updateCorrectEnteredGuest()
        } else {
            selectedRoom = nil
        }
        
        updateTotalPrice()
    }
    
}

// MARK: - Keyboard Notifications
extension AddRegistrationTableViewController {
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        addTapRecognizer()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        removeTapRecognizer()
    }
    
    //dismiss keyboard by tap
    func addTapRecognizer() {
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            keyboardDismissTapGesture?.cancelsTouchesInView = false
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
    
    func removeTapRecognizer() {
        if keyboardDismissTapGesture != nil {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
