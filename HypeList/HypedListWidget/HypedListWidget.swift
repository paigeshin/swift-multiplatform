//
//  HypedListWidget.swift
//  HypedListWidget
//
//  Created by paige on 2021/09/26.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    // Before Loading...
    func placeholder(in context: Context) -> SimpleEntry {
        let placeholderHypedEvent = HypedEvent()
        placeholderHypedEvent.color = .green
        placeholderHypedEvent.title = "Loading..."
        return SimpleEntry(date: Date(), hypedEvent: placeholderHypedEvent)
    }

    // Handle Data...
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let upcoming = DataController.shared.getUpcomingForWidget()
        var entry = SimpleEntry(date: Date(), hypedEvent: testHypedEvent1)
        if upcoming.count > 0 {
            entry = SimpleEntry(date: Date(), hypedEvent: upcoming.randomElement())
        }
        completion(entry)
    }

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let upcoming = DataController.shared.getUpcomingForWidget()
        
        let currentDate = Date()
        for hourOffset in 0 ..< upcoming.count {
            // every second
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, hypedEvent: upcoming[hourOffset])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let hypedEvent: HypedEvent?
}

struct HypedListWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geometry in
            if entry.hypedEvent != nil {
                ZStack {
                    if entry.hypedEvent!.image() != nil {
                        entry.hypedEvent!.image()!
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        entry.hypedEvent!.color
                    }
                    
                    Color.black
                        .opacity(0.2)
                    
                    Text(entry.hypedEvent!.title)
                        .foregroundColor(.white)
                        .font(fontSize())
                        .padding()
                        .multilineTextAlignment(.center)

                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(entry.hypedEvent!.timeFromNow())
                                .bold()
                                .padding(10)
                                .foregroundColor(.white)
                        }
                    }
                    
                }
            } else {
                VStack {
                    Spacer()
                    Text("No events upcoming. Tap me to add something!")
                        .padding()
                        .multilineTextAlignment(.center)
                        .font(fontSize())
                    Spacer()
                }

            }
        }
    }
    
    func fontSize() -> Font {
        switch widgetFamily {
        case .systemSmall:
            return .title2
        case .systemMedium:
            return .title
        case .systemLarge:
            return .largeTitle
        @unknown default:
            return .body
        }
    }
    
}


@main
struct HypedListWidget: Widget {
    let kind: String = "HypedListWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HypedListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Hyped Event Widget")
        .description("See your upcoming events!")
    }
}

struct HypedListWidget_Previews: PreviewProvider {
    static var previews: some View {
        HypedListWidgetEntryView(entry: SimpleEntry(date: Date(), hypedEvent: testHypedEvent1))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
//        HypedListWidgetEntryView(entry: SimpleEntry(date: Date(), hypedEvent: testHypedEvent1))
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//        HypedListWidgetEntryView(entry: SimpleEntry(date: Date(), hypedEvent: testHypedEvent1))
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
