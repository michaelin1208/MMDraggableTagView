//
//  MMDraggableTagView.swift
//  ChargeApp
//
//  Created by Michaelin on 2017/3/14.
//  Copyright © 2017年 Michaelin. All rights reserved.
//

import UIKit
import SnapKit

let padding:CGFloat = 10
let cellHeightPadding:CGFloat = 5
let cellWidthPadding:CGFloat = 10

@objc protocol MMDraggableTagViewDelegate: NSObjectProtocol {
    func draggableTagView(_ draggableTagView:MMDraggableTagView, cellFor indexArray:[Int]) -> MMDraggableTagViewCell?
    @objc optional func draggableTagView(_ draggableTagView:MMDraggableTagView, didSelectTag indexArray:[Int])
    @objc optional func draggableTagView(_ draggableTagView:MMDraggableTagView, didDeselectTag indexArray:[Int])
    @objc optional func draggableTagView(_ draggableTagView:MMDraggableTagView, shouldSelectTag indexArray:[Int]) -> Bool
    @objc optional func draggableTagView(_ draggableTagView:MMDraggableTagView, shouldDeselectTag indexArray:[Int]) -> Bool
    
}

class MMDraggableTagView: UIView, MMDraggableTagViewCellDelegate {
    weak var delegate : MMDraggableTagViewDelegate?
    var selectedTags:[[Int]]?
    var cells:[MMDraggableTagViewCell] = []
    var draggingCell:MMDraggableTagViewCell?
    var originalCell:MMDraggableTagViewCell?
    var isFirstLoad = true
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLoad {
            isFirstLoad = false
            reloadData()
        }
    }
    
    func reloadData() {
        cells.removeAll()
        drawTagView(at: [0])
        
        relocateTags()
    }
    
    func drawTagView(at indexArray:[Int]) {
        NSLog("indexArray: \(indexArray)")
        var indexArr = indexArray
        let cell = delegate?.draggableTagView(self, cellFor: indexArray)
        if (cell != nil) {
            
            if cell!.frame.size.width == 0 && cell!.titleLabel != nil && cell!.titleLabel!.text != nil{
                
                var titleSize = cell!.titleLabel!.text!.size(attributes: [NSFontAttributeName: UIFont.init(name: cell!.titleLabel!.font.fontName, size: cell!.titleLabel!.font.pointSize)!])
                cell!.titleLabel!.frame = CGRect(x: 10, y: 5, width: titleSize.width, height: titleSize.height)
                titleSize.height += cellHeightPadding * 2
                titleSize.width += cellWidthPadding * 2
                cell!.frame = CGRect.init(x: cell!.frame.origin.x, y: cell!.frame.origin.y, width: titleSize.width, height: titleSize.height)
                
            }
            
            cell!.delegate = self
            self.addSubview(cell!)
            
            cells.append(cell!)
            
            
            indexArr.append(0)
            self.drawTagView(at: indexArr)
        }else{
            if indexArr.count > 1 {
                indexArr.removeLast()
                indexArr[indexArr.count-1] += 1
                self.drawTagView(at: indexArr)
            }
        }
    }
    
    func relocateTags() {
        var lastTagViewInThisLevel:UIView?
        var lastTagViewInLastLevel:UIView?
        var currentX = padding
        for tagView in cells {
//            if draggingCell != nil {
//            }
            if lastTagViewInThisLevel == nil {
                if lastTagViewInLastLevel == nil {
                    tagView.snp.remakeConstraints({ (make) in
                        make.top.equalTo(self).offset(padding)
                        make.left.equalTo(self).offset(padding)
                        if (tagView.frame.width + padding * 2 > self.frame.width) {
                            make.width.equalTo(self.frame.width - padding * 2)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = nil
                            lastTagViewInLastLevel = tagView
                            currentX = padding
                        }else{
                            make.width.equalTo(tagView.frame.width)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = tagView
                            currentX = currentX + tagView.frame.width + padding
                        }
                    })
                }else{
                    tagView.snp.remakeConstraints({ (make) in
                        make.top.equalTo(lastTagViewInLastLevel!.snp.bottom).offset(padding)
                        make.left.equalTo(self).offset(padding)
                        if (tagView.frame.width + padding * 2 > self.frame.width) {
                            make.width.equalTo(self.frame.width - padding * 2)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = nil
                            lastTagViewInLastLevel = tagView
                            currentX = padding
                        }else{
                            make.width.equalTo(tagView.frame.width)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = tagView
                            currentX = currentX + tagView.frame.width + padding
                        }
                    })
                }
            }else{
                tagView.snp.remakeConstraints({ (make) in
                    if (currentX + tagView.frame.width + padding > self.frame.width) {
                        lastTagViewInLastLevel = lastTagViewInThisLevel
                        lastTagViewInThisLevel = tagView
                        currentX = padding
                        make.top.equalTo(lastTagViewInLastLevel!.snp.bottom).offset(padding)
                        make.left.equalTo(self).offset(padding)
                        if (tagView.frame.width + padding * 2 > self.frame.width) {
                            make.width.equalTo(self.frame.width - padding * 2)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = nil
                            lastTagViewInLastLevel = tagView
                            currentX = padding
                        }else{
                            make.width.equalTo(tagView.frame.width)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = tagView
                            currentX = currentX + tagView.frame.width + padding
                        }
                    }else{
                        
                        if lastTagViewInLastLevel == nil {
                            make.top.equalTo(self).offset(padding)
                        }else{
                            make.top.equalTo(lastTagViewInLastLevel!.snp.bottom).offset(padding)
                        }
                        make.left.equalTo(lastTagViewInThisLevel!.snp.right).offset(padding)
                        make.width.equalTo(tagView.frame.width)
                        make.height.equalTo(tagView.frame.height)
                        lastTagViewInThisLevel = tagView
                        currentX = currentX + tagView.frame.width + padding
                    }
                })
                
            }
        }
    }
    
    func replaceObject(_ originCell:MMDraggableTagViewCell, inCellsByObject targetCell:MMDraggableTagViewCell) -> Int? {
        let replaceIndex = cells.index(of: originCell)
        if replaceIndex != nil {
            cells.insert(targetCell, at: replaceIndex!)
            cells.remove(at: replaceIndex! + 1)
            return replaceIndex
        }
        return nil
    }

