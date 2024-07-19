//
//  RnFlybuyCore.swift
//  bildit-platform-rn-flybuy-core
//
//  Created by Addin Gama Bertaqwa on 19/07/24.
//
import Foundation
import FlyBuy

enum FlyBuySupportedEvents: String, CaseIterable {
    case ordersUpdated = "ordersUpdated";
    case ordersError = "ordersError";
    case orderUpdated = "orderUpdated";
    case orderEventError = "orderEventError";
    case notifyEvents = "notifyEvents";
}

@objc(RnFlybuyCore)
class RnFlybuyCore: RCTEventEmitter {
    @objc public static var shared:RnFlybuyCore?

    override init() {
        super.init()
        RnFlybuyCore.shared = self
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc open override func supportedEvents() -> [String] {
        return ["orderUpdated","ordersUpdated","ordersError","orderEventError", "notifyEvents"]
    }
    
    override func startObserving() {
        NotificationCenter.default.addObserver(forName: .orderUpdated, object: nil, queue: nil) { (notification) in
            if let order = notification.object as? Order {
                let event = FlyBuySupportedEvents.orderUpdated.rawValue
                let body = self.parseOrder(order: order)
                Flybuy.shared?.sendEvent(withName: event, body: body)
            }
        }
    }
    
    override func stopObserving() {
        NotificationCenter.default.removeObserver(Flybuy.shared)
    }
    
    // Core functions
    @objc(updatePushToken:)
    func updatePushToken(token: String) {
        FlyBuy.Core.updatePushToken(token)
    }
    
    @objc(handleRemoteNotification:)
    func handleRemoteNotification(userInfo: Dictionary<String, Any>) {
        FlyBuy.Core.handleRemoteNotification(userInfo)
    }
    
    // Customer
    @objc(loginWithToken:withResolver:withRejecter:)
    func loginWithToken(token: String,
                        resolve:@escaping RCTPromiseResolveBlock,
                        reject:@escaping RCTPromiseRejectBlock) {
        FlyBuy.Core.customer.loginWithToken(token: token) { (customer, error) in
            if ((error == nil) && (customer != nil)) {
                resolve(self.parserCustomer(customer: customer!))
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    @objc(login:withPassword:withResolver:withRejecter:)
    func login(email: String,
               password: String,
               resolve:@escaping RCTPromiseResolveBlock,
               reject:@escaping RCTPromiseRejectBlock) {
        FlyBuy.Core.customer.login(emailAddress: email, password: password) { (customer, error) in
            if ((error == nil) && (customer != nil)) {
                resolve(self.parserCustomer(customer: customer!))
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    @objc(signUp:withPassword:withResolver:withRejecter:)
    func signUp(email: String,
                password: String,
                resolve:@escaping RCTPromiseResolveBlock,
                reject:@escaping RCTPromiseRejectBlock) {
        FlyBuy.Core.customer.signUp(emailAddress: email, password: password) { (customer, error) in
            if ((error == nil) && (customer != nil)) {
                resolve(self.parserCustomer(customer: customer!))
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    @objc(logout:withRejecter:)
    func logout(resolve:@escaping RCTPromiseResolveBlock,
                reject:@escaping RCTPromiseRejectBlock) {
        FlyBuy.Core.customer.logout()
        resolve("ok")
    }
    
    @objc(getCurrentCustomer:withRejecter:)
    func getCurrentCustomer(resolve:@escaping RCTPromiseResolveBlock,
                            reject:@escaping RCTPromiseRejectBlock) {
        let customer = FlyBuy.Core.customer.current
        if (customer == nil) {
            reject("not login", "current customer error", nil )
        } else {
            resolve(self.parserCustomer(customer: customer!))
        }
    }
    
    @objc(createCustomer:withResolver:withRejecter:)
    func createCustomer(customer: Dictionary<String, String>,
                        resolve:@escaping RCTPromiseResolveBlock,
                        reject:@escaping RCTPromiseRejectBlock) {
        let customerInfo: CustomerInfo = decodeCustomerInfo(customer: customer)
        FlyBuy.Core.customer.create(customerInfo, termsOfService: true, ageVerification: true) {
            (customer, error) in
            if (error == nil && customer != nil) {
                resolve(self.parserCustomer(customer: customer!))
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    @objc(updateCustomer:withResolver:withRejecter:)
    func updateCustomer(customer: Dictionary<String, String>,
                        resolve:@escaping RCTPromiseResolveBlock,
                        reject:@escaping RCTPromiseRejectBlock) {
        let customerInfo: CustomerInfo = decodeCustomerInfo(customer: customer)
        FlyBuy.Core.customer.update(customerInfo) { (customer, error) in
            if ((error == nil) && (customer != nil)) {
                resolve(self.parserCustomer(customer: customer!))
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    // Orders
        
    @objc(fetchOrders:withRejecter:)
    func fetchOrders(resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) {
        FlyBuy.Core.orders.fetch() { (orders, error) in
            if (error == nil) {
                resolve((orders ?? []).map { self.parseOrder(order: $0) })
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    @objc(createOrder:withPartnerIdentifier:withCustomerInfo:withPickupWindow:withOrderState:withPickupType:withResolver:withRejecter:)
    func createOrder(siteId: Int,
                     pid: String,
                     customerInfo: Dictionary<String, String>,
                     pickupWindow: Dictionary<String, String>? = nil,
                     orderState: String? = nil,
                     pickupType: String? = nil,
                     resolve:@escaping RCTPromiseResolveBlock,
                     reject:@escaping RCTPromiseRejectBlock) {
        let info = decodeCustomerInfo(customer: customerInfo)
        
        func callbackHandler(order: Order?, error: Error?) {
            if (error == nil && order != nil) {
                resolve(self.parseOrder(order: order!))
            } else {
                reject(error.debugDescription, error?.localizedDescription, error )
            }
        }
        
        // TODO: adjust framework call based on params availability
        if (pickupWindow != nil) {
            let pickupWindowInfo = decodePickupWindow(pickupWindow: pickupWindow)
            FlyBuy.Core.orders.create(siteID: siteId, partnerIdentifier: pid, customerInfo: info, pickupWindow: pickupWindowInfo, state: orderState ?? "created", pickupType: pickupType ?? "") {
              (order, error) in callbackHandler(order: order, error: error)
            }
        } else if (pickupWindow == nil) {
            FlyBuy.Core.orders.create(siteID: siteId, partnerIdentifier: pid, customerInfo: info, state: orderState ?? "created", pickupType: pickupType ?? "") {
                    (order, error) in callbackHandler(order: order, error: error)
                }
        }
    }

    @objc(createOrderWithPartnerIdentifier:withOrderPartnerIdentifier:withCustomerInfo:withPickupWindow:withOrderState:withPickupType:withResolver:withRejecter:)
    func createOrderWithPartnerIdentifier(sitePartnerIdentifier: String,
                     orderPid: String,
                     customerInfo: Dictionary<String, String>,
                     pickupWindow: Dictionary<String, String>? = nil,
                     orderState: String? = nil,
                     pickupType: String? = nil,
                     resolve:@escaping RCTPromiseResolveBlock,
                     reject:@escaping RCTPromiseRejectBlock) {
        let info = decodeCustomerInfo(customer: customerInfo)
        
        func callbackHandler(order: Order?, error: Error?) {
            if (error == nil && order != nil) {
                resolve(self.parseOrder(order: order!))
            } else {
                reject(error.debugDescription, error?.localizedDescription, error )
            }
        }
        
        // TODO: adjust framework call based on params availability
        if (pickupWindow != nil) {
            let pickupWindowInfo = decodePickupWindow(pickupWindow: pickupWindow)
            FlyBuy.Core.orders.create(sitePartnerIdentifier: sitePartnerIdentifier, orderPartnerIdentifier: orderPid, customerInfo: info, pickupWindow: pickupWindowInfo, state: orderState ?? "created", pickupType: pickupType ?? "") {
              (order, error) in callbackHandler(order: order, error: error)
            }
        } else if (pickupWindow == nil) {
            FlyBuy.Core.orders.create(sitePartnerIdentifier: sitePartnerIdentifier, orderPartnerIdentifier: orderPid, customerInfo: info, state: orderState ?? "created", pickupType: pickupType ?? "") {
                    (order, error) in callbackHandler(order: order, error: error)
                }
        }
    }
    
    @objc(claimOrder:withCustomer:withPickupType:withResolver:withRejecter:)
    func claimOrder(redeemCode: String,
                    customer: Dictionary<String, String>,
                    pickupType: String,
                    resolve:@escaping RCTPromiseResolveBlock,
                    reject:@escaping RCTPromiseRejectBlock) {
        let customerInfo: CustomerInfo = decodeCustomerInfo(customer: customer)
        FlyBuy.Core.orders.claim(withRedemptionCode: redeemCode, customerInfo: customerInfo, pickupType: pickupType) {
            (order: Order?, error: Error?) in
            if (error == nil) {
                resolve(self.parseOrder(order: order!))
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    @objc(fetchOrderByRedemptionCode:withResolver:withRejecter:)
    func fetchOrderByRedemptionCode(
        redemCode: String,
        resolve:@escaping RCTPromiseResolveBlock,
        reject:@escaping RCTPromiseRejectBlock) {
        FlyBuy.Core.orders.fetch(withRedemptionCode: redemCode) { (order, error) -> (Void) in
            if let error = error {
                reject(error.localizedDescription,  error.localizedDescription, error )
            } else {
                resolve(self.parseOrder(order: order!))
            }
        }
        
    }
    
    @objc(updateOrderState:withState:withResolver:withRejecter:)
    func updateOrderState(orderId: Int,
                          state: String,
                          resolve:@escaping RCTPromiseResolveBlock,
                          reject:@escaping RCTPromiseRejectBlock) {
        FlyBuy.Core.orders.updateOrderState(orderID: orderId, state: state) {
            (order, error) in
            if (error == nil) {
                resolve(self.parseOrder(order: order!))
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    @objc(updateOrderCustomerState:withState:withResolver:withRejecter:)
    func updateOrderCustomerState(orderId: Int,
                                  state: String,
                                  resolve:@escaping RCTPromiseResolveBlock,
                                  reject:@escaping RCTPromiseRejectBlock) {
        FlyBuy.Core.orders.updateCustomerState(orderID: orderId, customerState: state) {
            (order, error) in
            if (error == nil) {
                resolve(self.parseOrder(order: order!))
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }

    @objc(updateOrderCustomerStateWithSpot:withState:withSpot:withResolver:withRejecter:)
    func updateOrderCustomerStateWithSpot(orderId: Int,
                                  state: String,
                                  spot: String,
                                  resolve:@escaping RCTPromiseResolveBlock,
                                  reject:@escaping RCTPromiseRejectBlock) {
        FlyBuy.Core.orders.updateCustomerState(orderID: orderId, customerState: state, spotIdentifier: spot) {
            (order, error) in
            if (error == nil) {
                resolve(self.parseOrder(order: order!))
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    @objc(rateOrder:withRating:withComments:withResolver:withRejecter:)
    func rateOrder(orderId: Int,
                   rating: Int,
                   comments: String,
                   resolve:@escaping RCTPromiseResolveBlock,
                   reject:@escaping RCTPromiseRejectBlock) {
        FlyBuy.Core.orders.rateOrder(orderID: orderId, rating: rating, comments: comments) {
            (order, error) in
            if (error == nil) {
                resolve(self.parseOrder(order: order!))
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    
    // Sites
    
    @objc(fetchAllSites:withRejecter:)
    func fetchAllSites(resolve:@escaping RCTPromiseResolveBlock,
                       reject:@escaping RCTPromiseRejectBlock) {
        FlyBuy.Core.sites.fetchAll() { (sites, error) in
            if (error == nil) {
                resolve((sites ?? []).map { self.parseSite(site: $0) })
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    @objc(fetchSitesByQuery:withResolver:withRejecter:)
    func fetchSitesByQuery(params: Dictionary<String, Any>,
                           resolve:@escaping RCTPromiseResolveBlock,
                           reject:@escaping RCTPromiseRejectBlock) {
        let query: String = params["query"] as! String
        let page: Int = params["page"] as! Int
        
        FlyBuy.Core.sites.fetch(query: query, page: page) { (sites, pagination, error) in
            if (error == nil) {
                resolve([
                    "data": (sites ?? []).map { self.parseSite(site: $0) },
                    "pagination": self.parsePagination(pagination: pagination) ?? [] as Any
                ])
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    
    @objc(fetchSitesByRegion:withResolver:withRejecter:)
    func fetchSitesByRegion(params: Dictionary<String, Any>,
                            resolve:@escaping RCTPromiseResolveBlock,
                            reject:@escaping RCTPromiseRejectBlock) {
        let page: Int = params["page"] as! Int
        let per: Int = params["per"] as! Int
        let region: CLCircularRegion = decodeRegion(region: params["region"] as! Dictionary<String, Double>)
        
        FlyBuy.Core.sites.fetch(region: region,page: page, per:per) { (sites, error) in
            if (error == nil) {
                resolve((sites ?? []).map { self.parseSite(site: $0) })
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }

    @objc(fetchSiteByPartnerIdentifier:withResolver:withRejecter:)
    func fetchSiteByPartnerIdentifier(params: Dictionary<String, Any>,
                            resolve:@escaping RCTPromiseResolveBlock,
                            reject:@escaping RCTPromiseRejectBlock) {
        let pid: String = params["partnerIdentifier"] as! String

        FlyBuy.Core.sites.fetchByPartnerIdentifier(partnerIdentifier: pid) { (site, error) -> (Void) in
            if (error == nil) {
                resolve(self.parseSite(site: site))
            } else {
                reject(error?.localizedDescription,  error.debugDescription, error )
            }
        }
    }
    

}
