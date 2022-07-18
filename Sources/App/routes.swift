import Vapor

func routes(_ app: Application) throws {
    app.get("ping") { req -> Response in
        let response: Response = .init(
            status: .ok,
            body: "<html><h1>PONG</h1></html>"
        )

        response.headers.contentType = .html

        return response
    }

    app.get("health") { req -> String in
        let result = ["this-is-key": "HELATH"]

        let data = try? JSONSerialization.data(
            withJSONObject: result,
            options: .prettyPrinted
        )

        if let data = data {
            let jsonString = String(data: data, encoding: .utf8)

            return jsonString ?? "ooopss..."
        } else {
            return "Error"
        }
    }

    app.get { req -> Response in
        let apiKey = "a6311858fb35df63b55216bae4aa952a"

        let weatherResponse = try await req.client.get("https://api.openweathermap.org/data/2.5/weather?q=London&appid=\(apiKey)")

        let londonWeather = try weatherResponse.content.decode(Welcome.self)

        let result = "<html><h1>City: \(londonWeather.name)</h1><br><h1>Temp: \(londonWeather.main.temp)</h1></html>"

        let response: Response = .init(
            status: .ok,
            body: .init(string: result)
        )

        response.headers.contentType = .html

        return response
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
