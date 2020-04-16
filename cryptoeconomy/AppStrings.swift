//
//  AppStrings.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/4.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

struct AppStrings {
    static let useAllFunds = localize("use_all_funds")
    static let authByPin = localize("authorization_with_pin_code")
    static let transactionInfo = localize("transaction_information")
    static let date = localize("date")
    static let time = localize("time")
    static let result = localize("result")
    static let confirmations = localize("confirmations")
    static let sender = localize("sender")
    static let sendAmount = localize("send_amount")
    static let recipient = localize("recipient")
    static let recvAmount = localize("received_amount")
    static let fees = localize("fees")
    static let showLocalCurrency = localize("show_local_currency")
    static let transactionId = localize("transaction_id")
    static let openturnkeyInfo = localize("openturnkey_information")
    static let note = localize("note")
    static let mintInfo = localize("mint_information")
    static let custom = localize("custom")
    static let low = localize("low")
    static let mid = localize("mid")
    static let high = localize("high")
    static let minutes = localize("minutes")
    static let setTransactionFees = localize("set_transaction_fees")
    static let strApproachOtk = localize("Approach OpenTurnKey to the NFC reader.")
    static let strMultipleTags = localize("Multiple tags are detected, please remove all tags and try again.")
    static let strUnableToConnect = localize("Unable to connect to tag.")
    static let strUnableToQueryNdef = localize("Unable to query the NDEF status of tag.")
    static let strNotNdefCompliant = localize("Tag is not NDEF compliant.")
    static let strTagReadOnly = localize("Tag is read only. This is not an OpenTurnKey")
    static let strRequestProcessed = localize("Request processed.")
    static let strSendingRequest = localize("Sending request")
    static let strRequestSentFailed = localize("Sending request failed")
    static let strRequestSent = localize("Request has been sent.")
    static let strNotOtk = localize("Not OpenTurnKey!")
    static let strUnknownNdefStatus = localize("Unknown NDEF tag status.")
    static let estimatd_fees = localize("estimated_fees")
    static let included = localize("included")
    static let excluded = localize("excluded")
    static let setCurrency = localize("set_local_currency" )
    static let setFees = localize("set_transaction_fees" )
    static let feesIncluded = localize("fees_included" )
    static let useFixAddress = localize("use_fix_address" )
    static let userGuide = localize("user_guide" )
    static let about = localize("about" )
    static let searchAddress = localize("search_address")
    static let setPinCode = localize("set_pin_code")
    static let showKey = localize("show_full_public_key_information")
    static let writeNote = localize("write_note")
    static let msgSignVerify = localize("message_sign_validate")
    static let chooseKey = localize("choose_key")
    static let unlock = localize("unlock")
    static let reset = localize("reset")
    static let exportKey = localize("export_key")
    static let readGeneralInformation = localize("read_general_information")
    static let makeRequest = localize("make_request")
    static let alias = localize("alias")
    static let recipientAddress = localize("recipient_address")
    static let scanningQrCode = localize("scanning_qr_code")

    private static func localize(_ str: String) -> String {
        return NSLocalizedString(str, comment: "")
    }
}
