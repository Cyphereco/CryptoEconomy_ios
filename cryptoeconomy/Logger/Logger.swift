//
//  Logger.swift
//  PromiseAndAlamofireDemo
//
//  Created by JJ Cherng on 2020/4/1.
//  Copyright © 2020 Cyphereco OÜ. All rights reserved.
//

import Foundation
import Log4swift

class Logger {
    static let shared = Logger()
    
    let logger = Log4swift.Logger.getLogger("Cyphereco")
    
    public func debug<T>(_ object: T, filename: String = #file, line: Int = #line, funcname: String = #function) {
        logger.debug("***** \(filename.components(separatedBy: "/").last ?? "") (line: \(line)) :: \(funcname) :: \(object)")
    }
    public func info<T>(_ object: T, filename: String = #file, line: Int = #line, funcname: String = #function) {
        logger.info("***** \(filename.components(separatedBy: "/").last ?? "") (line: \(line)) :: \(funcname) :: \(object)")
    }
    public func warning<T>(_ object: T, filename: String = #file, line: Int = #line, funcname: String = #function) {
        logger.warning("***** \(filename.components(separatedBy: "/").last ?? "") (line: \(line)) :: \(funcname) :: \(object)")
    }
    public func error<T>(_ object: T, filename: String = #file, line: Int = #line, funcname: String = #function) {
        logger.error("***** \(filename.components(separatedBy: "/").last ?? "") (line: \(line)) :: \(funcname) :: \(object)")
    }
}
