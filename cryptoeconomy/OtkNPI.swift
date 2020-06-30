//
//  OtkNPI.swift
//  OTK Command
//
//  Created by Quark on 2020/2/21.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Combine
import CoreNFC

enum OtkExecState {
    case invalid
    case success
    case fail
    
    init(_ val: Int) {
        switch val {
        case 1:
            self = .success
            break
        case 2:
            self = .fail
            break
        default:
            self = .invalid
        }
    }
    
    init(_ str: String) {
        switch str {
        case "1":
            self = .success
            break
        case "2":
            self = .fail
            break
        default:
            self = .invalid
        }
    }
    
    var val: Int {
        switch self {
        case .success:
            return 1
        case .fail:
            return 2
        default:
            return 0
        }
    }
    
    var string: String {
        switch self {
        case .success:
            return "1"
        case .fail:
            return "2"
        default:
            return "0"
        }
    }
}

enum OtkCommand: CaseIterable{
    case invalid
    case unlock
    case showKey
    case sign
    case setKey
    case setPin
    case setNote
    case cancel
    case reset
    case exportKey
    
    init(_ val: Int) {
        switch val {
        case 161:
            self = .unlock
            break
        case 162:
            self = .showKey
            break
        case 163:
            self = .sign
            break
        case 164:
            self = .setKey
            break
        case 165:
            self = .setPin
            break
        case 166:
            self = .setNote
            break
        case 167:
            self = .cancel
            break
        case 168:
            self = .reset
            break
        case 169:
            self = .exportKey
            break
        default:
            self = .invalid
        }

    }
    
    init(_ str: String) {
        switch str {
        case "161":
            self = .unlock
            break
        case "162":
            self = .showKey
            break
        case "163":
            self = .sign
            break
        case "164":
            self = .setKey
            break
        case "165":
            self = .setPin
            break
        case "166":
            self = .setNote
            break
        case "167":
            self = .cancel
            break
        case "168":
            self = .reset
            break
        case "169":
            self = .exportKey
            break
        default:
            self = .invalid
        }

    }

    var code: Int {
        switch self {
        case .unlock:
            return 161
        case .showKey:
            return 162
        case .sign:
            return 163
        case .setKey:
            return 164
        case .setPin:
            return 165
        case .setNote:
            return 166
        case .cancel:
            return 167
        case .reset:
            return 168
        case .exportKey:
            return 169
        default:
            return 0
        }
    }
    
    var string: String {
        switch self {
        case .unlock:
            return "161"
        case .showKey:
            return "162"
        case .sign:
            return "163"
        case .setKey:
            return "164"
        case .setPin:
            return "165"
        case .setNote:
            return "166"
        case .cancel:
            return "167"
        case .reset:
            return "168"
        case .exportKey:
            return "169"
        default:
            return "0"
        }
    }

    var desc: String {
        switch self {
        case .unlock:
            return AppStrings.unlock
        case .showKey:
            return AppStrings.showKey
        case .sign:
            return AppStrings.sign
        case .setKey:
            return AppStrings.choose_key
        case .setPin:
            return AppStrings.setPinCode
        case .setNote:
            return AppStrings.writeNote
        case .cancel:
            return AppStrings.cancel
        case .reset:
            return AppStrings.reset
        case .exportKey:
            return AppStrings.exportKey
        default:
            return "Unknow command"
        }
    }
}

enum OtkFailureReason: CaseIterable{
    case invalid
    case timeout
    case auth_failed
    case cmd_invalid
    case param_invalid
    case param_missing
    case pin_unset

    
    init(_ val: Int) {
        switch val {
        case 192:
            self = .timeout
            break
        case 193:
            self = .auth_failed
            break
        case 194:
            self = .cmd_invalid
            break
        case 195:
            self = .param_invalid
            break
        case 196:
            self = .param_missing
            break
        case 197:
            self = .pin_unset
            break
        default:
            self = .invalid
        }

    }
    
    init(_ str: String) {
        switch str {
        case "192":
            self = .timeout
            break
        case "193":
            self = .auth_failed
            break
        case "194":
            self = .cmd_invalid
            break
        case "195":
            self = .param_invalid
            break
        case "196":
            self = .param_missing
            break
        case "197":
            self = .pin_unset
            break
        default:
            self = .invalid
        }

    }

    var code: Int {
        switch self {
        case .timeout:
            return 192
        case .auth_failed:
            return 193
        case .cmd_invalid:
            return 194
        case .param_invalid:
            return 195
        case .param_missing:
            return 196
        case .pin_unset:
            return 197
        default:
            return 0
        }
    }
    
    var string: String {
        switch self {
        case .timeout:
            return "192"
        case .auth_failed:
            return "193"
        case .cmd_invalid:
            return "194"
        case .param_invalid:
            return "195"
        case .param_missing:
            return "196"
        case .pin_unset:
            return "197"
        default:
            return "0"
        }
    }

