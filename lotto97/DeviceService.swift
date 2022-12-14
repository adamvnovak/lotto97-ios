//
//  DeviceService.swift
//  lotto97
//
//  Created by Adam Novak on 2022/12/09.
//

import Foundation

class DeviceService: NSObject, ObservableObject {
    
    static var shared = DeviceService()
    private let LOCAL_FILE_APPENDING_PATH = "device.json"
    private var localFileLocation: URL!
    @Published private var device: Device!
    
    //MARK: - Initializer
    
    //private initializer because there will only ever be one instance of UserService, the singleton
    private override init() {
        super.init()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        localFileLocation = documentsDirectory.appendingPathComponent(LOCAL_FILE_APPENDING_PATH)
        if FileManager.default.fileExists(atPath: localFileLocation.path) {
            loadFromFilesystem()
        } else {
            device = Device()
            Task { await saveToFilesystem() }
        }
    }
    
    //MARK: - Getters
    
    func hasRatedApp() -> Bool { return device.hasRatedApp }
    func numberOfTries() -> Int { return device.numberOfTries }

    //MARK: - Setters
    
    func didRateApp() {
        device.hasRatedApp = true
        Task { await saveToFilesystem() }
    }
    
    func didTry() {
        device.numberOfTries += 1
        Task { await saveToFilesystem() }
    }
    
    //MARK: - Filesystem
    
    func saveToFilesystem() async {
        do {
            let encoder = JSONEncoder()
            let data: Data = try encoder.encode(device)
            let jsonString = String(data: data, encoding: .utf8)!
            try jsonString.write(to: self.localFileLocation, atomically: true, encoding: .utf8)
        } catch {
            print("COULD NOT SAVE: \(error)")
        }
    }

    func loadFromFilesystem() {
        do {
            let data = try Data(contentsOf: self.localFileLocation)
            device = try JSONDecoder().decode(Device.self, from: data)
        } catch {
            print("COULD NOT LOAD: \(error)")
        }
    }
    
    func eraseData() {
        do {
            try FileManager.default.removeItem(at: self.localFileLocation)
        } catch {
            print("\(error)")
        }
    }
}

