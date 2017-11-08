/*
* ImageDirectoryLoader.swift
* SlidesMagic
*
* Created by Gabriel Miro on 7/11/15.
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Cocoa

class ImageDirectoryLoader: NSObject {
  
  private var imageFiles = [ImageFile]()
  private(set) var numberOfSections = 1   // Read       by ViewController
  var singleSectionMode = true            // Read/Write by ViewController
  
  private struct SectionAttributes {
    var sectionOffset: Int  // the index of the first image of this section in the imageFiles array
    var sectionLength: Int  // number of images in the section
  }
  
  // sectionLengthArray - An array of randomly picked integers just for demo purposes. 
  // sectionLengthArray[0] is 7, i.e. put the first 7 images from the imageFiles array into section 0
  // sectionLengthArray[1] is 5, i.e. put the next 5 images from the imageFiles array into section 1
  // and so on...
  private let sectionLengthArray = [7, 5, 10, 2, 11, 7, 10, 12, 20, 25, 10, 3, 30, 25, 40]
  private var sectionsAttributesArray = [SectionAttributes]()
  
  func setupDataForUrls(urls: [NSURL]?) {
    
    if let urls = urls {                    // When new folder
      createImageFilesForUrls(urls)
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
    
    guard !haveOneSection else {return}
    
    var offset: Int
    var nextOffset: Int
    let maxNumberOfSections = sectionLengthArray.count
    for i in 1..<maxNumberOfSections {
      numberOfSections++
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
  
  private func createImageFilesForUrls(urls: [NSURL]) {
    if imageFiles.count > 0 {   // When not initial folder folder
      imageFiles.removeAll()
    }
    for url in urls {
      let imageFile = ImageFile(url: url)
      imageFiles.append(imageFile)
    }
  }
  
  private func getFilesURLFromFolder(folderURL: NSURL) -> [NSURL]? {
    
    let options: NSDirectoryEnumerationOptions =
    [.SkipsHiddenFiles, .SkipsSubdirectoryDescendants, .SkipsPackageDescendants]
    let fileManager = NSFileManager.defaultManager()
    let resourceValueKeys = [NSURLIsRegularFileKey, NSURLTypeIdentifierKey]
    
    guard let directoryEnumerator = fileManager.enumeratorAtURL(folderURL, includingPropertiesForKeys: resourceValueKeys,
      options: options, errorHandler: { url, error in
        print("`directoryEnumerator` error: \(error).")
        return true
    }) else { return nil }
    
    var urls: [NSURL] = []
    for case let url as NSURL in directoryEnumerator {
      do {
        let resourceValues = try url.resourceValuesForKeys(resourceValueKeys)
        guard let isRegularFileResourceValue = resourceValues[NSURLIsRegularFileKey] as? NSNumber else { continue }
        guard isRegularFileResourceValue.boolValue else { continue }
        guard let fileType = resourceValues[NSURLTypeIdentifierKey] as? String else { continue }
        guard UTTypeConformsTo(fileType, "public.image") else { continue }
        urls.append(url)
      }
      catch {
        print("Unexpected error occured: \(error).")
      }
    }
    return urls
  }
  
  func numberOfItemsInSection(section: Int) -> Int {
    return sectionsAttributesArray[section].sectionLength
  }
  
  func imageFileForIndexPath(indexPath: NSIndexPath) -> ImageFile {
    let imageIndexInImageFiles = sectionsAttributesArray[indexPath.section].sectionOffset + indexPath.item
    let imageFile = imageFiles[imageIndexInImageFiles]
    return imageFile
  }
  
  func loadDataForFolderWithUrl(folderURL: NSURL) {
    let urls = getFilesURLFromFolder(folderURL)
    if let urls = urls {
      print("\(urls.count) images found in directory \(folderURL.lastPathComponent!)")
      for url in urls {
        print("\(url.lastPathComponent!)")
      }
    }
    setupDataForUrls(urls)
  }
  
}