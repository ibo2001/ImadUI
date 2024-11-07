//
//  RulerPicker.swift
//  ImadUI
//
//  Created by Ibrahim Qraiqe on 07/11/2024.
//
import SwiftUI

public struct RulerPicker: View {
    @Binding var selectedValue: Double
    let range: ClosedRange<Double> = 0.5...3.5

    private let tickCount: Int = 31
    private let tickWidth: CGFloat = 1.5
    private let majorTickHeight: CGFloat = 24
    private let minorTickHeight: CGFloat = 12
    private let hitArea: CGFloat = 44
    
    @State private var dragOffset: CGFloat = 0
    @State private var previousDragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    @State private var totalWidth: CGFloat = 0
    @State private var tickSpacing: CGFloat = 0
    @State private var leadingPadding: CGFloat = 0
    
    // computed variables

    public init(selectedValue: Binding<Double>) {
        self._selectedValue = selectedValue
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                // Current value display
                Text(String(format: "%.1fx", selectedValue))
                    .font(.system(size: 34, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                    .contentTransition(.numericText())
                    .animation(.snappy, value: selectedValue)
                    
                ZStack(alignment: .top) {
                    // Center indicator
                    VStack(spacing: 0) {
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.tint)
                            .background(
                                Circle()
                                    .fill(.background)
                                    .frame(width: 24, height: 24)
                                    .shadow(color: .black.opacity(0.1), radius: 1, y: 1)
                            )
                        
                        Rectangle()
                            .fill(.tint)
                            .frame(width: 2, height: 24)
                    }
                    .zIndex(1)
                    
                    // Sliding ruler
                    ZStack {
                        // Background line
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.secondary.opacity(0.3))
                        
                        // Ticks
                        HStack(alignment:.center, spacing: tickSpacing) {
                            ForEach(0..<tickCount, id: \.self) { index in
                                let value = Double(index) * 0.1 + 0.5
                                Rectangle()
                                    .fill(isMainTick(value) ? .primary : .secondary)
                                    .frame(width: tickWidth, height: isMainTick(value) ? majorTickHeight : minorTickHeight)
                                    .opacity(isMainTick(value) ? 0.8 : 0.3)
                                    .overlay(alignment:.bottom){
                                        if isMainTick(value) {
                                            Text(String(format: "%.1f", value))
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundStyle(.secondary)
                                                .frame(width: 30)
                                                .rotationEffect(.degrees(-90))
                                                .offset(y: 20)
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
                        leadingPadding = geometry.frame(in: .local).maxX + 45
                        totalWidth = leadingPadding
                        tickSpacing = geometry.size.width / CGFloat(tickCount - 1)
                        initializePosition()
                    }
                }
                .frame(width: geometry.size.width,height: 80)
            }
            
        }
    }
    
    private func isMainTick(_ value: Double) -> Bool {
        let decimal = (value * 10).truncatingRemainder(dividingBy: 5)
        return decimal == 0
    }
    
    private func updateSelectedValue(offset: CGFloat) {
        let progress = -offset / totalWidth
        let newValue = range.lowerBound + (range.upperBound - range.lowerBound) * Double(progress)
        selectedValue = min(max(newValue.rounded(toPlaces: 1), range.lowerBound), range.upperBound)
    }
    
    private func snapToNearestTick() {
        let progress = calculateProgress(for: -dragOffset, totalWidth: totalWidth)
        let snappedValue = (range.lowerBound + (range.upperBound - range.lowerBound) * Double(progress)).rounded(toPlaces: 1)
        
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
        let boundedValue = min(max(selectedValue, range.lowerBound), range.upperBound)
        let progress = (boundedValue - range.lowerBound) / (range.upperBound - range.lowerBound)
        dragOffset = -progress * totalWidth
        previousDragOffset = dragOffset
    }
    
    private func boundedValue(for value: Double) -> Double {
        return min(max(value, range.lowerBound), range.upperBound)
    }

    private func calculateProgress(for value: Double, totalWidth: Double) -> Double {
        return value / totalWidth
    }

    private func calculateProgress(for value: Double, range: ClosedRange<Double>) -> Double {
        return (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }

}

// Helper extension for rounding to decimal places
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}