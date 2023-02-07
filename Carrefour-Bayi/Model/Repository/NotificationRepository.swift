//
//  NotificationRepository.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 17.11.2022.
//

import Foundation

protocol NotificationRepository {
    func getAllNotification(completion: @escaping(GetAllNotificationResponseDTO) -> Void,
                            failure: @escaping(APIErrorMessageProvider?) -> Void)
    func notificationMarkAsRead(notificationId: Int, completion: @escaping(BaseResponseDTO) -> Void,
                                failure: @escaping(APIErrorMessageProvider?) -> Void)
    func pushNotification(completion: @escaping(BaseResponseDTO) -> Void,
                          failure: @escaping(APIErrorMessageProvider?) -> Void)
    func setFCMToken(FCMToken: String, completion: @escaping(BaseResponseDTO) -> Void,
                     failure: @escaping(APIErrorMessageProvider?) -> Void)
}



class DefaultNotificationRepository: NotificationRepository {
    func getAllNotification(completion: @escaping (GetAllNotificationResponseDTO) -> Void,
                            failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let getAllNotificationRequestDTO = BaseRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType)
        CipherHelper.encryption(requestDTO: getAllNotificationRequestDTO) { encryptedString in
            NotificationService.getAllNotification(request: encryptedString).request(responseDTO: GetAllNotificationResponseDTO.self) { getAllNotificationResponseDTO in
                if let success = getAllNotificationResponseDTO.Success, success {
                    completion(getAllNotificationResponseDTO)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (getAllNotificationResponseDTO).Message)
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    
    func notificationMarkAsRead(notificationId: Int, completion: @escaping (BaseResponseDTO) -> Void,
                                failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let notificationMarkAsReadRequestDTO = NotificationMarkAsReadRequestDTO(Language: ServiceConfiguration.Language,
                                                                                ProcessType: ServiceConfiguration.ProcessType,
                                                                                NotificationId: notificationId)
        CipherHelper.encryption(requestDTO: notificationMarkAsReadRequestDTO) { encryptedString in
            NotificationService.notificationMarkAsRead(request: encryptedString).request(responseDTO: BaseResponseDTO.self) { notificationMarkResponse in
                if let success = notificationMarkResponse.Success, success {
                    completion(notificationMarkResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (notificationMarkResponse).Message)
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }

        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    
    func pushNotification(completion: @escaping (BaseResponseDTO) -> Void,
                          failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let pushNotificationRequestDTO = BaseRequestDTO(Language: ServiceConfiguration.Language,
                                                        ProcessType: ServiceConfiguration.ProcessType)
        CipherHelper.encryption(requestDTO: pushNotificationRequestDTO  ) { encryptedString in
            NotificationService.pushNotification(request: encryptedString).request(responseDTO: BaseResponseDTO.self) { pushNotificationResponse in
                if let success = pushNotificationResponse.Success, success {
                    completion(pushNotificationResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (pushNotificationResponse).Message)
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func setFCMToken(FCMToken: String, completion: @escaping (BaseResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let setFCMRequestDTO = SetFCMTokenRequestDTO(FCMToken: FCMToken, Language: ServiceConfiguration.Language,
                                                     ProcessType: ServiceConfiguration.ProcessType)
        CipherHelper.encryption(requestDTO: setFCMRequestDTO) { encryptedString in
            NotificationService.setFCMToken(request: encryptedString).request(responseDTO: BaseResponseDTO.self) { setFCMResponseDTO in
                if let success = setFCMResponseDTO.Success, success {
                    completion(setFCMResponseDTO)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: setFCMResponseDTO.Message)
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }

        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
}



class MockNotificationRepository: NotificationRepository {
    func getAllNotification(completion: @escaping (GetAllNotificationResponseDTO) -> Void,
                            failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    
    func notificationMarkAsRead(notificationId: Int, completion: @escaping (BaseResponseDTO) -> Void,
                                failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    
    func pushNotification(completion: @escaping (BaseResponseDTO) -> Void,
                          failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    
    func setFCMToken(FCMToken: String, completion: @escaping (BaseResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
}
