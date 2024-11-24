//
//  ResultCardView.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/23/24.
//

import SwiftUI

struct ResultCardView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.locationName)
                    .font(.custom(
                        currentTheme.fontFamily, fixedSize: 20))
                    .fontWeight(.semibold)
                    .padding(.bottom, -8)
                HStack(alignment: .top, spacing: 0) {
                    Text(viewModel.temperature)
                        .font(.custom(
                            currentTheme.fontFamily, fixedSize: 50))
                        .fontWeight(.regular)
                    Text("°")
                        .font(.title)
                        .padding(.top, 8)
                }
                .padding(.bottom, -12)
            }
            .frame(maxWidth: .infinity)
            CachedAsyncImage(url: viewModel.conditionsIconUrl) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                default:
                    Image(systemName: "photo")
                        .font(.title)
                        .foregroundStyle(.placeholder)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(minHeight: 117)
        .background {
            currentTheme.backgroundColor
        }
        .cornerRadius(16)
    }
}
