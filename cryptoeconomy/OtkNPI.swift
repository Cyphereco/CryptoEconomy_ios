//
//  OtkNPI.swift
//  OTK Command
//
//  Created by Quark on 2020/2/21.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Combine
import CoreNFC

struct OtkState {
    var isLocked = false
    var isAuthenticated = false
    var executionResult = 0
    var executionCommand = 0
    var failureReason = 0
}
struct OtkNDEFTag {
    var otkInfo = ""
    var otkState = ""
    var otkPubKey = ""
    var otkSessionData = ""
    var otkSessionHash = ""
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
    @Published var requestCommand = OtkRequestCommand() { didSet { didChange.send() } }
    @Published var otkDetected = false { didSet { didChange.send() } }

    // Private variables
    private var session: NFCNDEFReaderSession?
    private var detectedMessages = [NFCNDEFMessage]()
    private var sessionId = ""
    private var dispatchQ: DispatchQueue?
    
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
    func beginScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
//            let alertController = UIAlertController(
//                title: "NFC Scanning Not Supported",
//                message: "This device doesn't support tag scanning.",
//                preferredStyle: .alert
//            )
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            return
        }

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
                                    self.readTag.otkInfo = message!.records[1].wellKnownTypeTextPayload().0 ?? ""
                                    self.readTag.otkState = message!.records[2].wellKnownTypeTextPayload().0 ?? ""
                                    self.readTag.otkPubKey = message!.records[3].wellKnownTypeTextPayload().0 ?? ""
                                    self.readTag.otkSessionData = message!.records[4].wellKnownTypeTextPayload().0 ?? ""
                                    self.readTag.otkSessionHash = message!.records[5].wellKnownTypeTextPayload().0 ?? ""
                                    
                                    if nil != self.readTag.otkSessionData.range(of: "Session_ID") &&
                                        nil != self.readTag.otkInfo.range(of: "Cyphereco") {
                                        let strArray:[String] = self.readTag.otkSessionData.components(separatedBy: "\r\n")
                                        self.sessionId = strArray[1]
                                        let otkState = OtkNfcProtocolInterface.parseOtkState(strState: self.readTag.otkState)
                                        
                                        if self.requestCommand.commandCode == "" ||
                                            self.requestCommand.commandCode == "160" ||
                                            otkState.executionResult > 0 {
                                            session.alertMessage = self.strRequestProcessed
                                            session.invalidate()
                                            self.otkDetected = true
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
}
