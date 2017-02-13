//
//  PDFManager.swift
//  PDFGenerator
//
//  Created by Developer on 2/13/17.
//  Copyright © 2017 SIC. All rights reserved.
//

import Cocoa
import Quartz

let defaultRowHeight  = CGFloat(23.0)
let defaultColumnWidth = CGFloat(150.0)
let numberOfRowsPerPage = 50

let topMargin = CGFloat(40.0)
let leftMargin = CGFloat(20.0)
let rightMargin = CGFloat(20.0)
let bottomMargin = CGFloat (40.0)
let textInset = CGFloat(5.0)
let verticalPadding = CGFloat (10.0)

class BasePDFPage :PDFPage{
    
    var hasMargin = true
    var headerText = "Default Header Text"
    var footerText = "Default Footer Text"
    
    var hasPageNumber = true
    var pageNumber = 1
    
    var pdfHeight = CGFloat(1024.0) //This is configurable
    var pdfWidth = CGFloat(768.0)   //This is configurable and is calculated based on the number of columns
    
    func drawLine( _ fromPoint:NSPoint,  toPoint:NSPoint){
        let path = NSBezierPath()
        NSColor.lightGray.set()
        path.move(to: fromPoint)
        path.line(to: toPoint)
        path.lineWidth = 0.5
        path.stroke()
        
    }
    
    func drawHeader(){
        let headerTextX = leftMargin
        let headerTextY = self.pdfHeight - CGFloat(35.0)
        let headerTextWidth = self.pdfWidth - leftMargin - rightMargin
        let headerTextHeight = CGFloat(20.0)
        
        let headerFont = NSFont(name: "Helvetica", size: 15.0)
        
        let headerParagraphStyle = NSMutableParagraphStyle()
        headerParagraphStyle.alignment = NSRightTextAlignment
        
        let headerFontAttributes = [
            NSFontAttributeName: headerFont ?? NSFont.labelFont(ofSize: 12),
            NSParagraphStyleAttributeName:headerParagraphStyle,
            NSForegroundColorAttributeName:NSColor.lightGray
        ]
        let headerRect = NSMakeRect(headerTextX, headerTextY, headerTextWidth, headerTextHeight)
        self.headerText.draw(in: headerRect, withAttributes: headerFontAttributes)
        
    }
    
    func drawFooter(){
        let footerTextX = leftMargin
        let footerTextY = CGFloat(15.0)
        let footerTextWidth = self.pdfWidth / 2.1
        let footerTextHeight = CGFloat(20.0)
        
        let footerFont = NSFont(name: "Helvetica", size: 15.0)
        
        let footerParagraphStyle = NSMutableParagraphStyle()
        footerParagraphStyle.alignment = NSLeftTextAlignment
        
        let footerFontAttributes = [
            NSFontAttributeName: footerFont ?? NSFont.labelFont(ofSize: 12),
            NSParagraphStyleAttributeName:footerParagraphStyle,
            NSForegroundColorAttributeName:NSColor.lightGray
        ]
        
        let footerRect = NSMakeRect(footerTextX, footerTextY, footerTextWidth, footerTextHeight)
        self.footerText.draw(in: footerRect, withAttributes: footerFontAttributes)
        
    }
    
    func drawMargins(){
        let borderLine = NSMakeRect(leftMargin, bottomMargin, self.pdfWidth - leftMargin - rightMargin, self.pdfHeight - topMargin - bottomMargin)
        NSColor.gray.set()
        NSFrameRectWithWidth(borderLine, 0.5)
    }
    
    func drawPageNumbers()
    {
        let pageNumTextX = self.pdfWidth/2
        let pageNumTextY = CGFloat(15.0)
        let pageNumTextWidth = CGFloat(40.0)
        let pageNumTextHeight = CGFloat(20.0)
        
        let pageNumFont = NSFont(name: "Helvetica", size: 15.0)
        
        let pageNumParagraphStyle = NSMutableParagraphStyle()
        pageNumParagraphStyle.alignment = NSCenterTextAlignment
        
        let pageNumFontAttributes = [
            NSFontAttributeName: pageNumFont ?? NSFont.labelFont(ofSize: 12),
            NSParagraphStyleAttributeName:pageNumParagraphStyle,
            NSForegroundColorAttributeName: NSColor.darkGray
        ]
        
        let pageNumRect = NSMakeRect(pageNumTextX, pageNumTextY, pageNumTextWidth, pageNumTextHeight)
        let pageNumberStr = "\(self.pageNumber)"
        pageNumberStr.draw(in: pageNumRect, withAttributes: pageNumFontAttributes)
        
    }
    
