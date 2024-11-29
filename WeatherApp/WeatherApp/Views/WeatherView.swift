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
        VStack(spacing: 0) {
            if viewModel.showDetails {
                CachedAsyncImage(url: viewModel.conditionsIconUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 150, height: 150)
                    default:
                        placeHolderImage
                    }
                }
                HStack {
                    Text(viewModel.locationName)
                        .font(.custom(
                            currentTheme.fontFamily, fixedSize: 30))
                        .fontWeight(.semibold)
                    Image(systemName: "location.fill")
                }
                HStack(alignment: .top, spacing: 0) {
                    Text(viewModel.temperature)
                        .font(.custom(
                            currentTheme.fontFamily, fixedSize: 64))
                        .fontWeight(.semibold)
                    Text("°")
                        .font(.title)
                        .padding(.top, 8)
                }
                HStack(spacing: 0) {
                    detailCell("humidity", value: viewModel.humidity)
                    detailCell("uv", value: viewModel.uvIndex)
                    detailCell("feels_like", value: viewModel.feelsLike)
                }
                .frame(width: 274)
                .frame(minHeight: 75)
                .background {
                    currentTheme.backgroundColor
                }
                .cornerRadius(16)
                .padding([.top, .horizontal])
                Toggle(isOn: $viewModel.showFahrenheit) {
                    Text("show-fahrenheit")
                }
                Text("forecast")
                    .font(.custom(
                        currentTheme.fontFamily, fixedSize: 30))
                HStack {
                    ForEach(viewModel.forecastDays, id: \.self) { day in
                        forecastCell(day.hi, day.lo)
                    }
                }
                Spacer()
            } else {
                ResultCardView(viewModel: viewModel)
                    .onTapGesture {
                        viewModel.showDetails.toggle()
                    }
                Spacer()
            }
        }
    }
    
    func detailCell(_ title: LocalizedStringKey, value: String) -> some View {
        VStack {
            Text(title)
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 12))
                .foregroundStyle(.placeholder)
            Text(value)
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    func forecastCell(_ hi: Double, _ lo: Double) -> some View {
        VStack {
            Text(hi.formatted())
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 14))
                .foregroundStyle(.secondary)
            Text(lo.formatted())
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 14))
                .foregroundStyle(.secondary)
        }
        .frame(width: 70)
        .frame(minHeight: 50)
        .background {
            currentTheme.backgroundColor
        }
        .cornerRadius(16)
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
