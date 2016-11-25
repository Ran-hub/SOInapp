//
//  ViewController.swift
//  SOInapp
//
//  Created by Hitesh on 11/25/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    @IBOutlet weak var tblInAppList: UITableView!
    
    let arrInAppProduct = NSMutableArray()
    let arrProductIDs = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrProductIDs.addObject("com.xxxxxxxx.xxx")
        arrProductIDs.addObject("com.xxxxxxxx.xxxxx")
        
        getProductInfo()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
      
    }
    
    func getProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: arrProductIDs as [AnyObject])
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    
    // MARK: SKProductsRequestDelegate method implementation
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                arrInAppProduct.addObject(product )
            }
            tblInAppList.reloadData()
        }
        else {
            print("There are no products.")
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    
    // MARK: SKPaymentTransactionObserver method implementation
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed");
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    

    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrInAppProduct.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        let product = arrInAppProduct[forRowAtIndexPath.row]
        
        let lblTitle = cell.contentView.viewWithTag(1) as! UILabel
        lblTitle.text = product.localizedTitle
        
        let lblSubTitle = cell.contentView.viewWithTag(2) as! UILabel
        lblSubTitle.text = product.localizedDescription

    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        //Get SKProduce and add it for payment
        let payment = SKPayment(product: self.arrInAppProduct[indexPath.row] as! SKProduct)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

