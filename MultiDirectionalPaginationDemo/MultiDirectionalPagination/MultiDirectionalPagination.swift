//
//  MultiDirectionalPagination.swift
//  DemoPager
//
//  Created by gannha on 19/04/2022.
//

import SwiftUI

struct MultiDirectionalPagination<Content, Edge, T> where Content: View, Edge: View, T: Identifiable {
    @frozen enum Orienttaion: String {
        case vertical
        case horizotal
    }
    
    @frozen enum Page<T> where T: Identifiable {
        case edge
        case item(T)
    }
    
    @GestureState var offsetX: CGFloat = 0
    @GestureState var offsetY: CGFloat = 0
    
    @State var currentIndex: Int = 1
    @State var height: CGFloat = 0 {
        willSet {
            didChangeHeight?(newValue)
        }
    }
    @State var restingHeight: CGFloat = 0 {
        willSet {
            didRestHeight?(newValue)
        }
    }
    @State var isUpdateOrientationDrag: Bool = false
    @State var isBlockVerticalDrag: Bool = false
    @State var orientationDrag: Orienttaion? = nil
    @Binding var heights: [CGFloat]
    @Binding var index: Int
    
    @State internal var animation: Animation? = Animation.spring()
    
    typealias SetHeightHandle = (_ height: CGFloat) -> ()
    var didChangeHeight: SetHeightHandle? = nil
    var didRestHeight: SetHeightHandle? = nil
    var springHeight: CGFloat = 12
    
    var content: ContentBody
    var edge: EdgeBody
    var list: [T] {
        willSet {
            pages = MultiDirectionalPagination.insertEdge(from: newValue)
        }
    }
    var pages: [Page<T>] = []
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    
    typealias ContentBody = (T) -> Content
    typealias EdgeBody = () -> Edge
    
    init(
        spacing: CGFloat = 15,
        trailingSpace: CGFloat = 200,
        index: Binding<Int> = .constant(0),
        items: [T] = [],
        heights: Binding<[CGFloat]> = .constant([0]),
        startingHeight: CGFloat? = nil,
        blockVerticalDrag: CGFloat? = nil,
        @ViewBuilder content: @escaping ContentBody,
        @ViewBuilder edge: @escaping EdgeBody) {
            self.list = items
            self.pages = MultiDirectionalPagination.insertEdge(from: items)
            self.spacing = spacing
            self.trailingSpace = trailingSpace
            self._index = index
            self._heights = heights
            self.restingHeight = startingHeight ?? heights.wrappedValue.first ?? 0
            self.content = content
            self.edge = edge
        }
}

extension MultiDirectionalPagination {
    init(
        spacing: CGFloat,
        trailingSpace: CGFloat,
        index: Binding<Int>,
        items: [T],
        pages: [Page<T>],
        heights: Binding<[CGFloat]>,
        restingHeight: CGFloat,
        onChangeHeight: SetHeightHandle?,
        didRestHeight: SetHeightHandle?,
        @ViewBuilder content: @escaping ContentBody,
        @ViewBuilder edge: @escaping EdgeBody) {
            self.list = items
            self.pages = pages
            self.spacing = spacing
            self.trailingSpace = trailingSpace
            self._index = index
            self._heights = heights
            self.restingHeight = restingHeight
            self.didChangeHeight = onChangeHeight
            self.didRestHeight = didRestHeight
            self.content = content
            self.edge = edge
        }
}

extension MultiDirectionalPagination.Page: Identifiable {
    var id: String {
        switch self {
        case .edge:
            return UUID().uuidString
        case .item(let user):
            return user.id as? String ?? UUID().uuidString
        }
    }
}

extension MultiDirectionalPagination.Page: Equatable {
    static func == (
        lhs: MultiDirectionalPagination.Page<T>,
        rhs: MultiDirectionalPagination.Page<T>) -> Bool {
            switch (lhs, rhs) {
            case (.edge, .edge):
                return lhs.id == rhs.id
            case (.item(let lhsValue), .item(let rhsValue)):
                return lhsValue.id == rhsValue.id
            default:
                return false
            }
        }
    
}
