//
//  CategoryView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/27/23.
//

import SwiftUI

struct CategoryView: View {
    let isActive: Bool
    let text: String
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text(text)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(isActive ? Color.accentColor : Color.black.opacity(0.5))
            if (isActive) { Color.accentColor
                .frame(width: 15, height: 2)
                .clipShape(Capsule())
            }
        }
        .padding(.trailing)
    }
}
struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(isActive: false, text: "veryvery")
    }
}
