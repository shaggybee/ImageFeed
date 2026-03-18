//
//  AppLogger.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 18.03.2026.
//

import Foundation
import Logging

final class AppLogger {
    static let shared = AppLogger()
    
    private let logger = Logger(label: "")
    
    private init() {}
}

extension AppLogger: AppLoggerProtocol {
    func error(_ message: String) {
        logger.error(Logger.Message(stringLiteral: message))
    }
}
