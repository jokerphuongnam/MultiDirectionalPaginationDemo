//
//  ContentView.swift
//  MultiDirectionalPaginationDemo
//
//  Created by gannha on 10/06/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var index: Int = 0
    @State private var items: [Data] = .demo
    @State private var pageNumberInput: String = ""
    var body: some View {
        GeometryReader { proxy in
            let mainHeight = proxy.size.height
            ZStack {
                MultiDirectionalPagination (
                    index: $index,
                    items: items
                ) { item in
                    Text(item.id)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color.blue)
                        .cornerRadius(20)
                } edge: {
                    Color.gray
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .cornerRadius(20)
                }
                .rest(at: .constant([0, mainHeight - 200]))
                .offset(y: -200)
            }
            .background(Color.white)
            
            VStack {
                TextField("Intput page number...", text: $pageNumberInput)
                    .foregroundColor(.black)
                    .padding()
                
                Button {
                    guard let pageNumber = Int(pageNumberInput) else {
                        return
                    }
                    
                    index = pageNumber
                } label: {
                    if let pageNumber = Int(pageNumberInput) {
                        Text("Move to page: \(pageNumber).")
                    } else {
                        Text("Please input number.")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private extension Array where Element == Data {
    static var demo: Self = {
        var demo: Self = []
        
        for index in 0...30 {
            demo.append(.init(id: "Test: \(index)"))
        }
        
        return demo
    }()
}

struct Data: Identifiable {
    var id: String
}
