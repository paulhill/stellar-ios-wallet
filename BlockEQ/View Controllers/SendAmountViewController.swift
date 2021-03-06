//
//  SendAmountViewController.swift
//  BlockEQ
//
//  Created by Satraj Bambra on 2018-03-10.
//  Copyright © 2018 Satraj Bambra. All rights reserved.
//

import UIKit

class SendAmountViewController: UIViewController {

    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var keyboardHolderView: UIView!
    @IBOutlet var keyboardPad1: UIButton!
    @IBOutlet var keyboardPad2: UIButton!
    @IBOutlet var keyboardPad3: UIButton!
    @IBOutlet var keyboardPad4: UIButton!
    @IBOutlet var keyboardPad5: UIButton!
    @IBOutlet var keyboardPad6: UIButton!
    @IBOutlet var keyboardPad7: UIButton!
    @IBOutlet var keyboardPad8: UIButton!
    @IBOutlet var keyboardPad9: UIButton!
    @IBOutlet var keyboardPadDot: UIButton!
    @IBOutlet var keyboardPad0: UIButton!
    @IBOutlet var keyboardPadBackspace: UIButton!
    @IBOutlet var memoIdLabel: UILabel!
    @IBOutlet var memoIdTextField: UITextField!
    @IBOutlet var sendAddressLabel: UILabel!
    @IBOutlet var toolBar: UIToolbar!
    
    let decimalCountRestriction = 7
    let decimalDotSize = 1
    
    var keyboardPads: [UIButton]!
    var receiver: String = ""
    var sendingAmount: String = ""
    var stellarAccount: StellarAccount = StellarAccount()
    var currentAssetIndex = 0
    
    @IBAction func sendPayment() {
        guard let amount = amountLabel.text, !amount.isEmpty, amount != "0", isValidSendAmount(amount: amount) else {
            return
        }
        
        if PinOptionHelper.check(.pinOnPayment) {
            displayPin()
        } else {
            checkForValidAccount(account: receiver, amount: Decimal(string: amount)!)
        }
    }
    
    @IBAction func keyboardTapped(sender: UIButton) {
        let keyboardPad = keyboardPads[sender.tag]
        if keyboardPad == keyboardPadBackspace {
            if sendingAmount.count > 1 {
                sendingAmount.remove(at: sendingAmount.index(before: sendingAmount.endIndex))
            } else {
                sendingAmount = ""
                
                amountLabel.textColor = Colors.primaryDark
            }
        } else if keyboardPad == keyboardPadDot {
            if sendingAmount.count == 0 {
                sendingAmount += "0."
            } else if sendingAmount.range(of:".") == nil {
                sendingAmount += "."
            }
        } else {
            if sendingAmount.count == 0 && sender.tag == 0 {
                sendingAmount = ""
            } else {
                sendingAmount += String(sender.tag)
            }
        }
        
        if sendingAmount.contains(".") {
            let array = sendingAmount.components(separatedBy: ".")
            if array.count > 1 {
                let decimals = array[1].count
                if decimals > decimalCountRestriction {
                    let substring = sendingAmount.prefix(array[0].count + decimalCountRestriction + decimalDotSize)
                    
                    sendingAmount = String(substring)
                }
            }
        }
        
        if isValidSendAmount(amount: sendingAmount) {
            amountLabel.textColor = Colors.primaryDark
        } else {
            amountLabel.textColor = Colors.red
        }
        
        amountLabel.text = sendingAmount.count > 0 ? sendingAmount : "0"
    }
    
    @IBAction func clearTextfield() {
        view.endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(stellarAccount: StellarAccount, currentAssetIndex: Int, reciever: String) {
        super.init(nibName: String(describing: SendAmountViewController.self), bundle: nil)
        
        self.receiver = reciever
        self.stellarAccount = stellarAccount
        self.currentAssetIndex = currentAssetIndex
        
        navigationItem.title = "\(stellarAccount.assets[currentAssetIndex].formattedBalance) \(stellarAccount.assets[currentAssetIndex].shortCode)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        let image = UIImage(named:"close")
        let rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.dismissView))
        navigationItem.rightBarButtonItem = rightBarButtonItem

