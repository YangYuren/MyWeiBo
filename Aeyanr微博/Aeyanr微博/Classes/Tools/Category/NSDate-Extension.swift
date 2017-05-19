//
//  NSDate-Extension.swift
//  timeTool
//
//  Created by Yang on 2017/5/19.
//  Copyright © 2017年 Yang. All rights reserved.
//

import Foundation
extension Date{
    static func createString(creatAtStr : String) -> String{
        
        //1 创建时间格式化对象
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy "
        fmt.locale = Locale(identifier: "en")
        //将字符串转为Date类型
        guard let createDate = fmt.date(from: creatAtStr) else {
            return ""
        }
        //创建当前时间
        let nowDate = Date()
        //计算创建时间与当前时间的时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        //对当前时间进行分割处理
        if interval < 60 {
            return "刚刚"
        }
        if interval < 60 * 60 {
            return "\(interval/60)分钟前"
        }
        if interval < 60 * 60 * 24{
            return "\(interval/(60 * 60))小时前"
        }
        //创建日历对象
        let calendar = Calendar.current
        //处理昨天数据
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        //处理一年之内的数据
        let cms = calendar.dateComponents([Calendar.Component.year], from: createDate, to: nowDate)
        if cms.year! < 1{
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        //处理一年之后的数据
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: createDate)
        return timeStr
    }
}
