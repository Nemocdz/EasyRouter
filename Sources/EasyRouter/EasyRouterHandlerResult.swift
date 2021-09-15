//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/17.
//

import Foundation

public enum EasyRouterHandlerResult {
    // 执行下一个处理者
    case next
    // 中断并结束处理
    case finish
}
