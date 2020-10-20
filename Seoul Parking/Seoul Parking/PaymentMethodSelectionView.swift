//
//  PaymentMethodSelectionView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

enum PaymentMethod: String {
    case card = "CARD"
    case phone = "MOBILE"
    case bank = "BANK"
    case vbank = "VBANK"
}

struct PaymentMethodSelectionView: View {
    @State var amount: String
    @State var oid: String
    @State var selectedMethod = ""
    
    var body: some View {
        ZStack{
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading){
                Text(String(format: "결제금액: %@ 원", self.amount))
                    .foregroundColor(Color.black)
                
                Picker(selection: self.$selectedMethod, label: Text("결제방식 선택")){
                    Text("신용카드").tag(PaymentMethod.card)
                    Text("휴대전화").tag(PaymentMethod.phone)
                    Text("계좌이체").tag(PaymentMethod.bank)
                    Text("가장계좌이체").tag(PaymentMethod.vbank)
                }
                

                
            }
        }
    }
}

struct PaymentMethodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodSelectionView(amount: "", oid: "")
    }
}
