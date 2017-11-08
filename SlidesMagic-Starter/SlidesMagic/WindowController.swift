/*
* WindowController.swift
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

class WindowController: NSWindowController {

  override func windowDidLoad() {
    super.windowDidLoad()
    if let window = window, let screen = NSScreen.mainScreen() {
      let screenRect = screen.visibleFrame
      window.setFrame(NSRect(x: screenRect.origin.x, y: screenRect.origin.y, width: screenRect.width/2.0, height: screenRect.height), display: true)
    }
  }
  
  @IBAction func openAnotherFolder(sender: AnyObject) {
    
    let openPanel = NSOpenPanel()
    openPanel.canChooseDirectories  = true
    openPanel.canChooseFiles        = false
    openPanel.showsHiddenFiles      = false
    
    openPanel.beginSheetModalForWindow(self.window!) { (response) -> Void in
      guard response == NSFileHandlingPanelOKButton else {return}
      let viewController = self.contentViewController as? ViewController
      if let viewController = viewController, let URL = openPanel.URL {
        viewController.loadDataForNewFolderWithUrl(URL)
      }
    }
  }

}
