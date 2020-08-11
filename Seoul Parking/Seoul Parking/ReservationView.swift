//
//  ReservationView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 8/10/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct ReservationView: View {
    @State var plateNumber: String = ""
    
    
    var body: some View {
        
        GeometryReader() {proxy in
            ZStack{
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    Text("주차예약")
                        .foregroundColor(Color.black)
                        .padding()
                    
                    ZStack{
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: proxy.size.width * 0.9, height: 150)
                            .cornerRadius(20)
                            .opacity(0.3)
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("입차시간:")
                                    .foregroundColor(Color.black)
                                
                                Spacer()
                                
                                Text("14:00 ~ 14:29")
                                    .foregroundColor(Color.black)
                                
                            }
                            .padding()
                            
                            HStack{
                                Text("차량번호:")
                                    .foregroundColor(.black)
                                
                                
                                Spacer()
                                
                                TextField("11나3333", text: self.$plateNumber)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.trailing)
                                
                                
                            }
                            
                            .padding()
                            
                            
                            Spacer()
                            
                        }
                        .frame(width: proxy.size.width * 0.8, height: 130)
                        
                        
                    }
                    
                    Spacer()
                }
                
                
                
                
                
            }
            
            
        }
        
        
    }
    

}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView()
    }
}
