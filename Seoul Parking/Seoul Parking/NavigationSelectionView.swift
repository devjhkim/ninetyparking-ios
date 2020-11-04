//
//  NavigationSelectionView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/30.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import KakaoSDKNavi
import TMapSDK

struct NavigationSelectionView: View {
    //@Binding var auxViewType: AuxViewType
    @State var selectedParkingSpace: ParkingSpace
    
    @State var tmap: TMapView?
    @State var frame: CGRect?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        
        VStack{
            
            
            Text("내비게이션 선택")
                .bold()
                .foregroundColor(Color.black)
                .font(.system(size: 18))
                .padding(.top, 30)
            
            
            HStack{
                Image("tmap")
                
                
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.openTMapNavi()
                }){
                    Text("티맵")
                        .foregroundColor(Color.black)
                        .font(.system(size: 20))
                }
                
                Spacer()
                
            }
            .padding(.top, 10)
            .padding(.leading, 20)
            
          
                
            HStack{
                Image("kakaoNavi")
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.openKakaoNavi()
                }){
                    Text("카카오")
                        .foregroundColor(Color.black)
                        .font(.system(size: 20))
                }
                

                Spacer()
            }
            .padding(.top, 10)
            .padding(.leading, 20)
            
            HStack{
                Image("naverMap")
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.openNaverNavi()
                }){
                    Text("네이버")
                        .foregroundColor(Color.black)
                        .font(.system(size: 20))
                }
                

                Spacer()
            }
            .padding(.top, 10)
            .padding(.leading, 20)

            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }){
                Text("닫기")
                    .foregroundColor(Color.red)
                    .font(.system(size: 20))
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .background(Color.white)
        
        
    }
    
    func openKakaoNavi(){
       
        let option = NaviOption(coordType: .WGS84)
        let destination = NaviLocation(name: "카카오판교오피스", x: "127.108640", y: "37.402111")
        let viaList = [NaviLocation(name: "판교역 1번출구", x: "127.111492", y: "37.395225")]
        guard let navigationUrl = NaviApi.shared.navigateUrl(destination: destination, option: option, viaList: viaList) else {
            return
        }
        
        UIApplication.shared.open(navigationUrl, options: [:], completionHandler: nil)
    }
    
    func openNaverNavi() {
        
        var components = URLComponents()
        components.scheme = "nmap"
        components.host = "navigation"
        components.queryItems = [
            URLQueryItem(name: "dlat", value: self.selectedParkingSpace.latitude.description),
            URLQueryItem(name: "dlng", value: self.selectedParkingSpace.longitude.description),
            URLQueryItem(name: "dname", value: self.selectedParkingSpace.spaceName),
            URLQueryItem(name: "appname", value: "kr.co.ninety.parking")
        ]
        
        let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!

        if let url = components.url {
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url)
            }else{
                UIApplication.shared.open(appStoreURL)
            }
        }
        
    }
    
    func openTMapNavi() {
      
        var components = URLComponents()
        components.scheme = "tmap"
        components.host = ""
        components.queryItems = [
            URLQueryItem(name: "rGoY", value: self.selectedParkingSpace.latitude.description),
            URLQueryItem(name: "rGoX", value: self.selectedParkingSpace.longitude.description),
            URLQueryItem(name: "rGoName", value: self.selectedParkingSpace.spaceName)
            
        ]
        
        let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!

        if let url = components.url {
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url)
            }else{
                UIApplication.shared.open(appStoreURL)
            }
        }
    }
}


struct NavigationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSelectionView(selectedParkingSpace: ParkingSpace())
    }
}

struct TNaviView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 1000, height: 1000)))
        let tmap = TMapView(frame: view.frame)
        tmap.setApiKey(TMAP_API_KEY)
        
        view.addSubview(tmap)
        
        TMapApi.setSKTMapAuthenticationWithDelegate(context.coordinator, apiKey: TMAP_API_KEY)
        let result = TMapApi.invokeRoute("관악", coordinate: CLLocationCoordinate2D(latitude: 127, longitude: 32))
        print(result)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    class Coordinator: NSObject, TMapTapiDelegate {
        
        func SKTMapApikeySucceed() {
            print("success")
        }
        
        func SKTMapApikeyFailed(error: NSError?) {
            print(error?.localizedDescription)
        }
    }
    
}
