//
//  AddStoreViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 8/17/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import BEMCheckBox
import UIKit

class AddStoreViewController: UIViewController {
    @IBOutlet private var storeField: UITextField!

    @IBOutlet private var toolbarView: ToolBarView!

    @IBOutlet var categoriesCollection: UICollectionView!

    

    var parentVC: StoresTableViewController?

    var currentIcon: String!

    var defaults = ColorManager.defaultsArr

    var selectedCategories = Set<String>()

    var storeToEdit: Store?
    var toEdit: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbarView.addSeparator(at: .top, color: #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7960784314, alpha: 1), weight: 1.0, insets: .zero)
        storeField.inputAccessoryView = toolbarView

        storeField.attributedPlaceholder = NSAttributedString(string: "New List", attributes: [NSAttributedString.Key.foregroundColor: ColorManager.CUSTOMGRAY])

        toolbarView.add.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addList)))
        toolbarView.image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iconClicked)))

        categoriesCollection.dataSource = self
        categoriesCollection.delegate = self
        categoriesCollection.alwaysBounceVertical = true
        categoriesCollection.backgroundColor = .white

        let layout = CategoryFlowLayout(minimumInteritemSpacing: 10, minimumLineSpacing: 10, sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

        categoriesCollection.collectionViewLayout = layout
        categoriesCollection.collectionViewLayout.invalidateLayout()

        defaults.forEach { cat in
            if toEdit {
                if let cats = storeToEdit?.getCategories() {
                    if cats.contains(cat[0] as! String) {
                        self.selectedCategories.insert(cat[0] as! String)
                    }
                }
            } else {
                self.selectedCategories.insert((cat[0] as! String).lowercased())
            }
        }

        if toEdit {
            storeField.text = storeToEdit?.name.capitalized

            let defaultCats: [String] = defaults.map { x in x[0] } as! [String]

            storeToEdit?.getCategories().forEach { storeCat in
                if !defaultCats.contains(storeCat), storeCat != "other" {
                    defaults.append([storeCat, ColorManager.CUSTOMGRAY])
                    selectedCategories.insert(storeCat)
                }
            }

            // set saved image
            toolbarView.image.image = storeToEdit?.getStoreImage()
            toolbarView.image.tintColor = StoreIconManager.getTint(imgString: (storeToEdit?.imgName)!)
        }

        categoriesCollection.reloadData()

        storeField.becomeFirstResponder()

        storeField.delegate = self
        hideToolbarButtons(isHidden: true)

        currentIcon = toEdit ? storeToEdit?.imgName : (toolbarView.buttons.arrangedSubviews.first?.accessibilityIdentifier)!

        // scroll to textfield
        NotificationCenter.default.addObserver(self, selector: #selector(AddStoreViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillShow(notification _: NSNotification) {
        categoriesCollection.scrollToItem(at: IndexPath(item: defaults.count + 1, section: 0), at: .top, animated: true)
    }

    @IBAction func addStore(_: Any) {
        addList()
    }

    @IBAction func glyphClicked(sender: UIButton) {
        if let iv = sender.imageView {
            UIView.animate(withDuration: 0.5) {
                self.toolbarView.image.image = iv.image!
                self.toolbarView.image.tintColor = iv.tintColor
            }
            hideToolbarButtons(isHidden: true)
        }
        currentIcon = sender.accessibilityIdentifier!
    }

    @objc func iconClicked() {
        hideToolbarButtons(isHidden: !(toolbarView.buttons.subviews.first?.isHidden ?? false))
    }

    func hideToolbarButtons(isHidden: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.toolbarView.buttons.arrangedSubviews.forEach { button in
                let b = button as! UIButton
                b.isHidden = isHidden
            }
        }
    }

    @objc func addList() {
        if storeField.text == nil || storeField.text! == "" {
            storeField.attributedPlaceholder = NSAttributedString(string: "Enter a store name!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 0.48, blue: 0.51, alpha: 1)])

            errorTextField()
            return

        } else if !toEdit {
            if let s = DataStore.getStoreNames() {
                if let n = storeField.text {
                    if s.contains(n.lowercased()) {
                        storeField.text = ""
                        storeField.attributedPlaceholder = NSAttributedString(string: "List already exists!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 0.48, blue: 0.51, alpha: 1)])
                        errorTextField()
                        return
                    }
                }
            }
        }
        let storename = storeField.text!.lowercased()

        if toEdit {
            if let s = storeToEdit {
                var finalCategories: [Category] = [Category]()

                let existingCategories = s.categories

                existingCategories.forEach { ec in
                    if selectedCategories.contains(ec.name) {
                        finalCategories.append(ec)
                    }
                }

                let currCats = finalCategories.map { c in c.name }

                selectedCategories.forEach { sc in
                    if !currCats.contains(sc) {
                        finalCategories.append(Category(name: sc))
                    }
                }

                finalCategories.append((storeToEdit?.getCategory(name: "other"))!)

                s.categories = finalCategories
                s.imgName = currentIcon

                DataStore.deleteStore(store: s)

                // hack to save new store
                for i in 0 ..< (parentVC?.stores.count)! {
                    if parentVC?.stores[i].name == s.name {
                        parentVC?.stores.remove(at: i)
                        DataStore.saveStores(stores: parentVC!.stores)
                        break
                    }
                }

                s.name = storename
                DataStore.saveNewStore(store: storename)
                DataStore.saveStoreData(store: s)
            }
        } else {
            let store = Store(name: storename, img: currentIcon)

            // doing it this way to keep some order to the categories
            defaults.forEach { def in
                let n = def[0] as! String
                if selectedCategories.contains(n) {
                    store.addCategory(category: Category(name: n))
                }
            }

            store.addCategory(category: Category(name: "Other"))

            DataStore.saveNewStore(store: store)
        }

        if let p = parentVC {
            p.reloadStores()
            p.tableView.reloadData()
        }

        dismiss(animated: true, completion: nil)
    }

    func errorTextField() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: storeField.frame.height))
        storeField.layer.borderColor = UIColor.red.cgColor
        storeField.layer.borderWidth = 1.0
        storeField.layer.cornerRadius = 15.0
        storeField.leftView = paddingView
        storeField.leftViewMode = .always
    }
}

