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
                   
                    Text(elem.address)
                        .foregroundColor(Color.black)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .listRowInsets(EdgeInsets())
                .background(Color.white)
            }
        }

        .onAppear(perform: fetch)
        
        .navigationBarTitle("검색내역")
    
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
