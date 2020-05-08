//
//  OtkErrors.swift
//  cryptoeconomy
//
//  Created by JJ Cherng on 2020/5/8.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

public enum OtkError: Error {
    case InvalidSignature
    case InvalidFormattedSignedMessage
}
