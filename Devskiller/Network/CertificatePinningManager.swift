//
//  CertificatePinningManager.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 1/9/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import Foundation
import Security
import CryptoKit

class CertificatePinningManager {
    
    fileprivate static let spacexDomain = "api.spacexdata.com"
    fileprivate static let expectedPublicKeyHash = "LYxvphGUb0VsJBc/HOOF6GlcfnrtsnEz3cSqrurjDt0="
    
    static func createURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        
        let delegate = CertificatePinningDelegate(expectedKeyHash: expectedPublicKeyHash)
        return URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }
}

class CertificatePinningDelegate: NSObject, URLSessionDelegate {
    
    private let expectedKeyHash: String
    
    init(expectedKeyHash: String) {
        self.expectedKeyHash = expectedKeyHash
    }
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard let certChain = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate],
              let serverCert = certChain.first else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let publicKeyHash = getPublicKeySPKIHash(from: serverTrust)
  
        if let hash = publicKeyHash, hash == expectedKeyHash {
            print("✅ Certificate pinning successful!")
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            print("❌ Public key pinning failed!")
            completionHandler(.useCredential, URLCredential(trust: serverTrust))

        }
    }
    
    private func getPublicKeySPKIHash(from trust: SecTrust) -> String? {
        guard let certificate = SecTrustGetCertificateAtIndex(trust, 0),
              let publicKey = SecCertificateCopyKey(certificate),
              let spkiData = publicKey.spkiRepresentation() else {
            return nil
        }
        
        let hash = SHA256.hash(data: spkiData)
        return Data(hash).base64EncodedString()
    }
}

extension SecKey {
    func spkiRepresentation() -> Data? {
        var error: Unmanaged<CFError>?
        guard let keyData = SecKeyCopyExternalRepresentation(self, &error) as Data? else {
            return nil
        }
    
        guard let attributes = SecKeyCopyAttributes(self) as? [CFString: Any],
              let keyType = attributes[kSecAttrKeyType] as? String else {
            return nil
        }
        
        if keyType == (kSecAttrKeyTypeECSECPrimeRandom as String) {
            // ASN.1 header for EC P-256 public key
            let ecHeader: [UInt8] = [
                0x30, 0x59,
                0x30, 0x13,
                0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01,
                0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, 0x07,
                0x03, 0x42, 0x00
            ]
            var data = Data(ecHeader)
            data.append(keyData)
            return data
        }
        
        return nil
    }
}
