//
//  MultiDirectionalPagination+Modifier.swift
//  DemoPager
//
//  Created by gannha on 20/04/2022.
//

import SwiftUI

extension MultiDirectionalPagination {
    func rest(at heights: Binding<[CGFloat]>) -> Self {
        .init(
            spacing: spacing,
            trailingSpace: trailingSpace,
            index: $index,
            items: list,
            pages: pages,
            heights: heights,
            restingHeight: restingHeight,
            onChangeHeight: didChangeHeight,
            didRestHeight: didRestHeight,
            content: content,
            edge: edge)
    }
    
    func onChangeHeight(perform didChangeHeight: @escaping SetHeightHandle) -> Self {
        .init(
            spacing: spacing,
            trailingSpace: trailingSpace,
            index: $index,
            items: list,
            pages: pages,
            heights: $heights,
            restingHeight: restingHeight,
            onChangeHeight: didChangeHeight,
            didRestHeight: didRestHeight,
            content: content,
            edge: edge)
    }
    
    func onRestHeight(perform didRestHeight: @escaping SetHeightHandle) -> Self {
        .init(
            spacing: spacing,
            trailingSpace: trailingSpace,
            index: $index,
            items: list,
            pages: pages,
            heights: $heights,
            restingHeight: restingHeight,
            onChangeHeight: didChangeHeight,
            didRestHeight: didRestHeight,
            content: content,
            edge: edge)
    }
}
