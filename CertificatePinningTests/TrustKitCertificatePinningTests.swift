//
//  TrustKitCertificatePinningTests.swift
//  CertificatePinningTests
//

import XCTest

class TrustKitCertificatePinningTests: XCTestCase {
    
    private let trustKitSession = TrustKitCertificatePinning()
    
    /// This test is checking if website with certificate defined in TrustKit configuration will succed
    /// Expected behaviour: connection should be established since TrustKit configuration contains valid certificate for this website
    /// There is valid certificate for this website defined in TrustKit configuration
    /// Communitation between website should work
    func testIfWebsiteWithPredefinedCertificateWorking() {
        
        let expectation = XCTestExpectation(description: "Network communication with Netguru will succeed.")
        
        getNetguru { success in
            if success {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// This test is checking if website without certificates defined in TrustKit configuration will succed
    /// Expected behaviour: connection should be established since TrustKit only checks defined websites
    /// There is no defined certificate for this website
    /// Communitation between website should work
    func testIfWebsiteWithoutPredefinedCertificateWorking() {
        
        let expectation = XCTestExpectation(description: "Network communication with StackOverflow will succeed.")
        
        getStackOverflow { success in
            if success {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// This test is checking if website with outdated certificate defined in TrustKit configuration will succed
    /// Expected behaviour: connection should fail since TrustKit configuration contains outdated certificate for this website
    /// Defined Certificate in TrustKit configuration is not valid. (Outdate or hacked)
    func testIfWebsiteWithOutdatedCertificateWorking() {
        
        let expectation = XCTestExpectation(description: "Network communication with Google will succeed.")
        
        getGoogle { success in
            if success == false {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    /// This test is checking if website with wrong certificate and certificate expiration date in the past defined in TrustKit configuration will succed
    /// Expected behaviour: connection should succed since TrustKit configuration contains certificate expiration date in the past for this website
    /// Defined Certificate in TrustKit configuration is outdated, but expiration date is past date.
    func testIfWebsiteWithExpiredWrongCertificatesWorking() {

        let expectation = XCTestExpectation(description: "Network communication with Github will succeed.")

        getGithub { success in
            if success {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    private func getNetguru(completionHandler: @escaping (Bool) -> Void) {
        getRequest(url: "https://www.netguru.com", completionHandler: completionHandler)
    }
    
    private func getGoogle(completionHandler: @escaping (Bool) -> Void) {
        getRequest(url: "https://www.google.com", completionHandler: completionHandler)
    }
    
    private func getStackOverflow(completionHandler: @escaping (Bool) -> Void) {
        getRequest(url: "https://stackoverflow.com", completionHandler: completionHandler)
    }

    private func getGithub(completionHandler: @escaping (Bool) -> Void) {
        getRequest(url: "https://github.com", completionHandler: completionHandler)
    }
    
    private func getRequest(url: String, completionHandler: @escaping (Bool) -> Void) {
        trustKitSession.session.dataTask(with: URL(string: url)!) { (data, response, error) in
            completionHandler(error?.localizedDescription != "cancelled")
        }.resume()
    }
}