        sendAddressLabel.textColor = Colors.darkGray
        amountLabel.textColor = Colors.primaryDark
        currencyLabel.textColor = Colors.darkGrayTransparent
        keyboardHolderView.backgroundColor = Colors.lightBackground
        memoIdLabel.textColor = Colors.darkGray
        memoIdTextField.textColor = Colors.darkGray
        
        currencyLabel.text = stellarAccount.assets[currentAssetIndex].shortCode
        sendAddressLabel.text = "To: \(receiver)"
        
        memoIdTextField.inputAccessoryView = toolBar

        keyboardPads = [keyboardPad0, keyboardPad1, keyboardPad2, keyboardPad3, keyboardPad4, keyboardPad5, keyboardPad6, keyboardPad7, keyboardPad8, keyboardPad9, keyboardPadDot, keyboardPadBackspace]
        
        for (index, keyboardPad) in keyboardPads.enumerated() {
            keyboardPad.tintColor = Colors.primaryDark
            keyboardPad.setTitleColor(Colors.primaryDark, for: .normal)
            keyboardPad.backgroundColor = Colors.lightBackground
            keyboardPad.tag = index
        }
    }
    
    @objc func dismissView() {
        view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    
    func displayPin() {
        /*
        let pinViewController = PinViewController(mode: .dark, pin: KeychainHelper.getPin(), confirming: false, isCloseDisplayed: true, shouldSavePin: false)
        let navigationController = AppNavigationController(rootViewController: pinViewController)
        pinViewController.delegate = self
        
        present(navigationController, animated: true, completion: nil)*/
        
        // TODO remove after testing
        guard let amount = amountLabel.text, !amount.isEmpty, amount != "0" else {
            return
        }
        
        checkForValidAccount(account: receiver, amount: Decimal(string: amount)!)
    }
    
    func displayTransactionError() {
        hideHud()
        
        let alert = UIAlertController(title: "Transaction error", message: "There was an error processing this transaction. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func isValidSendAmount(amount: String) -> Bool {
        if let totalAmountAvailable = Double(stellarAccount.assets[currentAssetIndex].balance), let totalSendable = Double(amount) {
            return totalSendable <= totalAmountAvailable
        }
        
        return true
    }
    
    func showHud() {
        let hud = MBProgressHUD.showAdded(to: (navigationController?.view)!, animated: true)
        hud.label.text = "Sending Payment..."
        hud.mode = .indeterminate
    }
    
    func hideHud() {
        MBProgressHUD.hide(for: (navigationController?.view)!, animated: true)
    }
}

extension SendAmountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
}

extension SendAmountViewController: PinViewControllerDelegate {
    func pinEntryCancelled(_ vc: PinViewController) {
        vc.dismiss(animated: true, completion: nil)
    }

    func pinEntryCompleted(_ vc: PinViewController, pin: String, save: Bool) {
        guard let amount = amountLabel.text, !amount.isEmpty, amount != "0" else {
            return
        }

        checkForValidAccount(account: receiver, amount: Decimal(string: amount)!)
    }
}

/**
 * Sending payment.
 */
extension SendAmountViewController {
    func checkForValidAccount(account accountId: String, amount: Decimal) {
        showHud()
        
        AccountOperation.getAccountDetails(accountId: accountId) { accounts in
            if accounts.count > 0 {
                self.postPaymentTransaction(accountId: accountId, amount: amount)
            } else {
                self.fundNewAccount(account: accountId, amount: amount)
            }
        }
    }
    
    func fundNewAccount(account accountId: String, amount: Decimal) {
        AccountOperation.createNewAccount(accountId: accountId, amount: amount) { completed in
            if completed {
                self.dismissView()
            } else {
                self.displayTransactionError()
            }
        }
    }
    
    func postPaymentTransaction(accountId: String, amount: Decimal) {
        var memoId = ""
        
        if let memoIdString = memoIdTextField.text {
            memoId = memoIdString
        }
        
        let stellarAsset = stellarAccount.assets[currentAssetIndex]
        
        PaymentTransactionOperation.postPayment(accountId: accountId, amount: amount, memoId: memoId, stellarAsset: stellarAsset) { completed in
            if completed {
                self.dismissView()
            } else {
                self.displayTransactionError()
            }
        }
    }
}
