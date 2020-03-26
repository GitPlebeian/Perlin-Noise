//
//  TutorialController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 3/25/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import Foundation

class TutorialController {
    
    // Shared
    static let shared = TutorialController()
    
    enum Tutorial: Int {
        case onboarding = 0
        case parameters = 1
    }
    
    private var finishedTutorials: [Bool] = []
    
    init() {
        loadTutorials()
    }
    
    // MARK: Setters / Getters
    
    // Did Do Tutorial?
    func didDoTutorial(tutorial: Tutorial) -> Bool {
        if tutorial.rawValue >= finishedTutorials.count {
            return true
        }
        return finishedTutorials[tutorial.rawValue]
    }
    
    // Completed Tutorial
    func completedTutorial(tutorial: Tutorial) {
        if tutorial.rawValue >= finishedTutorials.count {
            return
        }
        finishedTutorials[tutorial.rawValue] = true
        saveTutorials()
    }
    
    // MARK: Helpers
    
    // Reset Tutorials
    private func resetTutorials() {
        finishedTutorials = [false, false]
    }
    
    // MARK: Persistence
    
    // Save
    private func saveTutorials() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(finishedTutorials)
            try data.write(to: fileUrl())
        } catch let e {
            print(e)
        }
    }
    
    // Load
    private func loadTutorials() {
        do {
            let data = try Data(contentsOf: fileUrl())
            let jsonDecoder = JSONDecoder()
            let finishedTutorials = try jsonDecoder.decode([Bool].self, from: data)
            self.finishedTutorials = finishedTutorials
        } catch {
            print("Unable to load tutorials, creating new tutorials")
            resetTutorials()
        }
    }
    
    // File URL
    private func fileUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "tutorials.json"
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        return fullURL
    }
}
