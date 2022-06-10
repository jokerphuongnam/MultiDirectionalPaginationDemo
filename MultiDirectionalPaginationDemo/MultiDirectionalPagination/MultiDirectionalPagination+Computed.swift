//
//  MultiDirectionalPagination+Computed.swift
//  DemoPager
//
//  Created by gannha on 20/04/2022.
//

import SwiftUI

extension MultiDirectionalPagination: View {
    var body: some View {
        GeometryReader { proxy in
            let contentWidth = proxy.size.width - trailingSpace
            let pageWidth = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(pages, id: \.id) { page in
                    switch page {
                    case .edge:
                        edge()
                            .frame(width: contentWidth)
                    case .item(let item):
                        content(item)
                            .frame(width: contentWidth)
                    }
                }
            }
            .padding(.horizontal, spacing)
            .offset(
                x: (CGFloat(currentIndex) * -pageWidth) + (currentIndex != 0 ? adjustMentWidth : 0) + offsetX,
                y: proxy.size.height + offsetY)
            .offset(y: -restingHeight)
            .gesture(
                DragGesture()
                    .updating($offsetX) { value, out, _ in
                        if !isBlockVerticalDrag && MultiDirectionalPagination.orientationDrag(with: value) == .horizotal && orientationDrag != .vertical {
                            out = value.translation.width
                        }
                    }
                    .updating($offsetY) { value, out, _ in
                        if MultiDirectionalPagination.orientationDrag(with: value) == .vertical && orientationDrag != .horizotal {
                            out = value.translation.height
                        }
                    }
                    .onChanged { value in
                        switch MultiDirectionalPagination.orientationDrag(with: value) {
                        case .horizotal:
                            if !isBlockVerticalDrag {
                                if !isUpdateOrientationDrag {
                                    orientationDrag = .horizotal
                                    isUpdateOrientationDrag.toggle()
                                }
                                
                                animation = nil
                            }
                        case .vertical:
                            if !isUpdateOrientationDrag {
                                orientationDrag = .vertical
                                isUpdateOrientationDrag.toggle()
                            }
                            
                            height = MultiDirectionalPagination.dampen(
                                value.startLocation.y
                                + restingHeight - value.location.y,
                                range: activeBound,
                                spring: springHeight)
                        case .none: break
                        }
                    }
                    .onEnded { value in
                        if orientationDrag == .horizotal {
                            let offsetX = value.translation.width
                            let progress = -offsetX / pageWidth
                            let roundIndex = progress.rounded()
                            currentIndex = max(min(currentIndex + Int(roundIndex), pages.count - 2), 1)
                            index = currentIndex - 1
                            animation = Animation.spring()
                        } else if orientationDrag == .vertical {
                            let change = value.startLocation.y
                            - value.predictedEndLocation.y + restingHeight
                            restingHeight = MultiDirectionalPagination.closest(change, markers: heights)
                            
                            isBlockVerticalDrag = restingHeight == heights.last ?? 0
                        }
                        
                        orientationDrag = nil
                        isUpdateOrientationDrag.toggle()
                    }
            )
        }
        .animation(.easeInOut, value: offsetX == 0)
        .animation(animation)
        .onChange(of: index) { newValue in
            currentIndex = newValue + 1
            animation = Animation.spring()
        }
    }
}

extension MultiDirectionalPagination {
    var activeBound: ClosedRange<CGFloat> {
        return heights.min()!...heights.max()!
    }
    
    static func insertEdge(from items: [T]) -> [Page<T>] {
        var data: [Page<T>] = [.edge]
        data += items.map { e in .item(e) }
        data.append(.edge)
        return data
    }
}
