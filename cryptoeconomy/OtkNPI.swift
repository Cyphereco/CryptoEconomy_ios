//
//  OtkNPI.swift
//  OTK Command
//
//  Created by Quark on 2020/2/21.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Combine
import CoreNFC

struct OtkNDEFTag {
    var info = ""
    var state = ""
    var publicKey = ""
    var data = ""
    var hash = ""
}

struct OtkInfo {
    var mint = ""
    var mintDate = ""
    var hwVer = ""
    var fwVer = ""
    var serialNo = ""
    var batteryPercentage = 0
    var batteryVoltage = 0
    var note = ""
}

struct OtkState {
    var isLocked = false
    var isAuthenticated = false
    var executionResult = 0
    var executionCommand = 0
    var failureReason = 0
}

struct OtkData {
    var sessionId = ""
    var requestId = ""
    var btcAddress = ""
    var masterKey = ""
    var derivativeKey = ""
    var derivativePath = ""
    var wifKey = ""
    var publicKey = ""
    var signatures: Array<String> = []
}

struct OtkRequestCommand {
    var commandCode = ""
    var pin = ""
    var data = ""
    var option = ""
}

// OtkNfcProtocolInterface
class OtkNfcProtocolInterface: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    var didChange = PassthroughSubject<Void,Never>()

    // MARK: - Observable Properties
    @Published var readTag = OtkNDEFTag() { didSet { didChange.send() } }
    @Published var otkInfo = OtkInfo() { didSet { didChange.send() } }
    @Published var otkState = OtkState() { didSet { didChange.send() } }
    @Published var otkData = OtkData() { didSet { didChange.send() } }
    @Published var requestCommand = OtkRequestCommand() { didSet { didChange.send() } }
    @Published var otkDetected = false { didSet { didChange.send() } }

    // Private variables
    private var session: NFCNDEFReaderSession?
    private var detectedMessages = [NFCNDEFMessage]()
    private var sessionId = ""
    private var dispatchQ: DispatchQueue?
    private var waitForResult = false
    private var completion: ()->Void = {}

    let strApproachOtk = NSLocalizedString("Approach OpenTurnKey to the NFC reader.", comment: "")
    let strMultipleTags = NSLocalizedString("Multiple tags are detected, please remove all tags and try again.", comment: "")
    let strUnableToConnect = NSLocalizedString("Unable to connect to tag.", comment: "")
    let strUnableToQueryNdef = NSLocalizedString("Unable to query the NDEF status of tag.", comment: "")
    let strNotNdefCompliant = NSLocalizedString("Tag is not NDEF compliant.", comment: "")
    let strTagReadOnly = NSLocalizedString("Tag is read only. This is not an OpenTurnKey", comment: "")
    let strRequestProcessed = NSLocalizedString("Request processed.", comment: "")
    let strSendingRequest = NSLocalizedString("Sending request", comment: "")
    let strRequestSentFailed = NSLocalizedString("Sending request failed", comment: "")
    let strRequestSent = NSLocalizedString("Request has been sent.", comment: "")
    let strNotOtk = NSLocalizedString("Not OpenTurnKey!", comment: "")
    let strUnknownNdefStatus = NSLocalizedString("Unknown NDEF tag status.", comment: "")
    
    // MARK: - Actions

    /// - Tag: beginScanning
    func beginScanning(completion: @escaping ()->Void) {
        guard NFCNDEFReaderSession.readingAvailable else {
//            let alertController = UIAlertController(
//                title: "NFC Scanning Not Supported",
//                message: "This device doesn't support tag scanning.",
//                preferredStyle: .alert
//            )
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            return
        }
        
        self.completion = completion

        session = NFCNDEFReaderSession(delegate: self, queue: dispatchQ, invalidateAfterFirstRead: false)
        session?.alertMessage = self.strApproachOtk
        session?.begin()
    }

    // MARK: - NFCNDEFReaderSessionDelegate

    /// - Tag: processingTagData
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("ProcessingTagData")
        DispatchQueue.main.async {
            // Process detected NFCNDEFMessage objects.
            self.detectedMessages.append(contentsOf: messages)
        }
    }

    /// - Tag: processingNDEFTag
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            // Restart polling in 500ms
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = self.strMultipleTags
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        // Connect to the found tag and perform NDEF message reading
        let tag = tags.first!
        session.connect(to: tag, completionHandler: { (error: Error?) in
            if nil != error {
                session.alertMessage = self.strUnableToConnect
                session.invalidate()
                return
            }
            
            tag.queryNDEFStatus(completionHandler: { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                guard error == nil else {
                    session.alertMessage = self.strUnableToQueryNdef
                    session.invalidate()
                    return
                }

                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = self.strNotNdefCompliant
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = self.strTagReadOnly
                    session.invalidate()
                case .readWrite:
                    tag.readNDEF(completionHandler: { (message: NFCNDEFMessage?, error: Error?) in
                        if nil != error || nil == message {
                            session.alertMessage = self.strUnknownNdefStatus
                            session.invalidate()
                            return
                        } else {
                            DispatchQueue.main.async {
                                // Process detected NFCNDEFMessage objects.
                                if ((message?.records.count ?? 0) < 6) {
                                    session.alertMessage = self.strNotOtk
                                    session.invalidate()
                                    return
                                }
                                else {
                                    // Parse Tag Records
                                    self.readTag.info = message!.records[1].wellKnownTypeTextPayload().0 ?? ""
                                    self.readTag.state = message!.records[2].wellKnownTypeTextPayload().0 ?? ""
                                    self.readTag.publicKey = message!.records[3].wellKnownTypeTextPayload().0 ?? ""
                                    self.readTag.data = message!.records[4].wellKnownTypeTextPayload().0 ?? ""
                                    self.readTag.hash = message!.records[5].wellKnownTypeTextPayload().0 ?? ""
                                    print("readTag: \(self.readTag)")
                                    
                                    self.otkInfo = OtkNfcProtocolInterface.parseOtkInfo(strInfo: self.readTag.info)
                                    self.otkState = OtkNfcProtocolInterface.parseOtkState(strState: self.readTag.state)
                                    self.otkData = OtkNfcProtocolInterface.parseOtkData(strData: self.readTag.data)
                                    print("otkInfo: \(self.otkInfo)")
                                    print("otkState: \(self.otkState)")
                                    print("otkData: \(self.otkData)")

                                    if nil != self.readTag.data.range(of: "Session_ID") &&
                                        nil != self.readTag.info.range(of: "Cyphereco") {
                                        let strArray:[String] = self.readTag.data.components(separatedBy: "\r\n")
                                        self.sessionId = strArray[1]
                                        let otkState = OtkNfcProtocolInterface.parseOtkState(strState: self.readTag.state)
                                        
                                        if self.requestCommand.commandCode == "" ||
                                            self.requestCommand.commandCode == "160" ||
                                            otkState.executionResult > 0 {
                                            session.alertMessage = self.strRequestProcessed
                                            session.invalidate()
                                            self.otkDetected = true
                                            self.waitForResult = false
                                        }
                                        else {
                                            session.alertMessage = self.strSendingRequest + " (\(self.requestCommand.commandCode))..."
                                            print("Session ID: \(self.sessionId)")
                                            let sessId = self.payloadConstruct(str: self.sessionId)
                                            let reqId = self.payloadConstruct(str: self.sessionId)
                                            let reqCmd = self.payloadConstruct(str: self.requestCommand.commandCode)
                                            let reqData = self.payloadConstruct(str: self.requestCommand.data)
                                            var opt = ""
                                            if self.requestCommand.pin != "" {
                                                opt = "pin=\(self.requestCommand.pin)"
                                                if self.requestCommand.option != "" {
                                                    opt = "\(opt),\(self.requestCommand.option)"
                                                }
                                            }
                                            let reqOpt = self.payloadConstruct(str: opt)

                                            let requestMessage = NFCNDEFMessage.init(records: [sessId, reqId, reqCmd, reqData, reqOpt])
                                            tag.writeNDEF(requestMessage, completionHandler: { (error: Error?) in
                                                if nil != error {
                                                    session.alertMessage = self.strRequestSentFailed + ": \(error!)"
                                                    session.invalidate()
                                                    return
                                                }
                                                else {
                                                    session.alertMessage = self.strRequestSent
                                                    session.invalidate()
                                                    self.waitForResult = true
                                                }
                                            })
                                        }
                                    }
                                    else {
                                        session.alertMessage = self.strNotOtk
                                        session.invalidate()
                                    }
                                }
                            }
                        }
                    })
                @unknown default:
                    session.alertMessage = self.strUnknownNdefStatus
                    session.invalidate()
                }
            })
        })
    }
    
    /// - Tag: sessionBecomeActive
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {

    }
    
    /// - Tag: endScanning
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("endScanning")
        // Check the invalidation reason from the returned error.
        if let readerError = error as? NFCReaderError {
            // Show an alert when the invalidation reason is not because of a
            // successful read during a single-tag read session, or because the
            // user canceled a multiple-tag read session from the UI or
            // programmatically using the invalidate method call.
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
//                let alertController = UIAlertController(
//                    title: "Session Invalidated",
//                    message: error.localizedDescription,
//                    preferredStyle: .alert
//                )
//                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
        }

        // To read new tags, a new session instance is required.
        self.session = nil
        if (self.waitForResult) {
            self.beginScanning(completion: self.completion)
        }
        self.completion()
    }
    
    private func payloadConstruct(str: String) -> NFCNDEFPayload {
        var encodedText = Data([0x02, 0x65, 0x6E])
        encodedText.append(str.data(using: .utf8)!)

        let payload = NFCNDEFPayload.init(
        format: .nfcWellKnown,
        type: "T".data(using: .utf8)!,
        identifier: Data(),
        payload: encodedText)
        
        return payload
    }

    static func getValueOfKey(str: String, key: String) -> String {
        // str format should be, "key": "value", or, "key">"value"
        var strCopy = str
        strCopy = strCopy.replacingOccurrences(of: ": ", with: ":")
        strCopy = strCopy.replacingOccurrences(of: "\n", with: "")
        
        if (strCopy.contains(":")) {
            let keyValue = strCopy.components(separatedBy: ":")
            if (keyValue.count == 2 && keyValue[0] == key) {
                return trimSting(keyValue[1])
            }
        }
        
        if (strCopy.contains(">")) {
            let keyValue = strCopy.components(separatedBy: ">")
            if (keyValue.count == 2 && keyValue[0] == key) {
                return trimSting(keyValue[1])
            }
        }

        return ""
    }

    static func parseOtkInfo(strInfo: String) -> OtkInfo {
        var otkInfo = OtkInfo()
        let lines = strInfo.components(separatedBy: "\n")
        print("otkInfo: \(lines.count)")
        if (lines.count < 7) {
            return otkInfo
        }
        
        otkInfo.mint = getValueOfKey(str: lines[0], key: "Key Mint")
        otkInfo.mintDate = getValueOfKey(str: lines[1], key: "Mint Date")
        otkInfo.hwVer = getValueOfKey(str: lines[2], key: "H/W Version")
        otkInfo.fwVer = getValueOfKey(str: lines[3], key: "F/W Version")
        otkInfo.serialNo = getValueOfKey(str: lines[4], key: "Serial No.")
        otkInfo.note = getValueOfKey(str: lines[6], key: "Note")

        return otkInfo
    }
    
    static func parseOtkState(strState: String) -> OtkState {
        var otkState = OtkState()
        
        let lockState = Int(strState.prefix(2), radix: 16) ?? 0
        let execState = Int(strState.suffix(6).prefix(2), radix: 16) ?? 0
        let requestCmd = Int(strState.suffix(4).prefix(2), radix: 16) ?? 0
        let failureReason = Int(strState.suffix(2), radix: 16) ?? 0
        
        otkState.isLocked = lockState > 0
        otkState.isAuthenticated = lockState > 1
        otkState.executionResult = execState
        otkState.executionCommand = requestCmd
        otkState.failureReason = failureReason
        
        return otkState
    }
    
    static func parseOtkData(strData: String) -> OtkData {
        var otkData = OtkData()
        let lines = strData.split(separator: "<")
        
        for line in lines {
            if (line.count < 1) {
                continue
            }
            else {
                var words = line.components(separatedBy: ">")
                
                if (words[0].contains("Session_ID")) {
                    otkData.sessionId = trimSting(words[1])
                }
                else if (words[0].contains("BTC_Addr")) {
                    otkData.btcAddress = trimSting(words[1])
                }
                else if (words[0].contains("Request_ID")) {
                    otkData.requestId = trimSting(words[1])
                }
                else if (words[0].contains("Master_Extended_Key")) {
                    otkData.masterKey = trimSting(words[1])
                }
                else if (words[0].contains("Derivative_Exttended_Key")) {
                    otkData.derivativeKey = trimSting(words[1])
                }
                else if (words[0].contains("Derivative_Path")) {
                    otkData.derivativePath = trimSting(words[1])
                }
                else if (words[0].contains("Public_key")) {
                    otkData.publicKey = trimSting(words[1])
                }
                else if (words[0].contains("Request_Signature")) {
                    let signatures = words[1].components(separatedBy: "\n")
                    otkData.signatures = signatures
                }
                else if (words[0].contains("WIF_Key")) {
                    otkData.wifKey = trimSting(words[1])
                }
            }
        }
        
        return otkData
    }
    
    static func trimSting(_ str: String) -> String {
        var output = str
        output = output.replacingOccurrences(of: "\n", with: "")
        output = output.replacingOccurrences(of: "\r", with: "")
        return output
    }
}
