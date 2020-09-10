//
//  PaymentHistoryView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/09/08.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct Payment {
    var paymentId: String
    var date: String
    var parkingLotName: String
    var isPaid: Bool
}

struct PaymentHistoryView: View {
    
    @State var history = [Payment]()
    
    var body: some View {
        
        List{
            ForEach(Array(zip(self.history.indices, self.history)), id: \.0){ index, elem in
                NavigationLink(destination: PayView()){
                    
                    VStack(alignment: .center){
                        Text(elem.date)
                            .foregroundColor(Color.black)
                            .padding()
                        Text(elem.parkingLotName)
                            .foregroundColor(Color.black)
                            .padding()
                        
                        Text(elem.isPaid ? "결제완료" : "요금미납")
                            .foregroundColor(Color.black)
                            .padding()
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
//                    .padding()
//                    .shadow(color: Color.gray, radius: 10)
//                    .navigationBarTitle("결제내역")

                }
            
            }
        }
            .onAppear(perform: getHistory)

        
    }
    
    func getHistory() {
        let history = [
            Payment(paymentId: "1", date: "2020-09-03", parkingLotName: "선릉역1", isPaid: false),
            Payment(paymentId: "2", date: "2020-09-04", parkingLotName: "선릉역2", isPaid: true),
            Payment(paymentId: "3", date: "2020-09-05", parkingLotName: "선릉역3", isPaid: true),
            Payment(paymentId: "4", date: "2020-09-06", parkingLotName: "선릉역4", isPaid: false),
            Payment(paymentId: "5", date: "2020-09-07", parkingLotName: "선릉역5", isPaid: false)
        ]
        
        
        self.history = history
        
    }
}

struct PaymentHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentHistoryView()
    }
}
