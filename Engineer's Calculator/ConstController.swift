//
//  ConstController.swift
//  Engineer's Calculator
//
//  Created by Mike Griebling on 26 Aug 2017.
//  Copyright © 2017 Computer Inspirations. All rights reserved.
//

import Cocoa

class ConstController: NSViewController {

    var callback: (_ selected: String) -> () = { _ in }   // callback
    
    @IBOutlet weak var constTableView: NSTableView!
    
}

extension ConstController : NSTableViewDataSource, NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selected = constTableView.selectedRow
        let index = Constant.sorted.index(Constant.sorted.startIndex, offsetBy: selected)
        let value = Constant.sorted[index]
        callback(value.key)
        dismissViewController(self)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Constant.values.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let colName = tableColumn!.headerCell.title + "ID"
        let start = Constant.sorted.startIndex
        let index = Constant.sorted.index(start, offsetBy: row)
        let value = Constant.sorted[index]
        let text : NSAttributedString
        if colName == "DescriptionID" {
            text = NSAttributedString(string: value.value.description)
        } else {
            text = Constant.getFormattedStringFor(value.key)
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: colName), owner: self) as? NSTableCellView {
            cell.textField!.attributedStringValue = text
            return cell
        }
        
        return nil
    }
    
}
