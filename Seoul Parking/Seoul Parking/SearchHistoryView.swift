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
                    Text(elem.date)
                        .foregroundColor(Color.black)
                        .padding()
                    
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
        let history = [
            SearchHistory(address: "선릉역", date: "2020-09-08"),
            SearchHistory(address: "강남역", date: "2020-09-10")
        ]
        
        self.searchHistory = history
    }
}

struct SearchHistory {
    var address: String
    var date: String
}

struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView()
    }
}
