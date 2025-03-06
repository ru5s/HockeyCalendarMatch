//
//  SlideAction.swift
//  Hockey Match
//
//  Created by DF on 06/06/24.
//

import Foundation
import SwiftUI

let buttonWidth: CGFloat = 60

enum CellButtons: Identifiable {
    case delete
    case edit
    
    var id: String {
        return "\(self)"
    }
    
    var image: String {
        switch self {
        case .delete:
            return "trash"
        case .edit:
            return "pencil"
        }
    }
    
    var color: Color {
        switch self {
        case .delete:
            return .red
        case .edit:
            return .orange
        }
    }
}

private struct CellButtonView: View {
    let data: CellButtons
    let cellHeight: CGFloat
    
    var body: some View {
        VStack {
            Image(systemName: data.image)
                .font(.title2)
        }
        .foregroundColor(.white)
        .frame(width: buttonWidth, height: cellHeight)
        .background(data.color)
    }
}

extension View {
    func addButtonActions(leadingButtons: [CellButtons], trailingButton: [CellButtons], onClick: @escaping (CellButtons) -> Void) -> some View {
        self.modifier(SwipeContainerCell(leadingButtons: leadingButtons, trailingButton: trailingButton, onClick: onClick))
    }
}

private struct SwipeContainerCell: ViewModifier {
    enum VisibleButton {
        case none
        case left
        case right
    }

    @State private var offset: CGFloat = 0
    @State private var oldOffset: CGFloat = 0
    @State private var visibleButton: VisibleButton = .none
    
    let leadingButtons: [CellButtons]
    let trailingButton: [CellButtons]
    let maxLeadingOffset: CGFloat
    let minTrailingOffset: CGFloat
    let onClick: (CellButtons) -> Void
    
    init(leadingButtons: [CellButtons], trailingButton: [CellButtons], onClick: @escaping (CellButtons) -> Void) {
        self.leadingButtons = leadingButtons
        self.trailingButton = trailingButton
        maxLeadingOffset = CGFloat(leadingButtons.count) * buttonWidth
        minTrailingOffset = CGFloat(trailingButton.count) * buttonWidth * -1
        self.onClick = onClick
    }
    
    func reset() {
        visibleButton = .none
        offset = 0
        oldOffset = 0
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .contentShape(Rectangle())
                .offset(x: offset)
                .gesture(DragGesture(minimumDistance: 25, coordinateSpace: .local)
                    .onChanged { value in
                        let totalSlide = value.translation.width + oldOffset
                        if (0...Int(maxLeadingOffset) ~= Int(totalSlide)) || (Int(minTrailingOffset)...0 ~= Int(totalSlide)) {
                            withAnimation {
                                offset = totalSlide
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation {
                            if visibleButton == .left && value.translation.width < -20 {
                                reset()
                            } else if visibleButton == .right && value.translation.width > 20 {
                                reset()
                            } else if abs(offset) > 25 {
                                if offset > 0 {
                                    visibleButton = .left
                                    offset = maxLeadingOffset
                                } else {
                                    visibleButton = .right
                                    offset = minTrailingOffset
                                }
                                oldOffset = offset
                            } else {
                                reset()
                            }
                        }
                    }
                )
            
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    if !leadingButtons.isEmpty {
                        HStack(spacing: 0) {
                            ForEach(leadingButtons) { button in
                                Button(action: {
                                    withAnimation { reset() }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        onClick(button)
                                    }
                                }) {
                                    CellButtonView(data: button, cellHeight: proxy.size.height)
                                }
                            }
                        }
                        .offset(x: (-1 * maxLeadingOffset) + offset)
                    }
                    
                    Spacer()
                    
                    if !trailingButton.isEmpty {
                        HStack(spacing: 0) {
                            ForEach(trailingButton) { button in
                                Button(action: {
                                    withAnimation { reset() }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        onClick(button)
                                    }
                                }) {
                                    CellButtonView(data: button, cellHeight: proxy.size.height)
                                }
                            }
                        }
                        .offset(x: (-1 * minTrailingOffset) + offset)
                    }
                }
            }
        }
    }
}


