//
//  PaymentMethodSelectionView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI



struct PaymentMethodLabel {
    var label : Text
    var method : String
}

struct PaymentMethodSelectionView: View {
    //@Binding var auxViewType: AuxViewType
    @State var amount: String
    @State var oid: String
    @State var selectedMethod = ""
    @State var formattedCurrencyAmount = ""
    @State var showPayView = false
    @State var showSelectMethodAlert = false
    
    var paymentMethods = [
        PaymentMethodLabel(label: Text("신용카드"), method: "CARD"),
        PaymentMethodLabel(label: Text("휴대전화"), method: "MOBILE"),
        PaymentMethodLabel(label: Text("계좌이체"), method: "BANK"),
        PaymentMethodLabel(label: Text("가상계좌이체"), method: "VBANK")
    ]
    
    
    
    var body: some View {
        ZStack{
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading){
                Text(String(format: "결제금액: %@원", self.formattedCurrencyAmount))
                    .bold()
                    .font(.system(size: 18))
                    .foregroundColor(Color.black)
                    .padding()
                
                
                Text("결제 방식을 선택해 주세요:")
                    .foregroundColor(Color.black)
                    .padding()
                    .alert(isPresented: self.$showSelectMethodAlert){
                        Alert(title: Text("결제방식 선택"), message: Text("결제 방식을 선택해 주세요."), dismissButton: .default(Text("확인")))
                    }
                
                                
                List{
                    ForEach(Array(zip(self.paymentMethods.indices, self.paymentMethods)), id: \.0) { index, elem in
                        
                        NavigationLink(destination: PayView(oid: self.oid, amount: self.amount, paymentMethod: elem.method) ){
                            elem.label
                                
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                Spacer()

            }
        }
        .onAppear(perform: {
            
            let intAmount = Int(self.amount) ?? 0
            
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale.current
            numberFormatter.numberStyle = .currency
            
            if let formattedAmount = numberFormatter.string(from: intAmount as NSNumber){
                self.formattedCurrencyAmount = formattedAmount
            }
        })
        .navigationTitle(Text("결제방식"))
        
    }
}

struct PaymentMethodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodSelectionView(amount: "", oid: "")
    }
}
