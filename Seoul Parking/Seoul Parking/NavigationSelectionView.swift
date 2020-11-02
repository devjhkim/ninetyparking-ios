//
//  NavigationSelectionView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/30.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import KakaoSDKNavi

struct NavigationSelectionView: View {
    @Binding var auxViewType: AuxViewType
    @Binding var selectedParkingSpace: ParkingSpace
    
    var body: some View {
        ZStack{
            GeometryReader(){ reader in
                EmptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.gray.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
            
            ZStack{
                Color.init( red: 229, green: 229, blue: 234)
                    .frame(width: 300, height: 200, alignment: Alignment.center)
                    .cornerRadius(10)
                
                VStack{
                    Spacer()
                    
                    Text("내비게이션 선택")
                        .bold()
                        .foregroundColor(Color.black)
                        .padding()
                    
                    Button(action: {}){
                        Text("티맵")
                            .foregroundColor(Color.black)
                    }
                    

                    Button(action: {
                        self.auxViewType.showNavigationSelectionView.toggle()
                        self.openKakaoNavi()
                    }){
                        Text("카카오")
                            .foregroundColor(Color.black)
                    }
                    .padding(.top, 10)

                    Button(action: {
                        self.auxViewType.showNavigationSelectionView.toggle()
                        self.openNaverNavi()
                    }){
                        Text("네이버")
                            .foregroundColor(Color.black)
                    }
                    .padding(.top, 10)

                    Button(action: {self.auxViewType.showNavigationSelectionView.toggle()}){
                        Text("닫기")
                            .foregroundColor(Color.red)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .frame(width: 290, height: 190, alignment: Alignment.center)
                
            }
            
        }
    }
    
    func openKakaoNavi(){
       
        let option = NaviOption(coordType: .WGS84)
        //let destination =  NaviLocation(name: self.selectedParkingSpace.spaceName, x: self.selectedParkingSpace.longitude.description, y: self.selectedParkingSpace.latitude.description)
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
}

struct NavigationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSelectionView(auxViewType: .constant(AuxViewType()), selectedParkingSpace: .constant(ParkingSpace()))
    }
}
