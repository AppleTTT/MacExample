//
//  ViewController.swift
//  SlidesMagic
//
//  Created by ATM on 2017/11/6.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let imageDirectoryLoader = ImageDirectoryLoader()
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    @IBOutlet weak var addSlideButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialFolderUrl = URL.init(fileURLWithPath: "/Library/Desktop Pictures", isDirectory: true)
        imageDirectoryLoader.loadDataForFolder(initialFolderUrl)
        configureCollectionView()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func loadDataFor(_ newFolderUrl: URL) {
        imageDirectoryLoader.loadDataForFolder(newFolderUrl)
        collectionView.reloadData()
    }

    func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160, height: 140)
        flowLayout.sectionInset = NSEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 20
        collectionView.collectionViewLayout = flowLayout
        
//        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor.black.cgColor
    }
    
    @IBAction func showHideSections(_ sender: NSButton) {
        let show = sender.state
        imageDirectoryLoader.singleSectionMode = (show == .off)
        imageDirectoryLoader.setupDataForUrls(urls: nil)
        
        collectionView.reloadData()
        
    }
    
    
    func highlightItem(selected: Bool, atIndexPaths: Set<IndexPath>) {
        addSlideButton.isEnabled = collectionView.selectionIndexPaths.count == 1
    }
    
    private func insertAtIndexPathFromURLs(urls: [URL], at indexPath: IndexPath) {
        var indexPaths: Set<IndexPath> = []
        let section = indexPath.section
        var currentItem = indexPath.item
        for url in urls {
            let imageFile = ImageFile(url: url)
            let currentIndexPath = IndexPath(item: currentItem, section: section)
            imageDirectoryLoader.insertImage(image: imageFile, at: currentIndexPath)
            indexPaths.insert(currentIndexPath)
            currentItem  += 1
        }
        collectionView.insertItems(at: indexPaths)
        
    }
    @IBAction func addSlide(_ sender: NSButton) {
        
        let insertAtIndexPath = collectionView.selectionIndexPaths.first
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowsMultipleSelection = true
        openPanel.allowedFileTypes = ["public.image"]
        openPanel.beginSheetModal(for: self.view.window!, completionHandler: { (response) in
            guard response.rawValue == NSFileHandlingPanelOKButton else {return}
            self.insertAtIndexPathFromURLs(urls: openPanel.urls, at: insertAtIndexPath!)
        })
    }

}

extension ViewController : NSCollectionViewDataSource {

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return imageDirectoryLoader.numberOfSections
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDirectoryLoader.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {

        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}

        let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath: indexPath as NSIndexPath)
        collectionViewItem.imageFile = imageFile
        
        if let selectedIndexPath = collectionView.selectionIndexPaths.first, selectedIndexPath == indexPath {
            collectionViewItem.setHighlight(true)
        }else {
            collectionViewItem.setHighlight(false)
        }
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.SupplementaryElementKind.sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderView"), for: indexPath) as! HeaderView
        view.sectionTitle.stringValue = "Section \(indexPath.section)"
        let numberOfItemInSection = imageDirectoryLoader.numberOfItemsInSection(section: indexPath.section)
        view.imageCount.stringValue = "\(numberOfItemInSection) image files"
        return view
        
    }
}

extension ViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return imageDirectoryLoader.singleSectionMode ?  NSZeroSize : NSSize(width: 1000, height: 40)
    }
}

extension ViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else {
            return
        }
        guard let item = collectionView.item(at: indexPath) else {
            return
        }
        (item as! CollectionViewItem).setHighlight(true)
        highlightItem(selected: true, atIndexPaths: indexPaths)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else {
            return
        }
        guard let item = collectionView.item(at: indexPath) else {
            return
        }
        (item as! CollectionViewItem).setHighlight(false)
        highlightItem(selected: false, atIndexPaths: indexPaths)
    }

}















