//
//  NetguruRequest.swift
//  CertificatePinning
//

import Alamofire

struct NetguruRequest: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        return URLRequest(url: URL(string: "https://www.netguru.com")!)
    }
}
