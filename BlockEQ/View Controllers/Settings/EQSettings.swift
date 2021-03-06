//
//  EQSettings.swift
//  BlockEQ
//
//  Created by Nick DiZazzo on 2018-04-25.
//  Copyright © 2018 Satraj Bambra. All rights reserved.
//

import Foundation

/// The settings that should appear in the settings menu for BlockEQ.
struct EQSettings {
    /// The top level list of options that will appear in the root menu of the settings screen
    let options: [SettingNode]

    /// This initalizer populates options based on the scheme selected. Debug options are only included in debug builds.
    init() {
        #if DEBUG
        options = [walletSection, securitySection, aboutSection, debugSettings]
        #else
        options = [walletSection, securitySection, aboutSection]
        #endif
    }

    let walletSection = SettingNode.section(name: "SETTINGS_SECTION_WALLET".localized(), identifier: "section-wallet", items: [
        SettingNode.node(name: "SETTINGS_OPTION_SEED_PHRASE".localized(), identifier: "wallet-view-seed", enabled: true, type: .normal),
        SettingNode.node(name: "SETTINGS_OPTION_CLEAR_WALLET".localized(), identifier: "wallet-clear", enabled: true, type: .normal)
        ])

    static let pinSection = SettingNode.section(name: "SETTINS_OPTION_ADV_PASSCODE".localized(), identifier: "section-security", items: [
        SettingNode.node(name: "SETTINGS_OPTION_PIN_LAUNCH".localized(), identifier: "security-pin-launch", enabled: true, type: .toggle),
        SettingNode.node(name: "SETTINGS_OPTION_PIN_PAYMENTS".localized(), identifier: "security-pin-payments", enabled: true, type: .toggle),
        SettingNode.node(name: "SETTINGS_OPTION_PIN_TRADING".localized(), identifier: "security-pin-trading", enabled: true, type: .toggle),
        SettingNode.node(name: "SETTINGS_OPTION_PIN_MNEMONIC".localized(), identifier: "security-pin-mnemonic", enabled: false, type: .toggle)
        ])

    let securitySection = SettingNode.section(name: "SETTINGS_SECTION_SECURITY".localized(), identifier: "section-security", items: [
        SettingNode.node(name: "SETTINGS_OPTION_PASSCODE".localized(), identifier: "security-pin-enabled", enabled: true, type: .toggle), pinSection
        ])

    let aboutSection = SettingNode.section(
        name: "SETTINGS_SECTION_COMMUNITY".localized(),
        identifier: "section-about",
        items: [SettingNode.node(name: "SETTINGS_OPTION_REVIEW".localized(), identifier: "community-review", enabled: false, type: .normal),
                SettingNode.node(name: "SETTINGS_OPTION_SHARE".localized(), identifier: "community-share", enabled: false, type: .normal),
                SettingNode.node(name: "SETTINGS_OPTION_PRIVACY".localized(), identifier: "community-privacy", enabled: false, type: .normal),
                SettingNode.node(name: "SETTINGS_OPTION_TERMS".localized(), identifier: "community-terms", enabled: false, type: .normal),
                SettingNode.node(name: "SETTINGS_OPTION_SUPPORT".localized(), identifier: "community-support", enabled: false, type: .normal)
                ])

    let debugSettings = SettingNode.section(
        name: "SETTINGS_SECTION_DEBUG".localized(),
        identifier: "section-debug",
        items: [])
}
