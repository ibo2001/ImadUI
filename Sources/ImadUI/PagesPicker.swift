//
//  SwiftUIView.swift
//  ImadUI
//
//  Created by Ibrahim Qraiqe on 28/01/2025.
//

//
//  SwiftUIView.swift
//  ImadUI
//
//  Created by Ibrahim Qraiqe on 28/01/2025.
//

import SwiftUI

public struct PagesPicker: View {
    @Binding var selectedValue: Int?
    var range: ClosedRange<Int> = 1...40
    
    var spacing: CGFloat = 10
    var minorPageWidth: CGFloat = 24
    var minorPageHeight: CGFloat = 32
    var indicatorColor: Color = Color(.green)
    var pageImage:Image? = nil
    var pageFillingColor:Color = .secondary
    
    private let tickWidth: CGFloat = 24
    private let majorTickHeight: CGFloat = 32
    private let hitArea: CGFloat = 38
    
    @State private var dragOffset: CGFloat = 0
    @State private var previousDragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    @State private var totalWidth: CGFloat = 0
    @State private var leadingPadding: CGFloat = 0
    
    // computed variables
    private var tickCount: Int {
        range.upperBound - range.lowerBound
    }
    
    public init(selectedValue: Binding<Int?>,
                in range: ClosedRange<Int> = 1...40,
                spacing: CGFloat = 10,
                minorPageWidth: CGFloat = 24,
                minorPageHeight: CGFloat = 32,
                tickColor: Color = .secondary,
                indicatorColor: Color = Color(.green),
                pageImage:Image? = nil,
                pageFillingColor:Color = .secondary
    ) {
        self._selectedValue = selectedValue
        self.range = range
        self.indicatorColor = indicatorColor
        self.pageImage = pageImage
        self.pageFillingColor = pageFillingColor
        
        if minorPageHeight > majorTickHeight {
            self.minorPageHeight = majorTickHeight
        } else {
            self.minorPageHeight = minorPageHeight
        }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Center indicator
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(indicatorColor, style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                    .frame(width: tickWidth + 3, height: majorTickHeight + 3)
                    .zIndex(1)
                
                // Sliding ruler
                ZStack {
                    // Ticks
                    HStack(spacing: spacing) {
                        ForEach(range, id: \.self) { _ in
                            Rectangle()
                                .fill(pageFillingColor)
                                .frame(width: minorPageWidth, height: minorPageHeight)
                                .background {
                                    if let pageImage {
                                        pageImage
                                    }
                                }
                        }
                    }
                    .padding(.leading, leadingPadding)
                    .offset(x: dragOffset)
                }
                .frame(height: hitArea)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            let newOffset = previousDragOffset + value.translation.width
                            // Calculate bounds
                            let minOffset = -totalWidth
                            let maxOffset = 0.0
                            
                            // Constrain drag within bounds
                            dragOffset = min(maxOffset, max(minOffset, newOffset))
                            updateSelectedValue(offset: dragOffset)
                        }
                        .onEnded { _ in
                            isDragging = false
                            snapToNearestTick()
                        }
                )
                .onAppear {
                    totalWidth = (CGFloat(tickCount) * (minorPageWidth + (spacing)))
                    leadingPadding = totalWidth
                    initializePosition()

                }
            }
            .frame(width:geometry.size.width,height: geometry.size.height)
        }
    }
        
    private func updateSelectedValue(offset: CGFloat) {
        let progress = -offset / totalWidth
        let newValue = range.lowerBound + Int((Double(range.upperBound - range.lowerBound) * Double(progress)).rounded())
        withAnimation {
            selectedValue = min(max(newValue, range.lowerBound), range.upperBound)
        }
    }
    
    private func snapToNearestTick() {
        let progress = calculateProgress(for: -dragOffset, totalWidth: totalWidth)
        let snappedValue = range.lowerBound + Int((Double(range.upperBound - range.lowerBound) * Double(progress)).rounded())
        
        // Ensure the value stays within range
        let boundedValue = boundedValue(for: snappedValue)
        let snappedProgress = calculateProgress(for: boundedValue, range: range)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.1)) {
            dragOffset = -snappedProgress * totalWidth
            selectedValue = boundedValue
        }
        previousDragOffset = dragOffset
    }
    
    private func initializePosition() {
        guard let selectedValue else { return }
        let boundedValue = min(max(selectedValue, range.lowerBound), range.upperBound)
        let progress = Double(boundedValue - range.lowerBound) / Double(range.upperBound - range.lowerBound)
        dragOffset = -progress * totalWidth
        previousDragOffset = dragOffset
    }

    private func boundedValue(for value: Int) -> Int {
        return min(max(value, range.lowerBound), range.upperBound)
    }
    
    private func calculateProgress(for value: CGFloat, totalWidth: CGFloat) -> Double {
        return Double(value) / Double(totalWidth)
    }
    
    private func calculateProgress(for value: Int, range: ClosedRange<Int>) -> Double {
        return Double(value - range.lowerBound) / Double(range.upperBound - range.lowerBound)
    }
}
