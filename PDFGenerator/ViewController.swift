//
//  ViewController.swift
//  PDFGenerator
//
//  Created by Mihail Salari on 2/13/17.
//  Copyright © 2017 SIC. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController {

    // MARK: - Properties
    
    @IBOutlet weak var infoLabel: NSTextField!
    
    fileprivate var dataArray = [AnyObject]()
    
    fileprivate let columnInformationArray =
        [
            ["columnIdentifier":"col1","columnTitle":"Column Title 1"],
            ["columnIdentifier":"col2","columnTitle":"Column Title 2"],
            ["columnIdentifier":"col3","columnTitle":"Column Title 3"],
            ["columnIdentifier":"col4","columnTitle":"Column Title 4"],
            ["columnIdentifier":"col5","columnTitle":"Column Title 5"],
            ["columnIdentifier":"col6","columnTitle":"Column Title 6"],
            ["columnIdentifier":"col7","columnTitle":"Column Title 7"],
            ["columnIdentifier":"col8","columnTitle":"Column Title 8"],
            ]
    
    
    // MARK: - LyfeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataArray = self.createDemoData()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}


extension ViewController {
  
    fileprivate func createDemoData()->Array<AnyObject>{
        let mArray = NSMutableArray()
        
        for i in 0 ..< 800 {
            let dict = [
                "col1":"col 1 data \(i)",
                "col2":"col 2 data \(i)",
                "col3":"col 3 data \(i)",
                "col4":"col 4 data \(i)",
                "col5":"col 5 data \(i)",
                "col6":"col 6 data \(i)",
                "col7":"col 7 data \(i)",
                "col8":"col 8 data \(i)"
            ]
            mArray.add(dict)
        }
        return Array(mArray) as Array<AnyObject>
    }
}


extension ViewController {
    
    @IBAction func generatePDF (_ sender:NSButton){
        
        let aPDFDocument = PDFDocument()
        
        let coverPage = CoverPDFPage(hasMargin: true,
                                     title: "This is the cover page title. Keep it short or keep it long",
                                     creditInformation: "Created By: github.com \r Feb 2017",
                                     headerText: "Some confidential info",
                                     footerText: "www.github.com",
                                     pageWidth: CGFloat(900.0),
                                     pageHeight: CGFloat(1200.0),
                                     hasPageNumber: true,
                                     pageNumber: 1)
        
        
        
        aPDFDocument.insert(coverPage, at: 0)
        
        let pageWidth = (CGFloat(Float(self.columnInformationArray.count)) * defaultColumnWidth) + leftMargin
        let pageHeight = topMargin + verticalPadding + (CGFloat(numberOfRowsPerPage + 1) * defaultRowHeight) + verticalPadding + bottomMargin
        
        
        var numberOfPages = self.dataArray.count / numberOfRowsPerPage
        
        if self.dataArray.count % numberOfRowsPerPage > 0 {
            numberOfPages += 1
        }
        
        for i in 0 ..< numberOfPages
        {
            
            let startIndex = i * numberOfRowsPerPage
            var endIndex = i * numberOfRowsPerPage + numberOfRowsPerPage
            
            if endIndex > self.dataArray.count{
                endIndex = self.dataArray.count
            }
            
            let pdfDataArray:[AnyObject] = Array(self.dataArray[startIndex..<endIndex])
            
            let tabularDataPDF = TabularPDFPage (hasMargin: true,
                                                 headerText: "confidential info...",
                                                 footerText: "www.github.com",
                                                 pageWidth: pageWidth,
                                                 pageHeight: pageHeight,
                                                 hasPageNumber: true,
                                                 pageNumber: i+1,
                                                 pdfData: pdfDataArray,
                                                 columnArray: columnInformationArray as [AnyObject])
            
            aPDFDocument.insert(tabularDataPDF, at: i+1)
        }
        
        aPDFDocument.write(toFile: "/Users/developer/sample1.pdf")
        
        self.infoLabel.isHidden = false
        self.infoLabel.stringValue = "Document saved to: /Users/developer/sample1.pdf"
    }
}