    override func bounds(for box: PDFDisplayBox) -> NSRect
    {
        return NSMakeRect(0, 0, pdfWidth, pdfHeight)
    }
    
    override func draw(with box: PDFDisplayBox) {
        if hasPageNumber{
            self.drawPageNumbers()
        }
        if hasMargin{
            self.drawMargins()
        }
        if headerText.characters.count > 0 {
            self.drawHeader()
        }
        if footerText.characters.count > 0{
            self.drawFooter()
        }
    }
    
    init(hasMargin:Bool,
         headerText:String,
         footerText:String,
         pageWidth:CGFloat,
         pageHeight:CGFloat,
         hasPageNumber:Bool,
         pageNumber:Int)
    {
        super.init()
        self.hasMargin = hasMargin
        self.headerText = headerText
        self.footerText = footerText
        self.pdfWidth = pageWidth
        self.pdfHeight = pageHeight
        self.hasPageNumber = hasPageNumber
        self.pageNumber = pageNumber
    }
    
}

class CoverPDFPage: BasePDFPage{
    var pdfTitle:NSString = "Default PDF Title"
    var creditInformation = "Default Credit Information"
    
    init(hasMargin:Bool,
         title:String,
         creditInformation:String,
         headerText:String,
         footerText:String,
         pageWidth:CGFloat,
         pageHeight:CGFloat,
         hasPageNumber:Bool,
         pageNumber:Int)
    {
        super.init(hasMargin: hasMargin,
                   headerText: headerText,
                   footerText: footerText,
                   pageWidth: pageWidth,
                   pageHeight: pageHeight,
                   hasPageNumber: hasPageNumber,
                   pageNumber: pageNumber)
        
        self.pdfTitle = title as NSString
        self.creditInformation = creditInformation
    }
    
    func drawPDFTitle()
    {
        let pdfTitleX = 1/4 * self.pdfWidth
        let pdfTitleY = self.pdfHeight / 2
        let pdfTitleWidth = 1/2 * self.pdfWidth
        let pdfTitleHeight = 1/5 * self.pdfHeight
        let titleFont = NSFont(name: "Helvetica Bold", size: 30.0)
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = NSCenterTextAlignment
        
        let titleFontAttributes = [
            NSFontAttributeName: titleFont ?? NSFont.labelFont(ofSize: 12),
            NSParagraphStyleAttributeName:titleParagraphStyle,
            NSForegroundColorAttributeName: NSColor.blue
        ]
        
        let titleRect = NSMakeRect(pdfTitleX, pdfTitleY, pdfTitleWidth, pdfTitleHeight)
        self.pdfTitle.draw(in: titleRect, withAttributes: titleFontAttributes)
        
    }
    
    func drawPDFCreditInformation()
    {
        let pdfCreditX = 1/4 * self.pdfWidth
        let pdfCreditY = self.pdfHeight / 2 - 1/5 * self.pdfHeight
        let pdfCreditWidth = 1/2 * self.pdfWidth
        let pdfCreditHeight = CGFloat(40.0)
        let creditFont = NSFont(name: "Helvetica", size: 15.0)
        
        let creditParagraphStyle = NSMutableParagraphStyle()
        creditParagraphStyle.alignment = NSCenterTextAlignment
        
        let creditFontAttributes = [
            NSFontAttributeName: creditFont ?? NSFont.labelFont(ofSize: 12),
            NSParagraphStyleAttributeName:creditParagraphStyle,
            NSForegroundColorAttributeName: NSColor.darkGray
        ]
        
        let creditRect = NSMakeRect(pdfCreditX, pdfCreditY, pdfCreditWidth, pdfCreditHeight)
        self.creditInformation.draw(in: creditRect, withAttributes: creditFontAttributes)
        
    }
    
