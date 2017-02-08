//
//  Report.swift
//  NotifyMe
//
//  Created by Pierre on 12/28/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation

class Report {
    
    fileprivate let kReporterID = "reporterID"
    fileprivate let kUserID = "userID"
    
    let reporterID: String
    let userID: String
    
    var identifier: String?
    var endpoint: String {
        return "reports"
    }
    var jsonValue: [String: AnyObject] {
        return [kReporterID: reporterID as AnyObject, kUserID: userID as AnyObject]
    }
    
    init(identifier: String? = nil, reporterID: String, userID: String) {
        self.identifier = identifier
        self.reporterID = reporterID
        self.userID = userID
    }
    
    init?(json jsonValue: [String: AnyObject], identifier: String) {
        guard let reporterID = jsonValue[kReporterID] as? String, let userID = jsonValue[kUserID] as? String else { return nil }
        
        self.reporterID = reporterID
        self.userID = userID
        
        self.identifier = identifier
    }
    
}
