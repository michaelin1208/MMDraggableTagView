//
//  MMDraggableTagData.swift
//  ChargeApp
//
//  Created by Michaelin on 2017/3/14.
//  Copyright © 2017年 Michaelin. All rights reserved.
//

import Foundation

class MMDraggableTagData {
    
    private var name:NSString!
    private(set) var dataArray:NSMutableArray?
    
    init() {
        let defaults = UserDefaults.standard
        let storedTagData = defaults.object(forKey: "TagData") as? NSDictionary
        let tagData = storedTagData != nil ? MMDraggableTagData.init(tagDataDic: storedTagData!) : MMDraggableTagData.init(tagName:"")
        self.name = tagData.name
        self.dataArray = tagData.dataArray
    }
    
    init(tagName:NSString!) {
        self.name = tagName
//        self.dataArray = NSMutableArray.init()
    }
    
    init(tagDataDic:NSDictionary) {
        let tagName:NSString? = tagDataDic.object(forKey: "tagName") as! NSString?
        if tagName != nil {
            self.name = tagName
            let subTagArray:[NSDictionary]? = tagDataDic.object(forKey: "subTagArray") as! [NSDictionary]?
            if subTagArray != nil {
                for subTag in subTagArray! {
                    self.addTagData(MMDraggableTagData.init(tagDataDic: subTag))
                }
            }
        }else{
            self.name = ""
        }
    }
    
    func addTagData(_ tagData:MMDraggableTagData) {
        if (dataArray == nil) {
            dataArray = NSMutableArray.init()
        }
        dataArray!.add(tagData)
    }
    
    func addTagData(_ tagData:MMDraggableTagData, at index:Int) {
        if (dataArray == nil) {
            dataArray = NSMutableArray.init()
        }
        dataArray!.insert(tagData, at: index)
    }
    
    func removeTagData(at index:Int) {
        if (dataArray != nil) {
            if dataArray!.count > index {
                dataArray!.removeObject(at: index)
            }
        }
    }
    
    func subTagDatas() -> NSMutableArray {
        if (dataArray == nil) {
            dataArray = NSMutableArray.init()
        }
        return dataArray!.mutableCopy() as! NSMutableArray
    }

    func setSubTagDatas(_ subTagDatas:NSMutableArray) {
        dataArray = subTagDatas
    }
    
    func convertDic() -> NSDictionary {
        let resultDic = NSMutableDictionary.init()
        resultDic.setObject(self.name, forKey: "tagName" as NSCopying)
        
        if self.dataArray != nil {
            let subTagArray = NSMutableArray.init()
            for subTagData in self.dataArray! {
                subTagArray.add((subTagData as! MMDraggableTagData).convertDic())
            }
            resultDic.setObject(subTagArray, forKey: "subTagArray" as NSCopying)
        }
        
        return resultDic
    }
    
    func seveTagDataDic() {
        let defaults = UserDefaults.standard
        defaults.set(self.convertDic(), forKey: "TagData")
        defaults.synchronize()
    }
}
