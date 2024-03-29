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
    static let useFixedAddress = localize("use_fixed_address" )
    static let userGuide = localize("user_guide" )
    static let about = localize("about" )
    static let searchAddress = localize("search_address")
    static let setPinCode = localize("set_pin_code")
    static let showKey = localize("show_full_public_key_information")
    static let writeNote = localize("write_note")
    static let message_sign_validate = localize("message_sign_validate")
    static let choose_key = localize("choose_key")
    static let unlock = localize("unlock")
    static let reset = localize("reset")
    static let exportKey = localize("export_key")
    static let readGeneralInformation = localize("read_general_information")
    static let makeRequest = localize("make_request")
    static let alias = localize("alias")
    static let cancel = localize("cancel")
    static let pay = localize("pay")
    static let recipientAddress = localize("recipient_address")
    static let scanningQrCode = localize("scanning_qr_code")
    static let copied = localize("copied")
    static let btcQrCode = localize("btc_qr_code")
    static let btcAddress = localize("btc_address")
    static let editAddress = localize("edit_address")
    static let openturnkey = localize("OpenTurnKey")
    static let history = localize("history")
    static let addresses = localize("addresses")
    static let wallet_import_format_key = localize("wallet_import_format_key")
    static let i_understood = localize("i_understood")
    static let pin_code_warning_message = localize("pin_code_warning_message")
    static let warning = localize("warning")
    static let request_success = localize("request_success")
    static let request_fail = localize("request_fail")
    static let master_public_key = localize("master_public_key")
    static let derivative_public_key = localize("derivative_public_key")
    static let derivative_key_paths = localize("derivative_key_paths")
    static let full_pubkey_info_warning = localize("full_pubkey_info_warning")
    static let choose_key_warning_message = localize("choose_key_warning_message")
    static let unlock_warning = localize("unlock_warning")
    static let reset_warning_message = localize("reset_warning_message")
    static let export_wif_warning_message = localize("export_wif_warning_message")
    static let reset_step_intro = localize("reset_step_intro")
    static let reset_command_sent = localize("reset_command_sent")
    static let sign = localize("sign")
    static let validate = localize("validate")
    static let cannot_reach_network = localize("cannot_reach_network");
    static let request_timeout = localize("request_timeout");
    static let authentciation_failed = localize("authentciation_failed");
    static let invalid_command = localize("invalid_command");
    static let invalid_parameters = localize("invalid_parameters");
    static let missing_parameters = localize("missing_parameters");
    static let pin_is_not_set = localize("pin_is_not_set");
    static let unknow_failure_reason = localize("unknow_failure_reason");
    static let choose_key_desc = localize("choose_key_desc");
    static let index = localize("index");
    static let index_range = localize("index_range");
    static let level = localize("level");
    static let enter_message = localize("enter_message");
    static let error = localize("error");
    static let cancel_payment = localize("cancel_payment");
    static let balance_not_enough = localize("balance_not_enough");
    static let cannot_get_balance = localize("cannot_get_balance");
    static let checking_balance = localize("checking_balance");
    static let payment_canceled = localize("payment_canceled");
    static let recipient_address_cannot_be_empty = localize("recipient_address_cannot_be_empty");
    static let send_amount_is_not_entered = localize("send_amount_is_not_entered");
    static let amount_is_less_than_transaction_fees = localize("amount_is_less_than_transaction_fees");
    static let processing_transaction = localize("processing_transaction");
    static let cannot_generate_transaction = localize("cannot_generate_transaction");
    static let alias_duplicated = localize("alias_duplicated");
    static let index_out_of_range = localize("index_out_of_range");
    static let invalid_path = localize("invalid_path");
    static let signed_message = localize("signed_message");
    static let enter_note = localize("enter_note");
    static let connot_connect_to_network = localize("connot_connect_to_network");
    static let pin_auth_suspended = localize("pin_auth_suspended");
    static let reboot = localize("reboot");
    static let retry_after = localize("retry_after");

    private static func localize(_ str: String) -> String {
        return NSLocalizedString(str, comment: "")
    }
}
