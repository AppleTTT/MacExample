//
//  ImageDirectoryLoader.swift
//  SlidesMagic
//
//  Created by ATM on 2017/11/6.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Foundation

class ImageDirectoryLoader: NSObject {
    
    private var imageFiles = [ImageFile]()
    private(set) var numberOfSections = 1
    var singleSectionMode = true
    
    private struct SectionAttributes {
        var sectionOffset: Int
        var sectionLength: Int
    }
    private var sectionLengthArray = [7, 5, 10, 2, 11, 7, 10, 12, 20, 25, 10, 3, 30, 25, 40]
    private var sectionsAttributesArray = [SectionAttributes]()
    
    func loadDataForFolder(_ folderUrl: URL) {
        let urls = getFilesURL(folderUrl)
        if let urls = urls {
            print("\(urls.count) images found in directory \(folderUrl.lastPathComponent)")
            for url in urls {
                print("\(url.lastPathComponent)")
            }
        }
        setupDataForUrls(urls: urls)
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return sectionsAttributesArray[section].sectionLength
    }
    
    func imageFileForIndexPath(indexPath: NSIndexPath) -> ImageFile {
        let imageIndexInImageFiles = sectionsAttributesArray[indexPath.section].sectionOffset + indexPath.item
        let imageFile = imageFiles[imageIndexInImageFiles]
        return imageFile
    }
    
    
    func setupDataForUrls(urls: [URL]?) {
        if let urls = urls {                    // When new folder
            createImageFilesForUrls(urls: urls)
        }
        
        if sectionsAttributesArray.count > 0 {  // If not first time, clean old sectionsAttributesArray
            sectionsAttributesArray.removeAll()
        }
        numberOfSections = 1
        if singleSectionMode {
            setupDataForSingleSectionMode()
        } else {
            setupDataForMultiSectionMode()
        }
        
    }
    
    private func setupDataForSingleSectionMode() {
        let sectionAttributes = SectionAttributes(sectionOffset: 0, sectionLength: imageFiles.count)
        sectionsAttributesArray.append(sectionAttributes) // sets up attributes for first section
    }
    
    private func setupDataForMultiSectionMode() {
        
        let haveOneSection = singleSectionMode || sectionLengthArray.count < 2 || imageFiles.count <= sectionLengthArray[0]
        var realSectionLength = haveOneSection ? imageFiles.count : sectionLengthArray[0]
        var sectionAttributes = SectionAttributes(sectionOffset: 0, sectionLength: realSectionLength)
        sectionsAttributesArray.append(sectionAttributes) // sets up attributes for first section
        
        guard !haveOneSection else {
            return
            
        }
        
        var offset: Int
        var nextOffset: Int
        let maxNumberOfSections = sectionLengthArray.count
        for i in 1..<maxNumberOfSections {
            numberOfSections += 1
            offset = sectionsAttributesArray[i-1].sectionOffset + sectionsAttributesArray[i-1].sectionLength
            nextOffset = offset + sectionLengthArray[i]
            if imageFiles.count <= nextOffset {
                realSectionLength = imageFiles.count - offset
                nextOffset = -1 // signal this is last section for this collection
            } else {
                realSectionLength = sectionLengthArray[i]
            }
            sectionAttributes = SectionAttributes(sectionOffset: offset, sectionLength: realSectionLength)
            sectionsAttributesArray.append(sectionAttributes)
            if nextOffset < 0 {
                break
            }
        }
    }
    
    private func createImageFilesForUrls(urls: [URL]) {
        if imageFiles.count > 0 {   // When not initial folder folder
            imageFiles.removeAll()
        }
        for url in urls {
            let imageFile = ImageFile(url: url)
            imageFiles.append(imageFile)
        }
    }
    
    
    
    private func getFilesURL(_ folderURL: URL) -> [URL]? {
        let option: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants]
        let fileNamager = FileManager.default
        let resourceValueKeys = [URLResourceKey.isRegularFileKey, URLResourceKey.typeIdentifierKey]
        let resourceSet:Set<URLResourceKey> = [URLResourceKey.isRegularFileKey, URLResourceKey.typeIdentifierKey]
        
        
        guard let directoryEnumerator = fileNamager.enumerator(at: folderURL, includingPropertiesForKeys: resourceValueKeys, options: option, errorHandler: { (url, error) -> Bool in
            print("`directoryEnumerator` error: \(error).")
            return true
        })else { return nil }
        
        var urls: [URL] = []
        for case let url as URL in directoryEnumerator {
            do {
                let resourceValues = try url.resourceValues(forKeys: resourceSet)
                guard let isRegularFileResourceValue = resourceValues.isRegularFile as NSNumber? else { continue }
                guard isRegularFileResourceValue.boolValue else { continue }
                guard let fileType = resourceValues.typeIdentifier else { continue }
                guard UTTypeConformsTo(fileType as CFString, "public.image" as CFString) else { continue }
                urls.append(url)
            }
            catch {
                print("Unexpected error occured: \(error).")
            }
        }
        return urls
    }
    
    func insertImage(image: ImageFile, at indexPath: IndexPath) {
        let imageIndexPathInImageFiles = sectionsAttributesArray[indexPath.section].sectionOffset + indexPath.item
        imageFiles.insert(image, at: imageIndexPathInImageFiles)
        
        let sectionToUpdate = indexPath.section
        sectionsAttributesArray[sectionToUpdate].sectionLength += 1
        sectionLengthArray[sectionToUpdate] += 1
        
        if sectionToUpdate < numberOfSections - 1 {
            for i in sectionToUpdate + 1...numberOfSections - 1 {
                sectionsAttributesArray[i].sectionOffset += 1
            }
        }
    }
    
    
    
    
    
    
    
}





