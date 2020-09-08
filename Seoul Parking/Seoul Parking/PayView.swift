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
        
        
        do{
            //let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
            if let url = URL(string: REST_API.PAY.REQUEST) {
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("euc-kr", forHTTPHeaderField: "accept-charset")
                //request.setValue("ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7", forHTTPHeaderField: "Accept-Language")
                request.httpMethod = "POST"
                
                let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)

                let size = params.lengthOfBytes(using: String.Encoding(rawValue: encodingEUCKR)) + 1

                var buffer: [CChar] = [CChar](repeating: 0, count: size)

                /// UTF8 -> EUC-KR 로 변환
                
                let _ = params.getCString(&buffer, maxLength: size, encoding: String.Encoding(rawValue: encodingEUCKR))
                let data = Data(bytes: buffer, count: size)
                request.httpBody = data
                
                webView.load(request)
                
//                URLSession(configuration: .default).dataTask(with: request){ (data, response, error) in
//                    DispatchQueue.main.async {
//                        print(data)
//                        print(response)
//
//                        webView.load(data!, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: nil)
//                    }
//                }.resume()
                
            }
        }catch{
            fatalError(error.localizedDescription)
        }
        return webView
    }
    
    func euckrEncoding(_ query: String) -> String { //EUC-KR 인코딩
        let rawEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue))
        let encoding = String.Encoding(rawValue: rawEncoding)
        let eucKRStringData = query.data(using: encoding) ?? Data()
        let outputQuery = eucKRStringData.map {byte->String in
            if byte >= UInt8(ascii: "A") && byte <= UInt8(ascii: "Z")
                || byte >= UInt8(ascii: "a") && byte <= UInt8(ascii: "z")
                || byte >= UInt8(ascii: "0") && byte <= UInt8(ascii: "9")
                || byte == UInt8(ascii: "_") || byte == UInt8(ascii: ".")
                || byte == UInt8(ascii: "-") {
                return String(Character(UnicodeScalar(UInt32(byte))!))
                
            } else if byte == UInt8(ascii: " ") {
                return "+"
                
            } else {
                return String(format: "%%%02X", byte) }
            
        }.joined()
        
        return outputQuery
        
    }

    
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    class Coordinator: NSObject {
        
    }
    
}
