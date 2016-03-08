//
//  SearchModel.swift
//  GifJams
//
//  Created by Christian Gonzalez on 1/28/16.
//  Copyright © 2016 Christian Gonzalez. All rights reserved.
//

import Foundation
class SearchModel {

    
    func introGifs(title: String,  completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        if let urlToReq = NSURL(string: "http://192.168.1.44:8000/intro") {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            print(title, "IS OFF to THE NODE")
            let bodyData = "title=\(title)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler).resume()
        }
    }
    
    func findSongLyrics(title: String,  completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        if let urlToReq = NSURL(string: "http://192.168.1.44:8000/lyrics") {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            print(title, "IS OFF THE THE NODE")
            let bodyData = "title=\(title)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler).resume()
        }
    }
    
    
    
    
    func afterRequest(data: NSData?, response: NSURLResponse?, error: NSError?) {
        print("WE DID IT")
    }
    
    func parseJSON(inputData: NSData) -> NSMutableArray? {
        do {
            let arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)
            return arrOfObjects as? NSMutableArray
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
}