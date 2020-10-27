//
//  AnnouncementsView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/27.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct AnnouncementsView: View {
    
    @State var announcements = [Announcement]()
    
    var body: some View {
        List{
            ForEach(Array(zip(self.announcements.indices, self.announcements)),  id: \.0){ index, announcement in
                NavigationLink(destination: AnnouncementDetailView(announcement: announcement)){
                    HStack{
                        Text(announcement.title)
                            .foregroundColor(Color.black)
                            .font(.system(size: 14))
                        
                        Spacer()
                        
                        Text(announcement.date)
                            .foregroundColor(Color.black)
                            .font(.system(size: 10))
                        
                    }
                }
            }
        }
        .onAppear(perform: fetchAnnouncements)
    }
    
    func fetchAnnouncements() {
        guard let url = URL(string: REST_API.SPACE.FETCH_ANNOUNCEMENTS) else {return}
        
        let params = [
            "userUniqueId": UserInfo.getInstance.uniqueId
        ]
        
        
        
        do{
            let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
            var request = URLRequest(url: url)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonParams
            URLSession.shared.dataTask(with: request) {(data, response, error) in
                if data == nil {
                    return
                }
                
                do{
                    if let rawData = data {
                        let announcements = try JSONDecoder().decode([Announcement].self, from: rawData)
                        
                        self.announcements = announcements
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

struct AnnouncementsView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementsView()
    }
}
