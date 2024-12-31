//
//  OrderedListComponent.swift
//  ChatBot
//
//  Created by Aleksei Tsyss on 12/31/24.
//

import SwiftUI

struct OrderedListComponent: View {
    let items: [String]
    
    init(items: [String]) {
        if items.isEmpty {
            self.items = [
                "SwiftUI animates the effects that many built-in view modifiers produce, like those that set a scale or opacity value. You can animate other values by making your custom views conform to the Animatable protocol, and telling SwiftUI about the value you want to animate.",
                "When an animated state change results in adding or removing a view to or from the view hierarchy, you can tell SwiftUI how to transition the view into or out of place using built-in transitions that AnyTransition defines, like slide or scale. You can also create custom transitions.",
                "SwiftUI provides views, controls, and layout structures for declaring your app’s user interface. The framework provides event handlers for delivering taps, gestures, and other types of input to your app, and tools to manage the flow of data from your app’s models down to the views and controls that users see and interact with.",
                "Define your app structure using the App protocol, and populate it with scenes that contain the views that make up your app’s user interface. Create your own custom views that conform to the View protocol, and compose them with SwiftUI views for displaying text, images, and custom shapes using stacks, lists, and more. Apply powerful modifiers to built-in views and your own views to customize their rendering and interactivity. Share code between apps on multiple platforms with views and controls that adapt to their context and presentation."
            ]
        } else {
            self.items = items
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items.enumerated().map { ($0, $1) }, id: \.0) { index, item in
                HStack(alignment: .top, spacing: 0) {
                    Text("\(index + 1).")
                        .frame(width: 20, alignment: .leading)
                        .lineLimit(nil)
                    
                    Text(item)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding() // Optional: Add padding around the list
    }
}

#Preview {
    ScrollView(.vertical) {
        OrderedListComponent(
            items: [
                "SwiftUI animates the effects that many built-in view modifiers produce, like those that set a scale or opacity value. You can animate other values by making your custom views conform to the Animatable protocol, and telling SwiftUI about the value you want to animate.",
                "When an animated state change results in adding or removing a view to or from the view hierarchy, you can tell SwiftUI how to transition the view into or out of place using built-in transitions that AnyTransition defines, like slide or scale. You can also create custom transitions.",
                "SwiftUI provides views, controls, and layout structures for declaring your app’s user interface. The framework provides event handlers for delivering taps, gestures, and other types of input to your app, and tools to manage the flow of data from your app’s models down to the views and controls that users see and interact with.",
                "Define your app structure using the App protocol, and populate it with scenes that contain the views that make up your app’s user interface. Create your own custom views that conform to the View protocol, and compose them with SwiftUI views for displaying text, images, and custom shapes using stacks, lists, and more. Apply powerful modifiers to built-in views and your own views to customize their rendering and interactivity. Share code between apps on multiple platforms with views and controls that adapt to their context and presentation."
            ]
        )
        .padding()
    }
}