    var desc: String {
        switch self {
        case .timeout:
            return AppStrings.request_timeout
        case .auth_failed:
            return AppStrings.authentciation_failed
        case .cmd_invalid:
            return AppStrings.invalid_command
        case .param_invalid:
            return AppStrings.invalide_parameters
        case .param_missing:
            return AppStrings.missing_parameters
        case .pin_unset:
            return AppStrings.pin_is_not_set
        default:
            return AppStrings.unknow_failure_reason
        }
    }
}

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
    var batteryPercentage = ""
    var batteryVoltage = ""
    var note = ""
}

struct OtkState {
    var isLocked = false
    var isAuthenticated = false
    var execState = OtkExecState.invalid
    var command = OtkCommand.invalid
    var failureReason = OtkFailureReason.invalid
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

struct OtkRequest {
    var command: OtkCommand = .invalid
    var pin = ""
    var data = ""
    var option = ""
}

// OtkNfcProtocolInterface
class OtkNfcProtocolInterface: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    var didChange = PassthroughSubject<Void,Never>()

    // MARK: - Observable Properties
    @Published var readStarted = false { didSet { didChange.send() } }
    @Published var readTag = OtkNDEFTag() { didSet { didChange.send() } }
    @Published var otkInfo = OtkInfo() { didSet { didChange.send() } }
    @Published var otkState = OtkState() { didSet { didChange.send() } }
    @Published var otkData = OtkData() { didSet { didChange.send() } }
    @Published var request = OtkRequest() { didSet { didChange.send() } }
    @Published var readCompleted = false { didSet { didChange.send() } }

    // Private variables
    private var session: NFCNDEFReaderSession?
    private var detectedMessages = [NFCNDEFMessage]()
    private var sessionId = ""
    private var dispatchQ: DispatchQueue?
    private var onCompleted: ()->Void = {}
    private var onCanceled: ()->Void = {}

    // MARK: - Actions
    
    func reset() {
        self.readTag = OtkNDEFTag()
        self.otkInfo = OtkInfo()
        self.otkState = OtkState()
        self.otkData = OtkData()
        self.request = OtkRequest()
        self.readStarted = false
        self.readCompleted = false
    }

    /// - Tag: beginScanning
    func beginScanning(onCompleted: @escaping ()->Void, onCanceled: @escaping ()->Void) {
        guard NFCNDEFReaderSession.readingAvailable else {
//            let alertController = UIAlertController(
//                title: "NFC Scanning Not Supported",
//                message: "This device doesn't support tag scanning.",
//                preferredStyle: .alert
//            )
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            print("NFC scanning not supported!")
            return
        }
        
        self.onCompleted = onCompleted
        self.onCanceled = onCanceled
        self.readCompleted = false
        self.readStarted = true

        session = NFCNDEFReaderSession(delegate: self, queue: dispatchQ, invalidateAfterFirstRead: false)
        session?.alertMessage = AppStrings.strApproachOtk
        session?.begin()
        print("Start NFC scanning")
    }
    
