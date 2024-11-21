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
}

#if DEBUG
#Preview {
    WeatherView(viewModel: WeatherViewModel(networkLayer: NetworkLayerMock()))
}
#endif
