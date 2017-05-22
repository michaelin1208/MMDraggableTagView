//
//  ViewController.swift
//  MMDraggableTagViewDemo
//
//  Created by Michaelin on 2017/5/22.
//  Copyright © 2017年 Michaelin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MMDraggableTagViewDelegate {
    let titles =  ["aa","bb","cc","dd","dsdgagd","dqwehqwegqwehqwegqwehqweqwehqwhd","dsdfd","ddd","ddddd","ddasdgaegwegawegawegawehawegawegwegawegwaeg","dsadgasdgd","dd","dsagwefawdgafd","dsdgd","d"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let draggableTagView = MMDraggableTagView.init(frame:CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        draggableTagView.backgroundColor = UIColor.yellow
        draggableTagView.delegate = self
        self.view.addSubview(draggableTagView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func draggableTagView(_ draggableTagView: MMDraggableTagView, cellFor indexArray: [Int]) -> MMDraggableTagViewCell? {
        if indexArray.count == 1 && indexArray[0] < titles.count {
            
            let cell = MMDraggableTagViewCell.init(tagIndexArray: indexArray)
            cell.titleLabel.text = titles[indexArray[0]]
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 3;
            
            //            if cell.titleLabel != nil {
            //                var titleSize = titles[indexArray[0]].size(attributes: [NSFontAttributeName: UIFont.init(name: cell.titleLabel!.font.fontName, size: cell.titleLabel!.font.pointSize)!])
            //                titleSize.height += 10
            //                titleSize.width += 20
            //                cell.frame = CGRect.init(x: cell.frame.origin.x, y: cell.frame.origin.y, width: titleSize.width, height: titleSize.height)
            //            }
            
            cell.backgroundColor = UIColor.green
            
            return cell
        }
        return nil
    }
    
    func draggableTagView(_ draggableTagView: MMDraggableTagView, didSelectTag indexArray: [Int]) {
        NSLog("indexArray: \(indexArray)")
    }
    
}

