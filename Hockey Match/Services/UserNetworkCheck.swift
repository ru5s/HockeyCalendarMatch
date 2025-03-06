//
//  UserNetworkCheck.swift
//  Hockey Match
//
//  Created by DF on 18/06/24.
//

import Foundation
import UIKit
import NetworkExtension
import CoreTelephony
import SystemConfiguration.CaptiveNetwork

struct UserDataBody: Codable {
    var userData: UserDModel
}

struct UserDModel: Codable {
    var vivisWork: Bool?
    var gfdokPS: String?
    var gdpsjPjg: String?
    var poguaKFP: String?
    var gpaMFOfa: String?
    var gciOFm: String?
    var bcpJFs: String?
    var GOmblx: String?
    var G0pxum: String?
    var Fpvbduwm: Bool?
    var Fpbjcv: Int?
    var StwPp: Bool?
    var KDhsd: Bool?
    var bvoikOGjs: [String : String]?
    var gfpbvjsoM: Int?
    var gfdosnb: [String]?
    var bpPjfns: String?
    var biMpaiuf: Bool?
    var oahgoMAOI: Bool?
}

class CountryUserModel {
    enum Network: String {
        
        case wifi = "en0"
        case cellular = "pdp_ip0"
    }
    
    static let shared = CountryUserModel()
    
    func requestInfo() -> UserDataBody {
        let device = UIDevice.current
        let userDefault = UserDefaults()
        let screenRecording = userDefault.bool(forKey: "screenRecordingEnabled")
        
        let vpnStatus = VpnStatus.isVpnActive()
        let deviceName = device.name
        let modelName = device.model
        let uniqueIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let wifiAddress = getAddress(for: .wifi) ?? "Information not available"
        let simCardInfo = getAddress(for: .cellular) ?? "Information not available"
        let iOSVersion = device.systemVersion
        let deviceLanguage = Locale.preferredLanguages.first ?? ""
        let timeZone = getDay(date: Date())
        let isCharging = device.batteryState == .charging || device.batteryState == .full
        let storageCapacity = Int(getAvailableStorageSpace() ?? 0)
        let screenshotEnabled = UIPasteboard.general.image != nil
        let screenRecordingEnabled = screenRecording
        let appAvailability = ["":""] // **
        let batteryLevel = Int(device.batteryLevel * 100)
        let keyboardStatus = getKeyboardLanguages()
        let region = Locale.current.regionCode ?? ""
        let isMetricSystem = Locale.current.usesMetricSystem
        let isFullCharge = device.batteryState == .full
        
        let uData = UserDataBody(userData: UserDModel(vivisWork: vpnStatus, gfdokPS: deviceName, gdpsjPjg: modelName, poguaKFP: uniqueIdentifier, gpaMFOfa: wifiAddress, gciOFm: simCardInfo, bcpJFs: iOSVersion, GOmblx: deviceLanguage, G0pxum: timeZone, Fpvbduwm: isCharging, Fpbjcv: storageCapacity, StwPp: screenshotEnabled, KDhsd: screenRecordingEnabled, bvoikOGjs: appAvailability, gfpbvjsoM: batteryLevel, gfdosnb: keyboardStatus, bpPjfns: region, biMpaiuf: isMetricSystem, oahgoMAOI: isFullCharge))
        
        return uData
    }
    
    private func getKeyboardLanguages() -> [String] {
        let inputModes = UITextInputMode.activeInputModes
        var enabledLanguages: [String] = []
        
        for inputMode in inputModes {
            if let primaryLanguage = inputMode.primaryLanguage {
                enabledLanguages.append(primaryLanguage)
            }
        }
        
        return enabledLanguages
    }
    
    private func getAvailableStorageSpace() -> Int64? {
        let fileManager = FileManager.default
        do {
            if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let storageAttributes = try fileManager.attributesOfFileSystem(forPath: documentDirectory.path)
                if let freeSize = storageAttributes[.systemFreeSize] as? NSNumber {
                    return (freeSize.int64Value / 1_048_576) // send megabites
                }
            }
        } catch {
            print("Error getting storage space: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func getDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"
        let day = dateFormatter.string(from: date)
        return day
    }
    
    func getAddress(for network: Network) -> String? {
        var address: String?
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                let name = String(cString: interface.ifa_name)
                if name == network.rawValue {
                    
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }


}




struct VpnStatus {
    private static let vpnProtocolsKeysIdentifiers = [
        "tap", "tun", "ppp", "ipsec", "utun"
    ]

    static func isVpnActive() -> Bool {
        guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
            let allKeys = keys.allKeys as? [String] else { return false }
        for key in allKeys {
            for protocolId in vpnProtocolsKeysIdentifiers
                where key.starts(with: protocolId) {
                return true
            }
        }
        return false
    }
}
