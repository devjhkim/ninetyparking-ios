//
//  UnpaidPaymentHistoryView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/27.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct UnpaidPaymentHistoryView: View {
    
    
    @State var history = [Payment]()
    @State var showPaymentMethodSelectionView  = false
    
    
    var body: some View {
   
        ZStack{
            
            
            List{
                ForEach(Array(zip(self.history.indices, self.history)), id: \.0){ index, elem in
                    
                    
                    
                    NavigationLink(destination: PaymentMethodSelectionView( amount: elem.amount, oid: elem.paymentUniqueId)){

                        VStack(alignment: .leading){
                            Text(String(format: "주차일자: %@", elem.date))
                                .foregroundColor(Color.black)
                                .padding(.top, 10)
                                
                            Text(String(format: "주차지: %@", elem.address))
                                .foregroundColor(Color.black)
                                .padding(.top, 5)
                            
                            Text(String(format: "주차금액: %@원", self.getFormattedCurrency(amount: elem.amount)))
                                .foregroundColor(Color.black)
                                .padding(.top, 5)
                            
                            Text(elem.isPaid ? "결제완료" : "요금미납")
                                .foregroundColor(Color.black)
                                .padding(.top, 5)
                                .padding(.bottom, 10)

                        }
                    }
                    .disabled(elem.isPaid)
                }
                
            }
            .onAppear(perform: getHistory)
            
        }
 
    }
    
    private func getFormattedCurrency(amount: String) -> String {
        let intAmount = Int(amount) ?? 0
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .currency
        
        if let formattedAmount = numberFormatter.string(from: intAmount as NSNumber){
            return formattedAmount
        }else{
            return ""
        }

    }
    
    func getHistory() {
        
        
        guard let url = URL(string: REST_API.MENU.PAYMENT_HISTORY) else {return}
        
        let params = [
            "userUniqueId": UserInfo.getInstance.uniqueId
        ]
        
        do{
            let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
            
            var request = URLRequest(url: url)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonParams
            
            URLSession.shared.dataTask(with: request){(data, response, error) in
                if data == nil {
                    return
                }
                
                do{
                    if let rawData = data {
                        let history = try JSONDecoder().decode([Payment].self, from: rawData)
                        
                        DispatchQueue.main.async {
                            
                            var unpaidHisotry = [Payment]()
                            
                            history.forEach{ elem in
                                if !elem.isPaid {
                                    unpaidHisotry.append(elem)
                                }
                            }
                            
                            self.history = unpaidHisotry
                        }
                    }
                }catch{
                    fatalError(error.localizedDescription)
                }
                
            }.resume()
        }catch{
            fatalError(error.localizedDescription)
        }
        
        
        
    }
}

struct UnpaidPaymentHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        UnpaidPaymentHistoryView()
    }
}
