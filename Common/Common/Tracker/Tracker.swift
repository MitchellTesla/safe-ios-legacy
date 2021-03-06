//
//  Copyright © 2019 Gnosis Ltd. All rights reserved.
//

import Foundation

/**
 This class is a singleton used throughout the app to track events.

 To track an event, create an enum that conforms to Trackable or ScreenTrackingEvent protocol. For example:

     enum MyScreenEvent: String, ScreenTrackingEvent {
        case eventName = "ScreenId_EventName"
     }

     enum MyCustomEvent: String, Trackable {
        case myEvent = "MyCustomEventName"

         var name: String { return rawValue }
         var parameters: [String: Any]? { return ["my_parameter": "my_value"] }

     }

 Then, from a view controller's `viewDidAppear` method call `trackEvent` method on UIViewController:

     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         trackEvent(MyMenuEvent.eventName)
     }

 Finally, you can subclass the Tracker for testing purposes. In that case, replace the singleton instance stored in
 the `shared` property.

 */
open class Tracker {

    /// Singleton instance.
    public static var shared = Tracker()

    /// All registered objects handling tracking events
    private var trackingHandlers = [TrackingHandler]()

    /// Registers new handler of tracking events.
    ///
    /// - Parameter handler: this object will receive all tracking events. The same object will not be added twice.
    ///                      The handler is retained by the Tracker.
    open func append(handler: TrackingHandler) {
        guard !trackingHandlers.contains(where: { $0 === handler }) else { return }
        trackingHandlers.append(handler)
    }


    /// Deletes a handler, if it is registered. If not, this operation does nothing.
    ///
    /// - Parameter handler: previously registered handler
    open func remove(handler: TrackingHandler) {
        if let handlerIndex = trackingHandlers.firstIndex(where: { $0 === handler }) {
            trackingHandlers.remove(at: handlerIndex)
        }
    }

    /// Propagates the tracked event to all registered event handlers.
    ///
    /// - Parameters:
    ///   - event: occurred event
    ///   - parameters: optional parameters that will be combined with the Trackable.parameters. These parameters
    ///                 will override any parameters from Trackable with the same key.
    open func track(event: Trackable, parameters: [String: Any]? = nil) {
        var joinedParameters = event.parameters ?? [:]
        parameters?.forEach { joinedParameters[$0.key] = $0.value }
        let trackedParameters: [String: Any]? = joinedParameters.isEmpty ? nil : joinedParameters
        for handler in trackingHandlers {
            handler.track(event: event.eventName, parameters: trackedParameters)
        }
    }

}

/// Concrete implementations of tracking systems should conform to this protocol to be registered with the Tracker.
public protocol TrackingHandler: class {
    /// Track event with parameters.
    ///
    /// - Parameters:
    ///   - event: occurred event
    ///   - parameters: optional parameters
    func track(event: String, parameters: [String: Any]?)
}

/// Conform your enum to this protocol for it to be tracked with Tracker.
public protocol Trackable {
    // Raw value of the enum (String)
    var rawValue: String { get }
    // Event type for tracking. Default value is `rawValue`
    var eventName: String { get }
    // Parameters to supply with the event. Default value is `nil`.
    var parameters: [String: Any]? { get }
}

public extension Trackable {

    var eventName: String { return rawValue }
    var parameters: [String: Any]? { return nil }

}

public extension Tracker {

    static let screenViewEventName = "gnosis_screen_view"
    static let screenNameEventParameterName = "screen_name"

}

public protocol ScreenTrackingEvent: Trackable {}

public extension ScreenTrackingEvent {

    var eventName: String { return Tracker.screenViewEventName }
    var parameters: [String: Any]? { return [Tracker.screenNameEventParameterName: rawValue] }

}