    func cancelSession() {
        if session != nil {
            session?.invalidate(errorMessage: "Operation canceled!")
        }
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
            session.alertMessage = AppStrings.strMultipleTags
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        // Connect to the found tag and perform NDEF message reading
        let tag = tags.first!
        session.connect(to: tag, completionHandler: { (error: Error?) in
            if nil != error {
//                session.alertMessage = AppStrings.strUnableToConnect
//                session.invalidate()
                print(AppStrings.strUnableToConnect)
                session.restartPolling()
                return
            }
            
            tag.queryNDEFStatus(completionHandler: { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                guard error == nil else {
//                    session.alertMessage = AppStrings.strUnableToQueryNdef
//                    session.invalidate()
                    print(AppStrings.strUnableToQueryNdef)
                    session.restartPolling()
                    return
                }

                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = AppStrings.strNotNdefCompliant
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = AppStrings.strTagReadOnly
                    session.invalidate()
                case .readWrite:
                    tag.readNDEF(completionHandler: { (message: NFCNDEFMessage?, error: Error?) in
                        if nil != error || nil == message {
//                            session.alertMessage = AppStrings.strUnknownNdefStatus
//                            session.invalidate()
                            print(AppStrings.strUnableToQueryNdef)
                            session.restartPolling()
                            return
                        } else {
                            DispatchQueue.main.async {
                                // Process detected NFCNDEFMessage objects.
                                if ((message?.records.count ?? 0) < 6) {
                                    session.alertMessage = AppStrings.strNotOtk
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
                                        
                                        if self.request.command == .invalid ||
                                            otkState.execState != .invalid {
                                            session.alertMessage = AppStrings.strRequestProcessed
                                            session.invalidate()
                                            self.readCompleted = true
                                        }
                                        else {
                                            print("Session ID: \(self.sessionId)")
                                            let sessId = self.payloadConstruct(str: self.sessionId)
                                            let reqId = self.payloadConstruct(str: self.sessionId)
                                            let reqCmd = self.payloadConstruct(str: self.request.command.string)
                                            let reqData = self.payloadConstruct(str: self.request.data)
                                            var opt = ""
                                            if self.request.pin.count == 8 {
                                                opt = "pin=\(self.request.pin)"
                                                if self.request.option.count > 0 {
                                                    opt = "\(opt),\(self.request.option)"
                                                }
                                            }
                                            let reqOpt = self.payloadConstruct(str: opt)

                                            let requestMessage = NFCNDEFMessage.init(records: [sessId, reqId, reqCmd, reqData, reqOpt])
                                            tag.writeNDEF(requestMessage, completionHandler: { (error: Error?) in
                                                if nil != error {
//                                                    session.alertMessage = AppStrings.strRequestSentFailed + ": \(error!)"
//                                                    session.invalidate()
                                                    print(AppStrings.strRequestSentFailed + ": \(error!)")
                                                    session.restartPolling()
                                                    return
                                                }
                                                else {
                                                    session.alertMessage = AppStrings.strRequestSent
                                                    session.restartPolling()
                                                }
                                            })
                                        }
                                    }
                                    else {
                                        session.alertMessage = AppStrings.strNotOtk
                                        session.invalidate()
                                    }
                                }
                            }
                        }
                    })
                @unknown default:
//                    session.alertMessage = AppStrings.strUnknownNdefStatus
//                    session.invalidate()
                    print(AppStrings.strUnknownNdefStatus)
                    session.restartPolling()
                }
            })
        })
    }
    
    /// - Tag: sessionBecomeActive
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {

    }
    
    /// - Tag: endScanning
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        var canceled = false
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
            
            if (!self.readCompleted && readerError.code == .readerSessionInvalidationErrorUserCanceled) ||  (readerError.code == .readerSessionInvalidationErrorSessionTimeout) {
                print("NFC scan canceled")

                DispatchQueue.main.async {
                    print("Execute canceled callback")
                    self.onCanceled()
                }
                canceled = true
            }
        }

        print("End NFC session")
        self.session = nil
        DispatchQueue.main.async {
            self.readStarted = false
        }

        if !canceled {
            DispatchQueue.main.async {
                print("Execute completed callback")
                self.onCompleted()
            }
        }
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
        let headerMint = "Key Mint"
        let headerMintDate = "Mint Date"
        let headerHwVer = "H/W Version"
        let headerFwVer = "F/W Version"
        let headerSerialNo = "Serial No."
        let headerBattLevel = "Battery Level"
        let headerNote = "Note"
        
        var otkInfo = OtkInfo()
        let lines = strInfo.components(separatedBy: "\r\n")
        
        for line in lines {
            if (line.contains(headerMint)) {
                otkInfo.mint = getValueOfKey(str: line, key: headerMint)
            }
            else if (line.contains(headerMintDate)) {
                otkInfo.mintDate = getValueOfKey(str: line, key: headerMintDate)
            }
            else if (line.contains(headerHwVer)) {
                otkInfo.hwVer = getValueOfKey(str: line, key: headerHwVer)
            }
            else if (line.contains(headerFwVer)) {
                otkInfo.fwVer = getValueOfKey(str: line, key: headerFwVer)
            }
            else if (line.contains(headerSerialNo)) {
                otkInfo.serialNo = getValueOfKey(str: line, key: headerSerialNo)
            }
            else if (line.contains(headerBattLevel)) {
                let secBatt = getValueOfKey(str: line, key: headerBattLevel).components(separatedBy: "/")
                if (secBatt.count > 0) {
                    otkInfo.batteryPercentage = trimSting(secBatt[0])
                }
                if (secBatt.count > 1) {
                    otkInfo.batteryVoltage = trimSting(secBatt[1])
                }
            }
            else if (line.contains(headerNote)) {
                otkInfo.note = lines[lines.count - 1]
            }
        }
        
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
        otkState.execState = OtkExecState(execState)
        otkState.command = OtkCommand(requestCmd)
        otkState.failureReason = OtkFailureReason(failureReason)
        
        return otkState
    }
    
    static func parseOtkData(strData: String) -> OtkData {
        var otkData = OtkData()
        let lines = strData.split(separator: "<")
        
        for line in lines {
            if (line.isEmpty) {
                continue
            }
            else {
                let words = line.components(separatedBy: ">")
                
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
                else if (words[0].contains("Derivative_Extended_Key")) {
                    otkData.derivativeKey = trimSting(words[1])
                }
                else if (words[0].contains("Derivative_Exteded_Key")) {
                    // for backward compatible
                    otkData.derivativeKey = trimSting(words[1])
                }
                else if (words[0].contains("Derivative_Path")) {
                    otkData.derivativePath = trimSting(words[1])
                }
                else if (words[0].contains("Public_Key")) {
                    otkData.publicKey = trimSting(words[1])
                }
                else if (words[0].contains("Request_Signature")) {
                    let signatures = words[1].replacingOccurrences(of: "\r", with: "").components(separatedBy: "\n")
                    for signature in signatures {
                        if !signature.isEmpty {
                            otkData.signatures.append(signature)
                        }
                    }
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
        output = output.replacingOccurrences(of: " ", with: "")
        output = output.replacingOccurrences(of: "\n", with: "")
        output = output.replacingOccurrences(of: "\r", with: "")
        return output
    }
}
