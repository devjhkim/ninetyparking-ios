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
    var amount: String
}

struct PaymentHistoryView: View {
    
    //@Binding var auxViewType: AuxViewType
    @State var history = [Payment]()
    //@EnvironmentObject var notificationCenter: NotificationCenter
    
    
    var body: some View {
   
        ZStack{
            
            
            List{
                ForEach(Array(zip(self.history.indices, self.history)), id: \.0){ index, elem in
                    NavigationLink(destination: PaymentMethodSelectionView( amount: elem.amount, oid: elem.paymentId)){

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


                    }

                }
            }
            .onAppear(perform: getHistory)
            


            
        }


        
    }
    
    func getHistory() {
        let history = [
            Payment(paymentId: "1", date: "2020-09-03", parkingLotName: "선릉역1", isPaid: false, amount: "1000"),
            Payment(paymentId: "2", date: "2020-09-04", parkingLotName: "선릉역2", isPaid: true, amount: "25000"),
            Payment(paymentId: "3", date: "2020-09-05", parkingLotName: "선릉역3", isPaid: true, amount: "4000"),
            Payment(paymentId: "4", date: "2020-09-06", parkingLotName: "선릉역4", isPaid: false, amount: "55000"),
            Payment(paymentId: "5", date: "2020-09-07", parkingLotName: "선릉역5", isPaid: false, amount: "10000")
        ]
        
        
        self.history = history
        
    }
}

struct PaymentHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentHistoryView()
    }
}

