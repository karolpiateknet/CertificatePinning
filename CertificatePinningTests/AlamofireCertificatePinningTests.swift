//
//  AlamofireCertificatePinningTests.swift
//  CertificatePinningTests
//

import Alamofire
import XCTest
@testable import CertificatePinning

final class AlamofireCertificatePinningTests: XCTestCase {
    
    /// This method test if netguru connection will succed
    /// Expected behaviour: connection should be established since AlamofireNetworking has valid netguru certificate pinning
    ///
    /// If you turn on charles proxy this test should fail, since chanles will change certificate
    /// Charles will perform man-in-the-middle attack
    func testNetguruHostIfAllHostNotEvaluated() {
        
        let networking = AlamofireNetworking(allHostsMustBeEvaluated: false)
        
        let expectation = XCTestExpectation(description: "Network communication with Netguru will succeed.")
        
        networking
            .request(NetguruRequest())
            .response { response in
                switch response.result {
                case .success:
                    expectation.fulfill()
                case .failure:
                  break
                }
            }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// The same as above
    func testNetguruHostIfAllHostEvaluated() {
        
        let networking = AlamofireNetworking(allHostsMustBeEvaluated: true)
        
        let expectation = XCTestExpectation(description: "Network communication with Netguru will succeed.")
        
        networking
            .request(NetguruRequest())
            .response { response in
                switch response.result {
                case .success:
                    expectation.fulfill()
                case .failure:
                  break
                }
            }
        
        wait(for: [expectation], timeout: 1.0)
    }

    /// This method test if Google.com connection will succed
    /// Expected behaviour: connection should be established since allHostsMustBeEvaluated: Bool is set to false
    /// If allHostsMustBeEvaluated is false Alamofire will check certificates only for hosts defined in evaluators dictionary.
    /// Communication with other hosts than defined will not use Certificate pinning
    func testOtherHostIfNotEvaluated() {
        
        let networking = AlamofireNetworking(allHostsMustBeEvaluated: false)
        
        let expectation = XCTestExpectation(description: "Network communication with Google will succeed.")
        
        networking
            .request(GoogleRequest())
            .response { response in
                switch response.result {
                case .success:
                    expectation.fulfill()
                case .failure:
                  break
                }
            }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// This method test if Google.com connection will fail
    /// Expected behaviour: response should return failure with ServerTrustEvaluationError since allHostsMustBeEvaluated: Bool is set to true
    /// If allHostsMustBeEvaluated is true Alamofire will only allow communication with hosts defined in evaluators and matching defined Certificates.
    func testOtherHostIfEvaluated() {
        
        let networking = AlamofireNetworking(allHostsMustBeEvaluated: true)
        
        let expectation = XCTestExpectation(description: "Network communication with Google won't succeed.")
        
        networking
            .request(GoogleRequest())
            .response { response in
                switch response.result {
                case .success:
                    break
                case .failure(let error):
                    if error.asAFError?.isServerTrustEvaluationError == true {
                        expectation.fulfill()
                    }
                }
            }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

struct GoogleRequest: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        return URLRequest(url: URL(string: "https://www.google.com")!)
    }
}
