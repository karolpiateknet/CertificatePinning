//
//  TrustKitCertificatePinning.swift
//  CertificatePinning
//

import TrustKit

final class TrustKitCertificatePinning: NSObject, URLSessionDelegate {
    
    /// URLSession with configured certificate pinning
    lazy var session: URLSession = {
        URLSession(configuration: URLSessionConfiguration.ephemeral,
                   delegate: self,
                   delegateQueue: OperationQueue.main)
    }()
    
    private let trustKitConfig = [
        kTSKPinnedDomains: [
            "www.netguru.com": [
                kTSKEnforcePinning: true,
                kTSKIncludeSubdomains: true,
                kTSKExpirationDate: "2020-10-09",
                kTSKPublicKeyHashes: [
                    "GesyhCSAz+OCxCt623nic/qqLXAPGUGGf5vwB5jBheU=",
                    "+7YVLnrnzqo0VtEREXo0SbJlgdmQ9T9qy2INVVWNpcE=",
                ],
            ],
            "www.google.com": [
                kTSKEnforcePinning: true,
                kTSKIncludeSubdomains: true,
                kTSKExpirationDate: "2020-10-09",
                kTSKPublicKeyHashes: [
                    "+7YVLnrnzqo0VtEREXo0ZbJlgdmQ9T9qy2INVVWNpcE==",
                    "+8YVLnrnzqo0VtEREXo0SbJlgdmQ9T9qy2INVVWNpcE=",
                ],
            ]
        ]
    ] as [String : Any]
    
    override init() {
        TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
        super.init()
    }
    
    // MARK: TrustKit Pinning Reference
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
                                                
        if TrustKit.sharedInstance().pinningValidator.handle(challenge, completionHandler: completionHandler) == false {
            // TrustKit did not handle this challenge: perhaps it was not for server trust
            // or the domain was not pinned. Fall back to the default behavior
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
