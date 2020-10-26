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
                kTSKExpirationDate: "2021-06-30",
                kTSKPublicKeyHashes: [
                    "LlPZqzl9X3E7b4nQc6jexz0QNHr8zJop04/g7P0mT+8=",
                    "+7YVLnrnzqo0VtEREXo0ZbJlgdmQ9T9qy2INVVWNpcE==",
                ],
            ],
            "www.google.com": [
                kTSKEnforcePinning: true,
                kTSKIncludeSubdomains: true,
                kTSKExpirationDate: "2021-06-30",
                kTSKPublicKeyHashes: [
                    "umr54R2xp68Q4r0ehzkeE4aoBXoTul4p/X3BNFUS024=",
                    "+7YVLnrnzqo0VtEREXo0ZbJlgdmQ9T9qy2INVVWNpcE==",
                ],
            ],
            "github.com": [
                kTSKEnforcePinning: true,
                kTSKIncludeSubdomains: true,
                kTSKExpirationDate: "1995-01-01",
                kTSKPublicKeyHashes: [
                    // Wrong Certificates for past expiration date tests.
                    "LlPZqzl9X3E7b4nQc6jexz0QNHr8zJop04/g7P0mT+8=",
                    "+7YVLnrnzqo0VtEREXo0ZbJlgdmQ9T9qy2INVVWNpcE==",
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
