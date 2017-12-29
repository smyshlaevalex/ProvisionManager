//
//  ViewController.swift
//  ProvisionManager
//
//  Created by Alexander Smyshlaev on 3/26/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var bundleIdLabel: NSTextField!
    @IBOutlet weak var creationDateLabel: NSTextField!
    @IBOutlet weak var expirationDateLabel: NSTextField!
    @IBOutlet weak var amountOfDaysLabel: NSTextField!
    @IBOutlet weak var daysLeftLabel: NSTextField!

    var provisions: [ProvisionProfile]?
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        provisions = ProvisionLoader.provisions
        
        tableView.reloadData()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        tableView.selectRowIndexes([0], byExtendingSelection: true)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func updateProvisionInfo(with provision: ProvisionProfile) {
        bundleIdLabel.stringValue = provision.applicationIdentifier
        creationDateLabel.stringValue = formatter.string(from: provision.creationDate)
        expirationDateLabel.stringValue = formatter.string(from: provision.expirationDate)
        amountOfDaysLabel.integerValue = provision.aasdadasdasdas
        
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: provision.expirationDate).day! + 1
        
        if daysLeft > 0 {
            daysLeftLabel.integerValue = daysLeft
            daysLeftLabel.textColor = .green
        } else {
            daysLeftLabel.stringValue = "Expired"
            daysLeftLabel.textColor = .red
        }
    }
    
    @IBAction func export(_ sender: NSButton) {
        let provision = provisions![tableView.selectedRow]
        
        let savePanel = NSSavePanel()
        
        let fileNameCharacters = provision.applicationIdentifier.components(separatedBy: ".").reduce("") { $0+"-"+$1 } .dropFirst()
        let fileName = String(fileNameCharacters)
        
        savePanel.nameFieldStringValue = "\(fileName).mobileprovision"
        
        savePanel.beginSheetModal(for: view.window!) { result in
            if result == .OK {
                try! FileManager.default.copyItem(at: URL(fileURLWithPath: provision.pathToFile), to: savePanel.url!)
            }
        }
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return provisions?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) as! ProvisionCell
        
        cell.bundleIdLabel.stringValue = provisions![row].applicationIdentifier
        
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: provisions![row].expirationDate).day! + 1
        
        if daysLeft > 0 {
            cell.daysLeftLabel.stringValue = "\(daysLeft) days"
            cell.daysLeftLabel.textColor = .green
        } else {
            cell.daysLeftLabel.stringValue = "Expired"
            cell.daysLeftLabel.textColor = .red
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard (0..<provisions!.count).contains(tableView.selectedRow) else {
            return
        }
        
        updateProvisionInfo(with: provisions![tableView.selectedRow])
    }
}
