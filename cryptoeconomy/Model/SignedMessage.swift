//
//  SignedMessage.swift
//  cryptoeconomy
//
//  Created by JJ Cherng on 2020/5/8.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

class SignedMessage {
    let BEGIN_BITCOIN_SIGNED_MESSAGE = "-----BEGIN BITCOIN SIGNED MESSAGE-----\n";
    let BEGIN_SIGNATURE = "\n-----BEGIN SIGNATURE-----\n";
    let END_BITCOIN_SIGNED_MESSAGE = "\n-----END BITCOIN SIGNED MESSAGE-----";
    
    var address: String
    var signature: String
    var message: String
    
    init(address: String, signature: String, message: String) {
        self.address = address
        self.signature = signature
        self.message = message
    }
    
    init(formattedMessage: String) throws {
        
        let beginSignedMessageIdx = formattedMessage.range(of: BEGIN_BITCOIN_SIGNED_MESSAGE);
        if beginSignedMessageIdx == nil {
            throw OtkError.InvalidFormattedSignedMessage
        }
        let beginSignatureIdx = formattedMessage.range(of: BEGIN_SIGNATURE);
        if beginSignatureIdx == nil {
            throw OtkError.InvalidFormattedSignedMessage
        }
        let endSignedMessageIdx = formattedMessage.range(of: END_BITCOIN_SIGNED_MESSAGE);
        if endSignedMessageIdx == nil {
            throw OtkError.InvalidFormattedSignedMessage
        }
        let message = formattedMessage[beginSignedMessageIdx!.upperBound..<beginSignatureIdx!.lowerBound]
        let startOfAddress = beginSignatureIdx!.upperBound
        let endOfAddress = formattedMessage[beginSignatureIdx!.upperBound...].firstIndex(of: "\n")
        let address = formattedMessage[startOfAddress..<endOfAddress!]
        let startOfSig = formattedMessage.index(endOfAddress!, offsetBy: 1)
        let signature = formattedMessage[startOfSig..<endSignedMessageIdx!.lowerBound]
        
        self.address = String(address)
        self.signature = String(signature)
        self.message = String(message)
    }
    
    public func getFormattedMessage() -> String {
        let s = BEGIN_BITCOIN_SIGNED_MESSAGE + message + BEGIN_SIGNATURE + address + "\n" + signature + END_BITCOIN_SIGNED_MESSAGE
        return s
    }
    
    
}