    override func draw(with box: PDFDisplayBox) {
        super.draw(with: box)
        self.drawPDFTitle()
        self.drawPDFCreditInformation()
    }
    
}

class TabularPDFPage: BasePDFPage{
    var dataArray = [AnyObject]()
    var columnsArray = [AnyObject]()
    var verticalPadding = CGFloat(10.0)
    
    init(hasMargin:Bool,
         headerText:String,
         footerText:String,
         pageWidth:CGFloat,
         pageHeight:CGFloat,
         hasPageNumber:Bool,
         pageNumber:Int,
         pdfData:[AnyObject],
         columnArray:[AnyObject])
    {
        super.init(hasMargin: hasMargin,
                   headerText: headerText,
                   footerText: footerText,
                   pageWidth: pageWidth,
                   pageHeight: pageHeight,
                   hasPageNumber: hasPageNumber,
                   pageNumber: pageNumber
        )
        self.dataArray = pdfData
        self.columnsArray = columnArray
        
    }
    
    func drawTableData(){
        
        
        //If draws column title = YES
        let titleFont = NSFont(name: "Helvetica Bold", size: 14.0)
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = NSCenterTextAlignment
        
        let titleFontAttributes = [
            NSFontAttributeName: titleFont ?? NSFont.labelFont(ofSize: 12),
            NSParagraphStyleAttributeName:titleParagraphStyle,
            NSForegroundColorAttributeName: NSColor.gray
        ]
        
        for i in 0  ..< self.columnsArray.count {
            let columnHeader = self.columnsArray[i]
            let columnTitle = columnHeader["columnTitle"] as! NSString
            let headerRect = NSMakeRect(
                leftMargin + (CGFloat(i) * defaultColumnWidth),
                self.pdfHeight - topMargin - verticalPadding - defaultRowHeight,
                defaultColumnWidth,
                defaultRowHeight)
            
            columnTitle.draw(in: headerRect, withAttributes: titleFontAttributes)
            
        }
        
        let keys = NSMutableArray()
        for columnInfo in self.columnsArray{
            keys.add(columnInfo["columnIdentifier"] as! String)
            
        }
        
        for i in 0  ..< self.dataArray.count
        {
            let dataDict = self.dataArray[i]
            
            for j in 0  ..< keys.count {
                let dataText = dataDict[keys[j] as! String] as! NSString
                let dataRect = NSMakeRect(
                    leftMargin + textInset + (CGFloat(j) * defaultColumnWidth),
                    self.pdfHeight - topMargin - verticalPadding - (2 * defaultRowHeight) - textInset - (CGFloat(i) * defaultRowHeight),
                    defaultColumnWidth,
                    defaultRowHeight
                )
                dataText.draw(in: dataRect, withAttributes: nil)
            }
        }
        
    }
    
    func drawVerticalGrids(){
        
        for i in 0...self.columnsArray.count {
            
            //draw the vertical lines
            let fromPoint = NSMakePoint(
                leftMargin + (CGFloat(i) * defaultColumnWidth),
                self.pdfHeight - topMargin )
            
            let toPoint = NSMakePoint(
                leftMargin  + (CGFloat(i) * defaultColumnWidth),
                bottomMargin
                //self.pdfHeight - (CGFloat(self.dataArray.count + 2) * defaultRowHeight) - topMargin
            )
            
            drawLine(fromPoint, toPoint: toPoint)
        }
    }
    
    func drawHorizontalGrids(){
        let rowCount = self.dataArray.count
        for i in 0...rowCount {
            let fromPoint = NSMakePoint(
                leftMargin ,
                self.pdfHeight - topMargin - verticalPadding - defaultRowHeight - (CGFloat(i) * defaultRowHeight)
            )
            let toPoint = NSMakePoint(self.pdfWidth - rightMargin,
                                      self.pdfHeight - topMargin - verticalPadding - defaultRowHeight - (CGFloat(i) * defaultRowHeight)
            )
            drawLine(fromPoint, toPoint: toPoint)
        }
        
    }
    
    override func draw(with box: PDFDisplayBox) {
        super.draw(with: box)
        self.drawTableData()
        self.drawVerticalGrids()
        self.drawHorizontalGrids()
    }
    
    
}