//let buttonWidth: CGFloat = 60
//
//enum CellButtons: Identifiable {
//    case delete
//    case edit
//    
//    var id: String {
//        return "\(self)"
//    }
//}
//
//private struct CellButtonView: View {
//    let data: CellButtons
//    let cellHeight: CGFloat
//    
//    func getView(for image: String, title: String, color: Color) -> some View {
//        VStack {
//            Image(systemName: image)
//                .font(.title2)
//        }
//        .foregroundColor(.white)
//        .font(.subheadline)
//        .frame(width: buttonWidth, height: cellHeight)
//        .background(color)
//    }
//    
//    var body: some View {
//        switch data {
//        case .delete:
//            getView(for: "trash", title: "Delete", color: Color.red)
//        case .edit:
//            getView(for: "pencil", title: "Edit", color: Color.orange)
//        }
//    }
//}
//
//extension View {
//    func addButtonActions(leadingButtons: [CellButtons], trailingButton: [CellButtons], onClick: @escaping (CellButtons) -> Void) -> some View {
//        self.modifier(SwipeContainerCell(leadingButtons: leadingButtons, trailingButton: trailingButton, onClick: onClick))
//    }
//}
//
//private struct SwipeContainerCell: ViewModifier  {
//    enum VisibleButton {
//        case none
//        case left
//        case right
//    }
//    @State private var offset: CGFloat = 0
//    @State private var oldOffset: CGFloat = 0
//    @State private var visibleButton: VisibleButton = .none
//    let leadingButtons: [CellButtons]
//    let trailingButton: [CellButtons]
//    let maxLeadingOffset: CGFloat
//    let minTrailingOffset: CGFloat
//    let onClick: (CellButtons) -> Void
//    
//    init(leadingButtons: [CellButtons], trailingButton: [CellButtons], onClick: @escaping (CellButtons) -> Void) {
//        self.leadingButtons = leadingButtons
//        self.trailingButton = trailingButton
//        maxLeadingOffset = CGFloat(leadingButtons.count) * buttonWidth
//        minTrailingOffset = CGFloat(trailingButton.count) * buttonWidth * -1
//        self.onClick = onClick
//    }
//    
//    func reset() {
//        visibleButton = .none
//        offset = 0
//        oldOffset = 0
//    }
//    
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//                .contentShape(Rectangle()) ///otherwise swipe won't work in vacant area
//                .offset(x: offset)
//                .gesture(DragGesture(minimumDistance: 25, coordinateSpace: .local)
//                    .onChanged({ (value) in
//                        let totalSlide = value.translation.width + oldOffset
//                        if  (0...Int(maxLeadingOffset) ~= Int(totalSlide)) || (Int(minTrailingOffset)...0 ~= Int(totalSlide)) { //left to right slide
//                            withAnimation{
//                                offset = totalSlide
//                            }
//                        }
//                    })
//                        .onEnded({ value in
//                            withAnimation {
//                                if visibleButton == .left && value.translation.width < -20 { ///user dismisses left buttons
//                                    reset()
//                                } else if  visibleButton == .right && value.translation.width > 20 { ///user dismisses right buttons
//                                    reset()
//                                } else if offset > 25 || offset < -25 { ///scroller more then 50% show button
//                                    if offset > 0 {
//                                        visibleButton = .left
//                                        offset = maxLeadingOffset
//                                    } else {
//                                        visibleButton = .right
//                                        offset = minTrailingOffset
//                                    }
//                                    oldOffset = offset
//                                } else {
//                                    reset()
//                                }
//                            }
//                        }))
//            GeometryReader { proxy in
//                HStack(spacing: 0) {
//                    HStack(spacing: 0) {
//                        ForEach(leadingButtons) { buttonsData in
//                            Button(action: {
//                                withAnimation {
//                                    reset()
//                                }
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { ///call once hide animation done
//                                    onClick(buttonsData)
//                                }
//                            }, label: {
//                                CellButtonView.init(data: buttonsData, cellHeight: proxy.size.height)
//                            })
//                        }
//                    }.offset(x: (-1 * maxLeadingOffset) + offset)
//                    Spacer()
//                    HStack(spacing: 0) {
//                        ForEach(trailingButton) { buttonsData in
//                            Button(action: {
//                                withAnimation {
//                                    reset()
//                                }
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { ///call once hide animation done
//                                    onClick(buttonsData)
//                                }
//                            }, label: {
//                                CellButtonView.init(data: buttonsData, cellHeight: proxy.size.height)
//                            })
//                        }
//                    }.offset(x: (-1 * minTrailingOffset) + offset)
//                }
//            }
//        }
//    }
//}