//MARK:- MMDraggableTagViewCellDelegate
    
    func draggableTagViewCell(_ draggableTagViewCell: MMDraggableTagViewCell, didClickedIn location:CGPoint) {
        if draggableTagViewCell.status == .Normal {
            var shouldSelect = true
            if (delegate?.draggableTagView?(self, shouldSelectTag: draggableTagViewCell.tagIndex) != nil) {
                shouldSelect = (delegate?.draggableTagView?(self, shouldSelectTag: draggableTagViewCell.tagIndex))!
            }
            if shouldSelect {
                draggableTagViewCell.setStatus(.Selected)
                delegate?.draggableTagView?(self, didSelectTag: draggableTagViewCell.tagIndex)
            }
        }else if draggableTagViewCell.status == .Selected {
            var shouldSelect = true
            if (delegate?.draggableTagView?(self, shouldDeselectTag: draggableTagViewCell.tagIndex) != nil) {
                shouldSelect = (delegate?.draggableTagView?(self, shouldDeselectTag: draggableTagViewCell.tagIndex))!
            }
            if shouldSelect {
                draggableTagViewCell.setStatus(.Normal)
                delegate?.draggableTagView?(self, didDeselectTag: draggableTagViewCell.tagIndex)
            }
        }
    }
    
    func draggableTagViewCell(_ draggableTagViewCell: MMDraggableTagViewCell, startDraggingFrom location:CGPoint) {
        NSLog("start dragging")
        originalCell = MMDraggableTagViewCell.init(tagIndexArray: draggableTagViewCell.tagIndex)
        originalCell!.backgroundColor = UIColor.darkGray   //TODO: this darkgray is used to test
        //originalCell!.titleLabel.text = "test test test"
        
        //originalCell!.layer.masksToBounds = true
        //originalCell!.layer.borderColor = UIColor.blue.cgColor
        //originalCell!.layer.borderWidth = 1
        //originalCell!.layer.cornerRadius = 3;
        
        originalCell!.frame = draggableTagViewCell.frame
        
        self.addSubview(originalCell!)
        NSLog("frame \(originalCell!.frame)")
        let replaceIndex = replaceObject(draggableTagViewCell, inCellsByObject: originalCell!)
        NSLog("replaceIndex \(replaceIndex)")
        
        draggingCell = draggableTagViewCell
        draggingCell!.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(draggingCell!.frame.origin.y)
            make.left.equalTo(self).offset(draggingCell!.frame.origin.x)
        }
        
        self.bringSubview(toFront: draggableTagViewCell)
    }
    
    func draggableTagViewCell(_ draggableTagViewCell: MMDraggableTagViewCell, draggingFrom location:CGPoint) {
        NSLog("\(location) is dragging")
        var position = findInsertPosition(cells, with: location)
        NSLog("position \(position)")
        if originalCell != nil && position == -1 && originalCell!.superview != nil && cells.contains(originalCell!){
            cells.remove(at: cells.index(of: originalCell!)!)
            originalCell!.removeFromSuperview()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.relocateTags()         // update autolayout constraints by SnapKit.
                self.layoutIfNeeded()       // call layout method if needed to update subviews.
            })
            
        }else if originalCell != nil && position >= 0 && position <= cells.count {
            if cells.contains(originalCell!) {
                if cells.index(of: originalCell!)! < position {
                    position -= 1
                }
                cells.remove(at: cells.index(of: originalCell!)!)
            }
            if originalCell!.superview == nil {
                self.addSubview(originalCell!)
            }
            cells.insert(originalCell!, at: position)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.relocateTags()
                self.layoutIfNeeded()
            })
            
        }
    }
    
    func findInsertPosition(_ cells:[UIView], with location:CGPoint) -> Int {
        var index = 0
        var lastCell:MMDraggableTagViewCell?
        var nextCell:MMDraggableTagViewCell?
        for tempC in cells {
            let tempCell = tempC as! MMDraggableTagViewCell
            
            if location.y > tempCell.frame.origin.y && location.y <= tempCell.frame.origin.y + tempCell.frame.size.height + padding {
                if location.x < tempCell.frame.origin.x + tempCell.frame.size.width * 1 / 4 {
                    nextCell = tempCell
                }else if location.x > tempCell.frame.origin.x + tempCell.frame.size.width * 3 / 4 {
                    lastCell = tempCell
                }
                
                if nextCell != nil {
                    return index
                }
                
            }else if lastCell != nil {
                return index
            }
            
            index += 1
            
        }
        if cells.first != nil && location.y < cells.first!.frame.origin.y {
            return 0
        }else if cells.last != nil && location.y > cells.last!.frame.origin.y + cells.last!.frame.size.height {
            return cells.count
        }else if lastCell != nil {
            return cells.count
        }
        
        return -1;

    }
    
    func draggableTagViewCell(_ draggableTagViewCell: MMDraggableTagViewCell, draggedFrom location:CGPoint) {
        NSLog("dragging finished")
        
        if originalCell != nil && draggingCell != nil {
            
//            UIView.animate(withDuration: 0.2, animations: {
//                NSLog("self.draggingCell!.frame \(self.draggingCell!.frame)")
//                NSLog("self.originalCell!.frame \(self.originalCell!.frame)")
//                NSLog("self.draggingCell!.transform \(self.draggingCell!.transform)")
//                NSLog("self.originalCell!.transform \(self.originalCell!.transform)")
//                self.draggingCell!.frame = self.originalCell!.frame
//                
//            })
            
            
            let replaceIndex = replaceObject(originalCell!, inCellsByObject: draggingCell!)
            NSLog("replaceIndex \(replaceIndex)")
            originalCell!.removeFromSuperview()
            draggingCell = nil
            
            UIView.animate(withDuration: 0.2, animations: {
                self.relocateTags()
                self.layoutIfNeeded()
            })
        }
        
    }
    
}
