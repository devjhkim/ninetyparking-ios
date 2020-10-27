//
//  AnnoucementDetailView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/27.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct AnnouncementDetailView: View {
    @State var announcement: Announcement
    
    var body: some View {
        VStack{
            Text(announcement.announcement)
                .foregroundColor(Color.black)
                .font(.system(size: 13))
                .padding()
            
            Spacer()
        }
        
    }
}
