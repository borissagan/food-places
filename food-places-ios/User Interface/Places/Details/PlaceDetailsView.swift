//
//  PlaceDetailsView.swift
//  food-places-ios
//
//  Created by Boris Sagan on 13.02.2021.
//

import SwiftUI

struct PlaceDetailsView: View {
  let place: Place
  
  var body: some View {
    Form {
      Section(header: Text("About")) {
        TextRow(title: "Long name", value: place.info.longName ?? "-")
        TextRow(title: "Address", value: place.info.address ?? "-")
        TextRow(title: "Type", value: place.info.type ?? "-")
      }
    }
  }
}

struct TextRow: View {
  let title: String
  let value: String
  
  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Text(value)
    }
  }
}

struct DetailsView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceDetailsView(place: Place(lat: 0, lon: 0, info: PlaceInfo(address: "Test addres", name: "My name", phoneNumber: "+1234543124", longName: "Long address test", url: "http://google.com", type: "coffee")))
  }
}
