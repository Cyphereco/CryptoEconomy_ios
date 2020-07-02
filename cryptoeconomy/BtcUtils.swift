//
//  BtcUtils.swift
//  cryptoeconomy
//
//  Created by JJ Cherng on 2020/4/2.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation
import BigInt

extension Data {
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

class BtcUtils {
    /*
     * Convert satoshi to BTC
     */
    static func satoshiToBtc(satoshi: Int64) -> Double {
        return (Double(satoshi) / 100000000.0)
    }
    
    /*
     * Convert BTC to satoshi
     */
    static func BtcToSatoshi(btc: Double) -> Int64 {
        return Int64(truncating: NSNumber(value: (btc * 100000000.0)))
    }
    
    /*
     * Convert S to low s value
     */
    static func lowSValue(s: BigUInt) -> BigUInt {
        let HALF_CURVE_ORDER = BigUInt("7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0", radix: 16)!
        let CURVE_ORDER = BigUInt("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141", radix: 16)!
        
        if s > HALF_CURVE_ORDER {
            return CURVE_ORDER - s
        }
        return s
    }
    
    static func bigUIntFromUInt32Array(nums: [UInt32]) -> BigUInt {
        assert(nums.count == 8, "Num array count must be 8")

        var num1: UInt = UInt(nums[6])
        num1 = num1 << 32
        num1 += UInt(nums[7])

        var num2: UInt = UInt(nums[4])
        num2 = num2 << 32
        num2 += UInt(nums[5])

        var num3: UInt = UInt(nums[2])
        num3 = num3 << 32
        num3 += UInt(nums[3])

        var num4: UInt = UInt(nums[0])
        num4 = num4 << 32
        num4 += UInt(nums[1])

        let value = BigUInt(words: [num1, num2, num3, num4])

        return value
    }

    static func toDER(sigHexString: String) -> NSData {
        
        var (r, s) = BtcUtils.toRS(hexString: sigHexString)
        s = BtcUtils.lowSValue(s: s)

        var r_bytes = [UInt8](r.serialize() as NSData)
        var s_bytes = [UInt8](s.serialize() as NSData)
        
        //r and s is unsigned, so if first byte of r or s is > 7f, append 0x00 as prefix
        // if first byte of r or s is > 7f, the highest bit is 1, which means negative when it is signed, r and s are unsigned though.
        if r_bytes[0] > 0x7f {
            r_bytes.insert(0x00, at: 0)
        }
        if s_bytes[0] > 0x7f {
            s_bytes.insert(0x00, at: 0)
        }

        var z: [UInt8] = [0x02]
        z.append(UInt8(r_bytes.count))
        z += r_bytes
        z.append(0x02)
        z.append(UInt8(s_bytes.count))
        z += s_bytes

        var bytes: [UInt8] = [0x30]

        bytes.append(UInt8(z.count))
        bytes += z

        let signature = NSData(bytes: bytes, length: bytes.count)
        
        return signature
    }
    
    static func toRS(hexString: String) -> (BigUInt, BigUInt) {
        return toRS(Data(hexString: hexString)! as NSData)
    }
    
    static func toRS(_ data: NSData) -> (BigUInt, BigUInt) {
        var R: [UInt32] = [0,0,0,0,0,0,0,0]
        var S: [UInt32] = [0,0,0,0,0,0,0,0]

        data.getBytes(&R, range: NSMakeRange(0, 0x20))
        data.getBytes(&S, range: NSMakeRange(32, 0x20))

        let r = bigUIntFromUInt32Array(nums: [R[0].bigEndian, R[1].bigEndian, R[2].bigEndian, R[3].bigEndian, R[4].bigEndian, R[5].bigEndian, R[6].bigEndian, R[7].bigEndian])

        let s = bigUIntFromUInt32Array(nums: [S[0].bigEndian, S[1].bigEndian, S[2].bigEndian, S[3].bigEndian, S[4].bigEndian, S[5].bigEndian, S[6].bigEndian, S[7].bigEndian])

        return (r, s)
    }

    static func removePrefixFromAddress(addressStr: String) -> String {
        var addr: String = addressStr
        if addressStr.contains(":") {
            let prefixBtcString = "bitcoin:"
            addr = String(addressStr.suffix(from: addressStr.index(addressStr.startIndex, offsetBy: prefixBtcString.count)))
        }
        return addr
    }

    static func isValidateAddress(addressStr: String) -> Bool {
        var addr: String = addressStr
        if addressStr.contains(":") {
            let prefixBtcString = "bitcoin:"
            if prefixBtcString != addressStr.prefix(prefixBtcString.count) {
                return false
            }
            addr = String(addressStr.suffix(from: addressStr.index(addressStr.startIndex, offsetBy: prefixBtcString.count)))
        }

        let pattern = "^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$"
        let bitCoinIDTest = NSPredicate(format:"SELF MATCHES %@", pattern)
        return bitCoinIDTest.evaluate(with: addr)
    }
    
