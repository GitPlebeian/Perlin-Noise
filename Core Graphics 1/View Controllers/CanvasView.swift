//
//  DrawView.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/11/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    // MARK: Properties
    
    var grid: [[Int]] = []
    var cols: Int = 0
    var rows: Int = 0
    var cellSize: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        print("Drawing")
        guard let context = UIGraphicsGetCurrentContext() else {return}
        drawGrid(context: context)
    }
    
    private func drawGrid(context: CGContext) {
        
        var cellHeight: CGFloat = 0
        var cellWidth: CGFloat = 0
        var rows: Int = 0
        var cols: Int = 0
        
        if cellSize == 0 {
            rows = self.rows
            cols = self.cols
            cellHeight = bounds.height / CGFloat(rows)
            cellWidth = bounds.width / CGFloat(cols)
        } else {
            rows = Int(bounds.height / cellSize)
            cols = Int(bounds.width / cellSize)
            cellHeight = cellSize
            cellWidth = cellSize
        }
        print("CellHeight: \(cellHeight)")
        print("CellWidth: \(cellWidth)")
        print("Cols: \(cols)")
        print("Rows: \(rows)")
        for row in 0..<rows {
            for col in 0..<cols {
                context.move(to: CGPoint(x: CGFloat(col) * cellWidth, y: CGFloat(row) * cellHeight))
                context.addLine(to: CGPoint(x: CGFloat(col) * cellWidth, y: CGFloat(row) * cellHeight))
                context.addLine(to: CGPoint(x: CGFloat(col) * cellWidth + cellWidth, y: CGFloat(row) * cellHeight))
                context.addLine(to: CGPoint(x: CGFloat(col) * cellWidth + cellWidth, y: CGFloat(row) * cellHeight + cellHeight))
                context.addLine(to: CGPoint(x: CGFloat(col) * cellWidth, y: CGFloat(row) * cellHeight + cellHeight))
                context.closePath()
                var fillColor: CGColor
                let randomInt = Int.random(in: 0..<5)
                switch randomInt {
                case 0: fillColor = UIColor.blue.cgColor
                case 1: fillColor = UIColor.red.cgColor
                case 2: fillColor = UIColor.yellow.cgColor
                case 3: fillColor = UIColor.green.cgColor
                case 4: fillColor = UIColor.purple.cgColor
                default: fillColor = UIColor.black.cgColor
                }
                context.setFillColor(fillColor)
                context.fillPath()
            }
        }
    }
    
    
    // MARK: Public Functions
    
    func setColsAndRows(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
    }
    
    func setCellSize(cellSize: CGFloat) {
        self.cellSize = cellSize
    }
    
    func render() {
        setNeedsDisplay()
    }
}
