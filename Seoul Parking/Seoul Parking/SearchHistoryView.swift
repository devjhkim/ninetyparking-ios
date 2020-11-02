//
//  SearchHistoryView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/09/09.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct SearchHistoryView: View {
    @State var searchHistory = [SearchHistory]()
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        List{
            ForEach(Array(zip(self.searchHistory.indices, self.searchHistory)), id: \.0){ index, elem in
                VStack{
                    
                    HStack{
                        Text(elem.address)
                            .foregroundColor(Color.black)
                            .padding()
                        
                        Spacer()

                        
                        Button(action:{}){
                            Image("navigationButton")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {self.delete(index: index)}){
                            Image(systemName: "xmark.circle")
                                .renderingMode(.template)
                                .foregroundColor(Color.gray)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(width: 10, height: 10)
                        .padding()
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .listRowInsets(EdgeInsets())
                .background(Color.white)
            }
            
        }

        .onAppear(perform: fetch)
        
        .navigationBarTitle("검색내역")
    
    }
    
    func delete(index: Int) {
        
        
        guard let url = URL(string: REST_API.SPACE.DELETE_HISTORY) else {return}
        
        let params = [
            "userUniqueId": UserInfo.getInstance.uniqueId,
            "historyUniqueId": self.searchHistory[index].historyUniqueId
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
                        let json = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String:Any]
                        
                        if let json = json {
                            guard let statusCode = json["statusCode"] as? String else {return}
                            
                            switch statusCode {
                            case "200":
                                self.searchHistory.remove(at: index)
                                break
                                
                            case "201":
                                
                                break
                            case "500":
                               
                                break
                            default:
                                break
                            }
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
    
    func fetch() {
        guard let url = URL(string: REST_API.SPACE.SEARCH_HISTORY) else {return}
        
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
                        let history = try JSONDecoder().decode([SearchHistory].self, from: rawData)
                        
                        DispatchQueue.main.async {
                            self.searchHistory = history
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


struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView()
    }
}
