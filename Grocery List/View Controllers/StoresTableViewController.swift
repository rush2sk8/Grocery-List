//
//  StoresTableViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//
import Foundation
import UIKit

class StoresTableViewController: UITableViewController, UIAdaptivePresentationControllerDelegate {
    var stores: [Store] = [Store]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Stores"
        navigationController?.navigationBar.prefersLargeTitles = true

        reloadStores()

        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .black
        tableView.addSubview(refreshControl!)
        refreshControl!.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)

        tableView.contentInset = .init(top: 15, left: 0, bottom: 0, right: 0)
    }

    @objc func refreshTableData() {
        reloadStores()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    // just reload the store names from the userdefaults
    func reloadStores() {
        if let storeNames = DataStore.getStoreNames() {
            stores = [Store]()

            for storeName in storeNames {
                stores.append(DataStore.getStoreData(store: storeName) ?? Store(name: storeName))
            }
        }
        tableView.reloadData()
    }

    // error if they try to add the same store twice
    func showAddStoreAlertErrorDialog(storeName: String) {
        let alert = UIAlertController(title: "Store could not be added", message: "\(storeName.capitalized) already exists", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    // hide the toolbar on view appearing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
        reloadStores()
    }

    @IBAction func toStoreAdd(_: Any) {
        performSegue(withIdentifier: "toAddStore", sender: nil)
    }

    func presentationControllerDidDismiss(_: UIPresentationController) {
        reloadStores()
        tableView.reloadData()
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return stores.count
    }

    override func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Edit") { [self] _, _, completion in

            self.performSegue(withIdentifier: "toAddStore", sender: indexPath[1])
            completion(true)
        }
        action.title = "Edit"

        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }

    // style each store cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell") as! StoreCell

        let currStore = stores[indexPath[1]]

        cell.storeLabel?.text = currStore.name.capitalized
        cell.separatorInset = .init(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        cell.layoutMargins = .zero
        cell.tintColor = .black
        cell.storeLabel?.font = UIFont(name: "Avenir-Medium", size: 30)

        cell.cellImageView.image = currStore.getStoreImage()
        cell.cellImageView.tintColor = StoreIconManager.getTint(imgString: currStore.imgName)

        return cell
    }

    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.separatorInset = .init(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        cell.layoutMargins = .zero
        cell.contentView.superview?.backgroundColor = .white
        cell.backgroundColor = .white
        cell.tintColor = .black
    }

    // method to allow editing
    override func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }

    // method that will handle cell deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toRemove = stores[indexPath[1]]
            DataStore.deleteStore(store: toRemove)
            stores.remove(at: indexPath[1])
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
            DataStore.saveStores(stores: stores)
        }
    }

    // if they select the row then perform a segue to that list
    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toList", sender: indexPath[1])
    }

    // setup segue movement
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is StoreViewController {
            let vc = segue.destination as? StoreViewController
            let store = stores[(sender as? Int)!]
            vc?.store = store
        } else if segue.destination is AddStoreViewController {
            segue.destination.presentationController?.delegate = self

            let vc = segue.destination as? AddStoreViewController
            vc?.parentVC = self

            if let storeIdx = sender as? Int {
                let store = stores[storeIdx]
                vc?.storeToEdit = store
                vc?.toEdit = true
            }
        }
    }
}
