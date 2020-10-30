//
//  NavigationSelectionView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/30.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct NavigationSelectionView: View {
    var body: some View {
        ZStack{
            GeometryReader(){ reader in
                EmptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.gray.opacity(0.3))
            
            ZStack{
                Color.init( red: 229, green: 229, blue: 234)
                    .frame(width: 300, height: 200, alignment: Alignment.center)
                    .cornerRadius(10)
                
                VStack{
                    Spacer()
                    
                    
                    
                    Spacer()
                }
                .frame(width: 290, height: 190, alignment: Alignment.center)
                
            }
            
        }
    }
}

struct NavigationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSelectionView()
    }
}
