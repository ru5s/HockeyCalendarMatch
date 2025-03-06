//
//  Network.swift
//  Hockey Match
//
//  Created by DF on 18/06/24.
//

import Foundation

class URLSessionRequests {
    static let shared = URLSessionRequests()
    
    private let urlString = ""
    private let firstAttach = "https://appstorage.org/api/conf/h0ck4ym4tch"
    
    weak var task: URLSessionTask?
    
    init() {}
    
    private var timer: Double = 0.0
    
    private func sendDataToServer(answerServerCompletion: @escaping (Bool?, Error?) -> Void, isDead: @escaping () -> Void) {
        let requestData = CountryUserModel.shared.requestInfo()
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(requestData)

            let url = URL(string: urlString )!

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonData
            
            let printJson = String(data: jsonData, encoding: .utf8)?.description ?? ""
            print("json data \(printJson)")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                let responseCode = (response as? HTTPURLResponse)?.statusCode
                guard let unwrData = data,
                      responseCode == 200,
                      error == nil
                else {
                    print("error, can't get data, \(error?.localizedDescription ?? "")")
                    answerServerCompletion(nil, error)
                    return
                }
                do {
                    let decodeData = try JSONDecoder().decode(NetworkModel.self, from: unwrData)
                    answerServerCompletion(decodeData.nonContentEditable, nil)
                } catch {
                    print("error decode data \(error.localizedDescription)")
                    answerServerCompletion(nil, error)
                }
            }
            task.resume()

            self.task = task

            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                isDead()
                task.cancel()
            }
        } catch {
            print("Error to serialization JSON: \(error.localizedDescription)")
            answerServerCompletion(nil, error)
        }
    }
    
    func showEvent(answerCompletion: @escaping (Bool) -> Void) {
        var checkAnswer: Bool?
        sendDataToServer { answer, error in
            DispatchQueue.main.async {
                if error != nil {
                    // there's nothing needed here
                } else {
                    if let answer = answer {
                        checkAnswer = answer
                        answerCompletion(answer) // must ba answer
                    }
                }
            }
        } isDead: {
            if checkAnswer == nil { //IdDead method
//                FirebaseRemoteConfigManager.shared.serverResponseProblem { bool in
//                    answerCompletion(!bool)
//                }
            }
        }
    }
    
    func getData() {
            let url = URL(string: firstAttach)!
        let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                let responseCode = (response as? HTTPURLResponse)?.statusCode
                guard let unwrData = data,
                      responseCode == 200,
                      error == nil
                else {
                    print("error, can't get data, \(error?.localizedDescription ?? "")")
//                    answerServerCompletion(nil, error)
                    return
                }
                do {
                    let decodeData = try JSONDecoder().decode(FirstAttach.self, from: unwrData)
                    dump(decodeData)
//                    answerServerCompletion(decodeData.nonContentEditable, nil)
                } catch {
                    print("error decode data \(error.localizedDescription)")
//                    answerServerCompletion(nil, error)
                }
            }
            task.resume()
    }
    
//    private func annotationsPart(completions: @escaping (FirebaseAnswer.SplashAnswer) -> Void) {
//        private let userDefaults = UserDefaults()
//        
//        let firstOpen = userDefaults.bool(forKey: HockeyValues.Show.onboarding)
//        let secondOpen = userDefaults.bool(forKey: HockeyValues.Show.onboardingPlusNews)
//        let timeAddAnnotations = Date().timeIntervalSince1970
//        let currentDoubleDate = Int(timeAddAnnotations)
//        
//        firebaseConfiguration(name: FirebaseLink.date, type: .string) { date, error in
//            if error != nil {
//                firstOpen ? completions(.tabPage) : completions(.onboarding)
//            } else {
//                let stringDate: String = date as? String ?? ""
//                let intDate: Int = stringDate.convertToIntStringDate()
//                
//                print("current date \(currentDoubleDate), fireabse \(intDate)")
//                
//                if intDate != 0 {
//                    if currentDoubleDate > intDate { // need to be >
//                        URLSessionRequests.shared.showEvent { state in
//                            if state == true {
//                                firstOpen ? completions(.tabPage) : completions(.onboarding)
//                            } else {
//                                secondOpen ? completions(.annotations) : completions(.onboardingWithAnnotations)
//                            }
//                        }
//                    } else {
//                        firstOpen ? completions(.tabPage) : completions(.onboarding)
//                    }
//                } else {
//                    firstOpen ? completions(.tabPage) : completions(.onboarding)
//                }
//            }
//        }
//    }
    
}

struct NetworkModel: Codable {
    let nonContentEditable: Bool
}

struct FirstAttach: Codable {
    let timer: String
    let linkTo: String
    let domainSer_v10: String
    let isDead: String
    let changeAll: String
    
    func boodConvert(data: String) -> Bool {
        if data == "0" {
            return false
        } else {
            return true
        }
    }
}

enum FirebaseAnswer {
    enum SplashAnswer {
        case onboarding
        case onboardingWithAnnotations
        case tabPage
        case annotations
    }
}
