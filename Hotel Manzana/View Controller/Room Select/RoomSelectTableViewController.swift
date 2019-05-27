//
//  RoomSelectTableViewController.swift
//  Hotel Manzana
//
//  Created by Иван longrail on 12/05/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class RoomSelectTableViewController: UITableViewController {
    
    // MARK: - Properties
    var allRoomType = [RoomType]()
    var countOfDay: Int = 1
    
    var selectedСellIndexPath: IndexPath?


    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return allRoomType.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomType", for: indexPath) as! RoomSelectTableViewCell

        setup(cell, with: allRoomType[indexPath.row])

        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSelectedCell = tableView.cellForRow(at: indexPath)! as! RoomSelectTableViewCell
        setCheckmark(newSelectedCell)
        
        if selectedСellIndexPath != nil {
        let oldSelectedCell = tableView.cellForRow(at: selectedСellIndexPath!)! as! RoomSelectTableViewCell
        removeCheckmark(oldSelectedCell)
        }
        
        selectedСellIndexPath = indexPath
    }
    
    
    // MARK: - Table View Cell Setup Methods
    func setup(_ cell: RoomSelectTableViewCell, with roomType: RoomType) {
        cell.roomName.text = roomType.name
        cell.shortRoomName.text = roomType.shortName
        
        cell.pricePerDay.text = String(roomType.price) + "$"
        cell.totalPrice.text = String(roomType.price * countOfDay) + "$"
        cell.accessoryType = .none
    }
    
    // MARK: - Table View Cell Setup Methods
    func setCheckmark(_ cell: RoomSelectTableViewCell) {
        cell.accessoryType = .checkmark
    }
    
    func removeCheckmark(_ cell: RoomSelectTableViewCell) {
        cell.accessoryType = .none
    }
    
}
