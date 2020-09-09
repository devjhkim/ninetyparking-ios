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
    var body: some View {
        PaymentWebView()
    }
}

struct PayView_Previews: PreviewProvider {
    static var previews: some View {
        PayView()
    }
}

struct PaymentWebView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        let params =
            "P_INI_PAYMENT=CARD&" +
            "P_MID=INIpayTest&" +
            "P_GOODS=주차비&" +
            "P_OID=134&" +
            "P_AMT=1000&" +
            "P_UNAME=나인티&" +
            "P_EMAIL=abc@gmail.com&" +
            "P_NEXT_URL=https://ninetysystem.cafe24.com&" +
            "P_NOTI_URL=https://ninetysystem.cafe24.com"
        
        
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
