import Foundation

struct Constants {
    static let clientId = "sephora"
    static let clientSecret = "KcBVru9uDe2kI90gwkHojrP7WshOBGBUQMbC8aRyvx0="
    static let tokenEndpoint = URL(string: "https://stageauth.winkapis.com/realms/wink/protocol/openid-connect/token")!
    static let authEndpoint = URL(string: "https://stageauth.winkapis.com/realms/wink/protocol/openid-connect/auth")!
    static let verifyEndpoint = URL(string: "https://stagelogin-api.winkapis.com/api/ConfidentialClient/verify-client")!
    
    static let allowedDomains = [
        URL(string: authEndpoint.absoluteString)?.host,
        URL(string: tokenEndpoint.absoluteString)?.host,
        "stagelogin.winkapis.com"
    ].compactMap { $0 }
    
    static func getAuthURL(redirectUri: String, state: String) -> URL? {
        var components = URLComponents(string: "https://stageauth.winkapis.com/realms/wink/protocol/openid-connect/auth")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "openid")
        ]
        return components?.url
    }
}