    /*
     * Return if it's main net depends on address prefix
     */
    static func isMainNet(address: String) -> Bool {
        // Main net address must be start with '1'
        if address.prefix(1) == "1" {
            return true
        }
        return false
    }
    
    /* Test code. To be removed */
    static func testSignAndVerifyMessage() {
        let plainMessage = "你好"
        let cafe: Data? = plainMessage.data(using: .utf8)
        Logger.shared.debug("plainMessage:\(plainMessage) data:\(cafe?.hexEncodedString()) \(cafe?.count)")
        do {
            let m = BtcUtils.generateMessageToSign(message: plainMessage)
            Logger.shared.debug("m=\(m.hexEncodedString())")
            let pubKeyStr = "02cc02fc66e2f183e0b85578d327721cf94f75f42e689d0df74b23a7c7ee3fb9d5"
            let address = "13GNvHaSjhs8dLbEWrRP7Lvbb8ZBsKUU4P"
            let signedMsg = "630bf7a5541e19f1718649c801e059bd10a807753e579f50244d546039ab4521c9c581c310514158a7e7df76ecbe57dd095a78ec6743e1766a0687b53118f4ff"
            let encodedSignature = try BtcUtils.processSignedMessage(encodedMessageToSign: m.hexEncodedString(), publicKey: pubKeyStr, signedMessage: signedMsg)
            Logger.shared.debug("encoded signature=\(encodedSignature)")

            let sm = SignedMessage(address: address, signature: encodedSignature, message: plainMessage)
            let formattedMessage = sm.getFormattedMessage()
            Logger.shared.debug("formatted message:\(formattedMessage)")

            let sm2 = try SignedMessage(formattedMessage: formattedMessage)
            let messageToSign = BtcUtils.generateMessageToSign(message: sm2.message)
            let result = try BtcUtils.verifySignature(address: sm.address, message: messageToSign.hexEncodedString(), signature: sm2.signature, isMainNet: true)
            Logger.shared.debug("verify result=\(result)")
        } catch OtkError.InvalidSignature {
            Logger.shared.debug("Invalid Signature")
        } catch OtkError.InvalidFormattedSignedMessage {
            Logger.shared.debug("Invalid formatted message")
        } catch {
            Logger.shared.debug("Error:\(error)")
        }
    }
    /*
     * Genearte message for OTK to sign
     */
    static func generateMessageToSign(message: String) -> Data {
        return BTCKey.signatureHash(forMessage: message)
    }
    
    /*
     * Process signaure
     */
    static func processSignedMessage(encodedMessageToSign: String, publicKey: String, signedMessage: String) throws -> String {
        print("processingSignedMessage: \(encodedMessageToSign), \(publicKey), \(signedMessage)")
        let key = BTCDataFromHex(publicKey)
        let hash = BTCDataFromHex(encodedMessageToSign)

        let key1: BTCKey = BTCKey(publicKey: key)

        let der = BtcUtils.toDER(sigHexString: signedMessage) as Data
        let compactSig = key1.convert2CompactSignature(der, hash: hash)
        if let compactSig = compactSig {
            let key2 = BTCKey.verifyCompactSignature(compactSig, forHash: hash)
            if let key2 = key2 {
                if key2 == key1 {
                    return compactSig.base64EncodedString()
                }

            }
        }
        throw OtkError.InvalidSignature
    }
    
    /*
     * Verify signature
     */
    static func verifySignature(address: String, message: String, signature: String, isMainNet: Bool = true) throws -> Bool {
       
        let decodedSignature = Data.init(base64Encoded: signature)
        if decodedSignature == nil {
            throw OtkError.InvalidSignature
        }
        let hash = BTCDataFromHex(message)
        let key = BTCKey.verifyCompactSignature(decodedSignature, forHash: hash)
        if let key = key {
            //Logger.shared.debug("b=\(key1.publicKey == key2.publicKey)")
            var address1: BTCAddress
            var address2: BTCAddress

            if (isMainNet) {
                if BTCPublicKeyAddress(string: address) == nil {
                    return false;
                }
                address1 = BTCPublicKeyAddress(string: address)!
                address2 = key.address
            }
            else {
                // Testnet
                if BTCPublicKeyAddressTestnet(string: address) == nil {
                    return false;
                }
                address1 = BTCPublicKeyAddressTestnet(string: address)!
                address2 = key.addressTestnet
            }
            return address1 == address2
        }
        return false
    }

    
}
