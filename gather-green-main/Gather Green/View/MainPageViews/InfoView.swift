//
//  InfoView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 4/4/23.
//


import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack{
            
            List() {
                
                Section(header:Text("PREVENTION")
                    .font(.title)
                    .foregroundColor(Color("accentColor"))){
                        Text("Gather Green prevents waste production in businesses and events by providing a Waste Management and Diversion Plan to help organizers minimize waste and make the event more eco-friendly.")
                    }
                Section(header:Text("REDUCTION")
                    .font(.title)
                    .foregroundColor(Color("accentColor"))){
                        Text("Gather Green's Sustainable Event Assessment and Business Waste Audit identifies waste reduction opportunities and gets vendors, sponsors, caterers, staff, and volunteers onboard through education and training to reduce the event's overall footprint.")
                    }
                Section(header:Text("DIVERSION")
                    .font(.title)
                    .foregroundColor(Color("accentColor"))){
                        Text("Gather Green diverts waste from landfills and recycling facilities by researching reuse options and sorting trash for artists, builders, and local businesses.")
                    }
                Section(header:Text("TRANSFORMATION")
                    .font(.title)
                    .foregroundColor(Color("accentColor"))){
                        Text("Gather Green's commercial composting service, Compost Now, transforms organic waste from events and businesses into compost, offering affordable serving-ware options and diverting waste from landfills.")
                    }
                HStack{
                    Spacer()
                    Image("RoundLogo")
                        .resizable()
                        .frame(width: 200,height:200,alignment: .center)
                    Spacer()
                }
            }
            
        }.navigationTitle("Gather Green Services")
    }
        
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