extension AddStoreViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return defaults.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath[1] < defaults.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCell
            let data = defaults[indexPath[1]][0] as! String
            let currColor = defaults[indexPath[1]][1] as! UIColor

            cell.label.text = data.capitalized

            cell.contentView.layer.borderWidth = 1.5
            cell.contentView.layer.cornerRadius = 15.0
            cell.checkbox.isUserInteractionEnabled = false

            cell.checkbox.offFillColor = .white
            cell.checkbox.onFillColor = .white

            if selectedCategories.contains(data.lowercased()) {
                cell.checkbox.on = true
                cell.contentView.layer.backgroundColor = currColor.cgColor
                cell.contentView.layer.borderColor = currColor.cgColor
                cell.label.textColor = .white

                cell.checkbox.onTintColor = currColor
                cell.checkbox.onCheckColor = currColor
                cell.checkbox.reload()
            } else {
                cell.checkbox.on = false
                cell.label.textColor = ColorManager.CUSTOMGRAY
                cell.contentView.layer.backgroundColor = UIColor.white.cgColor

                cell.contentView.layer.borderColor = ColorManager.CUSTOMGRAY.cgColor
                cell.checkbox.onTintColor = ColorManager.CUSTOMGRAY
                cell.checkbox.onCheckColor = .white
                cell.checkbox.reload()
            }

            cell.checkbox.onAnimationType = .fill
            cell.checkbox.offAnimationType = .bounce
            cell.checkbox.animationDuration = 0.4

            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addStoreCell", for: indexPath) as! AddStoreCell

            cell.textfield.attributedPlaceholder = NSAttributedString(string: "Add New Category", attributes: [NSAttributedString.Key.foregroundColor: ColorManager.CUSTOMGRAY])
            cell.textfield.textColor = ColorManager.CUSTOMGRAY
            cell.textfield.inputAccessoryView = toolbarView
            cell.textfield.delegate = self

            cell.contentView.addDashedBorder(color: ColorManager.CUSTOMGRAY)
            cell.contentView.layer.cornerRadius = 15.0

            return cell
        }
    }
}

extension AddStoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < defaults.count {
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
            let currColor = (defaults[indexPath[1]][1] as! UIColor).cgColor
            let isOn = !cell.checkbox.on

            cell.checkbox.setOn(isOn, animated: true)

            UIView.animate(withDuration: 0.5, animations: {
                cell.label.textColor = isOn ? .white : ColorManager.CUSTOMGRAY
                cell.contentView.layer.backgroundColor = isOn ? currColor : UIColor.white.cgColor
                cell.contentView.layer.borderColor = isOn ? currColor : ColorManager.CUSTOMGRAY.cgColor

            }, completion: { _ in
                cell.checkbox.offFillColor = .white
                cell.checkbox.onFillColor = .white

                cell.checkbox.onTintColor = isOn ? UIColor(cgColor: currColor) : ColorManager.CUSTOMGRAY
                cell.checkbox.onCheckColor = isOn ? UIColor(cgColor: currColor) : .white

            })

            if let text = cell.label.text {
                if cell.checkbox.on {
                    selectedCategories.insert(text.lowercased())
                } else {
                    selectedCategories.remove(text.lowercased())
                }
            }
        } else {
            categoriesCollection.scrollToItem(at: indexPath, at: .bottom, animated: false)
        }
    }
}

extension AddStoreViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField != storeField {
            let cell = categoriesCollection.cellForItem(at: IndexPath(row: defaults.count, section: 0)) as! AddStoreCell

            cell.contentView.removeDashedBorder()

            let currentCategories = Set(defaults.map { x in (x[0] as! String).lowercased() })

            if let text = textField.text {
                if text == "" || currentCategories.contains(text.lowercased()) || text.count > 32 || text.lowercased() == "other" {
                    cell.contentView.addDashedBorder(color: .red)
                } else {
                    defaults.append([text.lowercased(), ColorManager.CUSTOMGRAY])
                    selectedCategories.insert(text.lowercased())
                    categoriesCollection.reloadData()
                    cell.contentView.addDashedBorder(color: ColorManager.CUSTOMGRAY)
                }
            }

            textField.text = ""
        }
        return true
    }

    func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        categoriesCollection.scrollToItem(at: IndexPath(item: defaults.count + 1, section: 0), at: .right, animated: true)
        return true
    }
}

final class CategoryFlowLayout: UICollectionViewFlowLayout {
    required init(minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        super.init()

        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        sectionInsetReference = .fromSafeArea
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return layoutAttributes }

        // Filter attributes to compute only cell attributes
        let cellAttributes = layoutAttributes.filter { $0.representedElementCategory == .cell }

        // Group cell attributes by row (cells with same vertical center) and loop on those groups
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            // Set the initial left inset
            var leftInset = sectionInset.left

            // Loop on cells to adjust each cell's origin and prepare leftInset for the next cell
            for attribute in attributes {
                attribute.frame.origin.x = leftInset
                leftInset = attribute.frame.maxX + minimumInteritemSpacing
            }
        }

        return layoutAttributes
    }
}
