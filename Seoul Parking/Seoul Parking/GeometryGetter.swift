//
//  GeometryGetter.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/10/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct GeometryGetter: View {
    @Binding var rect : CGRect
    var body: some View {
        GeometryReader() { geometry in
            self.makeView(geometry: geometry)
        }
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            
            
            print(geometry.size.width, geometry.size.height)
            self.rect = geometry.frame(in: .global)
        }

        return Rectangle().fill(Color.clear)
    }
    
    
}

struct GeometryGetter_Previews: PreviewProvider {
    static var previews: some View {
        GeometryGetter(rect: .constant(CGRect()))
    }
}
