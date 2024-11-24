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
                    resultView
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
            .onAppear {
                if viewModel.getLastLocationQuery() {
                    Task {
                        await viewModel.getCurrentWeather()
                    }
                }
            }
            .padding()
        }
    }
    
    var emptyView: some View {
        VStack {
            Text("empty_no_city")
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 30))
                .fontWeight(.semibold)
            Text("empty_please_search")
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 15))
                .fontWeight(.semibold)
        }
    }
    
    var loadingView: some View {
        VStack {
            ProgressView("one_moment_please")
        }
    }
    
    var resultView: some View {
        VStack {
            if viewModel.showDetails {
                CachedAsyncImage(url: viewModel.conditionsIconUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image
                    default:
                        placeHolderImage
                    }
                }
                Text(viewModel.locationName)
                Text(viewModel.temperature)
                Text(viewModel.feelsLike)
                Text(viewModel.humidity)
                Text(viewModel.uvIndex)
            } else {
                ResultCardView(viewModel: viewModel)
                    .onTapGesture {
                        viewModel.showDetails.toggle()
                    }
                Spacer()
            }
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
}

#if DEBUG
#Preview {
    WeatherView(viewModel: WeatherViewModel(networkLayer: NetworkLayerMock()))
}
#endif
