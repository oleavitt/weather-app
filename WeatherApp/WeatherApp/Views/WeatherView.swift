//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject var viewModel: WeatherViewModel

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .empty:
                    emptyView
                case .loading:
                    loadingView
                case .success:
                    weatherView
                case .failure:
                    errorView
                }
            }
            .searchable(text: $viewModel.locationQuery,
                        prompt: "placeholder_search_location")
            .onSubmit(of: .search) {
                Task {
                    await viewModel.getCurrentWeather()
                }
            }
            .padding()
        }
    }
    
    var emptyView: some View {
        VStack {
            Text("empty_no_city")
                .font(.title)
                .fontWeight(.semibold)
            Text("empty_please_search")
                .font(.body)
        }
    }
    
    var loadingView: some View {
        VStack {
            ProgressView("one_moment_please")
        }
    }
    
    var weatherView: some View {
        VStack {
            CachedAsyncImage(url: viewModel.conditionsIconUrl) { phase in
                switch phase {
                case .success(let image):
                    image
                case .failure(_):
                    errorImage
                case .empty:
                    placeHolderImage
                @unknown default:
                    placeHolderImage
                }
            }
            Text(viewModel.locationName)
            Text(viewModel.temperature)
            Text(viewModel.feelsLike)
            Text(viewModel.humidity)
            Text(viewModel.uvIndex)
        }
    }
    
    var errorView: some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                Text(viewModel.errorMessage)
            }
            Spacer()
        }
    }
    
    var placeHolderImage: some View {
        Image(systemName: "photo")
            .font(.title)
            .foregroundStyle(.placeholder)
    }
    
    @ViewBuilder
    var errorImage: some View {
        if #available(iOS 18, *) {
            // Show the new system two color photo with red (!) overlay
            Image(systemName: "photo.badge.exclamationmark")
                .font(.title)
                .foregroundStyle(.placeholder)
                .symbolRenderingMode(.multicolor)
        } else {
            // Otherwise show the old "photo" image in red
            Image(systemName: "photo")
                .font(.title)
                .foregroundStyle(.red)
        }
    }
}

#if DEBUG
#Preview {
    WeatherView(viewModel: WeatherViewModel(networkLayer: NetworkLayerMock()))
}
#endif
