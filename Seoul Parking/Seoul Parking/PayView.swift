//
//  PayView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/09/08.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import WebKit

struct PayView: View {
    @State var oid: String
    @State var amount: String
    @State var paymentMethod: String
    
    var body: some View {
        PaymentWebView(oid: self.oid, amount: self.amount, paymentMethod: self.paymentMethod)
    }
}

struct PayView_Previews: PreviewProvider {
    static var previews: some View {
        PayView(oid: "", amount: "", paymentMethod: "")
    }
}

struct PaymentWebView: UIViewRepresentable {
    
    @State var oid: String
    @State var amount: String
    @State var paymentMethod: String
    @EnvironmentObject var store: Store
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        let params =
            "P_INI_PAYMENT=" + self.paymentMethod + "&" +
            "P_MID=" + KG_INICIS_MID + "&" +
            "P_GOODS=주차비&" +
            "P_OID=" + self.oid + "&" +
            "P_AMT=" + self.amount + "&" +
            "P_UNAME=" + self.store.user.name + "&" +
            "P_EMAIL=" + self.store.user.email + "&" +
            "P_NEXT_URL=" + REST_API.PAY_NEXT_URL + "&" +
            "P_NOTI_URL=" + REST_API.PAY_VBANK_URL
        
        
        if let url = URL(string: REST_API.PAY.REQUEST) {
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("euc-kr", forHTTPHeaderField: "accept-charset")
            request.httpMethod = "POST"
            
            let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
            let size = params.lengthOfBytes(using: String.Encoding(rawValue: encodingEUCKR)) + 1
            var buffer: [CChar] = [CChar](repeating: 0, count: size)
            let _ = params.getCString(&buffer, maxLength: size, encoding: String.Encoding(rawValue: encodingEUCKR))
            let data = Data(bytes: buffer, count: size)
            
            request.httpBody = data
            
            webView.load(request)
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    class Coordinator: NSObject {
        
    }
    
}
