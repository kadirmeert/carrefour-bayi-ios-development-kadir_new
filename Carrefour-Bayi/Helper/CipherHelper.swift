//
//  CipherWrapper.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 28.07.2022.
//

import Foundation
import CryptoSwift

class CipherHelper {
    private static var hashKey = "DdTQR9hNaFE77XNsh05Px0rc94Vve9KK"
    private static var hashIV = "80prtJez2Mi3TOeZ"
    
    ///It is the function that encrypts the api calls to be made with the aes-256 encryption method.
    static func encryption<T: Codable>(requestDTO: T, completion: @escaping(_ encryptedString: String) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void) {
        do {
            let data = try JSONEncoder().encode(requestDTO)
            
            let jsonString = String(data: data, encoding: .utf8)!
            
            let aes = try AES(key: CipherHelper.hashKey, iv: CipherHelper.hashIV, padding: .pkcs7)
            
            let aesEncryption = try aes.encrypt(Array(jsonString.utf8))
            
            completion(aesEncryption.toBase64())
        } catch {
            var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
            errorDTO = APIErrorResponseDTO(Message: "encryptionFailedMessage".localized)
            
            failure(errorDTO)
        }
    }
    
    ///It is the function that allows decryption of api answers encrypted with Aes-256 bit.
    static func decryption(decryptedString: String, completion: @escaping(Data) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void) {
        do {
            let aes = try AES(key: CipherHelper.hashKey, iv: CipherHelper.hashIV, padding: .pkcs7)
            
            let aesDecryption = try aes.decrypt([UInt8](Data(base64Encoded: decryptedString)!))
            
            let decryptedString = String(bytes: aesDecryption, encoding: .utf8)!
            
            let decryptedData = Data(decryptedString.utf8)
            
            completion(decryptedData)
        } catch {
            var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
            errorDTO = APIErrorResponseDTO(Message: "decryptionFailedMessage".localized)
            
            failure(errorDTO)
        }
    }
    
    static func decryptModel(model: String) -> String {
        do {
            let aes = try AES(key: CipherHelper.hashKey, iv: CipherHelper.hashIV, padding: .pkcs7)
            
            let aesDecryption = try aes.decrypt([UInt8](Data(base64Encoded: model)!))
            
            let decryptedString = String(bytes: aesDecryption, encoding: .utf8)!
            
            return decryptedString
        } catch {
            return "decryptModel failed"
        }
    }
}
