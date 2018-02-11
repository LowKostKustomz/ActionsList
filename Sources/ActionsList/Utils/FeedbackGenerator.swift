//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit
import AudioToolbox.AudioServices

protocol FeedbackGeneratorProtocol {
    
    /// Allocates generator if needed
    func beginGeneration()
    
    /// Deallocates generator if needed
    func endGeneration()
    
    /// Generates swipe between list items feedback
    func generateSelection()
    
    /// Generates list opening feedback
    func generateOpen()
}

/// Generates feedback.
///
/// To disable feedback set `isEnabled` property to false.
///
/// Available for iPhone 6s, iPhone 6s Plus and later.
@objc public final class FeedbackGenerator: NSObject {
    
    // MARK: - Singleton
    
    private override init() {
        if UIDevice.current.hasOnlyTapticEngine {
            feedbackGenerator = TapticEngine.instance
        } else if #available(iOS 10.0, *),
            UIDevice.current.hasHapticFeedback {
            feedbackGenerator = HapticFeedbackGenerator.instance
        } else {
            feedbackGenerator = nil
        }
    }
    
    @objc public static let instance: FeedbackGenerator = FeedbackGenerator()
    
    // MARK: - Private fields
    
    private let feedbackGenerator: FeedbackGeneratorProtocol?
    
    // MARK: - Public fields
    
    /// If feedback is enabled for the list
    @objc public var isEnabled: Bool = true {
        didSet {
            if oldValue != isEnabled {
                if !isEnabled {
                    endGeneration()
                }
            }
        }
    }
    
    // MARK: - Public methods
    
    /// Allocates generator if needed
    func beginGeneration() {
        guard isEnabled
            else {
                return
        }
        feedbackGenerator?.beginGeneration()
    }
    
    /// Deallocates generator if needed
    func endGeneration() {
        feedbackGenerator?.endGeneration()
    }
    
    /// Generates swipe between list items feedback
    func generateSelection() {
        guard isEnabled
            else {
                return
        }
        feedbackGenerator?.generateSelection()
    }
    
    /// Generates list opening feedback
    func generateOpen() {
        guard isEnabled
            else {
                return
        }
        feedbackGenerator?.generateOpen()
    }
}

/// Generates Taptic feedback.
///
/// Available for iPhone 6s, iPhone 6s Plus and later.
struct TapticEngine: FeedbackGeneratorProtocol {
    
    // MARK: - Singleton
    
    private init() { }

    static let instance: TapticEngine = TapticEngine()
    
    // MARK: - Private fields
    
    private let openSound = SystemSoundID(1520)
    
    // MARK: - FeedbackGeneratorProtocol
    
    func beginGeneration() {
        // There is no need to allocate generator
    }
    
    func endGeneration() {
        // There is no need to deallocate generator
    }
    
    func generateSelection() {
        // Devices with TapticEngine should not generate selection feedback
    }
    
    func generateOpen() {
        AudioServicesPlaySystemSound(openSound)
    }
}

/// Generates Haptic feedback if not disabled in System Settings.
///
/// Available for iPhone 7, iPhone 7 Plus and later.
@available(iOS 10.0, *)
final class HapticFeedbackGenerator: FeedbackGeneratorProtocol {
    
    // MARK: - Singleton
    
    private init() { }
    
    static let instance: HapticFeedbackGenerator = HapticFeedbackGenerator()
    
    // MARK: - Private fields
    
    private var openFeedbackGenerator: UIImpactFeedbackGenerator?
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    
    // MARK: - FeedbackGeneratorProtocol
    
    func beginGeneration() {
        openFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        
        openFeedbackGenerator?.prepare()
        selectionFeedbackGenerator?.prepare()
    }
    
    func endGeneration() {
        openFeedbackGenerator = nil
        selectionFeedbackGenerator = nil
    }
    
    func generateSelection() {
        selectionFeedbackGenerator?.selectionChanged()
        selectionFeedbackGenerator?.prepare()
    }
    
    func generateOpen() {
        openFeedbackGenerator?.impactOccurred()
        openFeedbackGenerator?.prepare()
    }
}
