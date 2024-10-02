import UIKit

class UserInfoViewController: UIViewController {
    var toHomeButton: UIButton!
    var verifyButton: UIButton!
    var accessToken: String?
    private var responseLabel = UILabel()
    private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        let tokenLabel = UILabel()
        tokenLabel.textAlignment = .center
        tokenLabel.numberOfLines = 0
        tokenLabel.textColor = .black
        tokenLabel.translatesAutoresizingMaskIntoConstraints = false
        if let token = accessToken {
            let shortToken = token.prefix(5) + "..." + token.suffix(5)
            tokenLabel.text = "Access Token: \(shortToken)"
        }
        view.addSubview(tokenLabel)

        toHomeButton = UIButton(type: .custom)
        toHomeButton.setTitle("Home", for: .normal)
        toHomeButton.setTitleColor(.white, for: .normal)
        toHomeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        toHomeButton.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        toHomeButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        toHomeButton.layer.cornerRadius = 5
        toHomeButton.clipsToBounds = true
        toHomeButton.translatesAutoresizingMaskIntoConstraints = false
        toHomeButton.addTarget(self, action: #selector(toHomeAction), for: .touchUpInside)
        view.addSubview(toHomeButton)
        
        verifyButton = UIButton(type: .custom)
        verifyButton.setTitle("Validate Token", for: .normal)
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        verifyButton.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        verifyButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        verifyButton.layer.cornerRadius = 5
        verifyButton.clipsToBounds = true
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        verifyButton.addTarget(self, action: #selector(verifyClientAction), for: .touchUpInside)
        view.addSubview(verifyButton)
        
        responseLabel.numberOfLines = 0
        responseLabel.textColor = .black
        responseLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(responseLabel)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)

        NSLayoutConstraint.activate([
            tokenLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tokenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tokenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tokenLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            verifyButton.topAnchor.constraint(equalTo: tokenLabel.bottomAnchor, constant: 20),
            verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            responseLabel.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20),
            responseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            responseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.topAnchor.constraint(equalTo: responseLabel.bottomAnchor, constant: 20),

            toHomeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toHomeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    @objc private func toHomeAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func verifyClientAction() {
        guard let token = accessToken else { return }
        spinner.startAnimating()
        verifyClient(accessToken: token)
    }

    private func verifyClient(accessToken: String) {
        let url = Constants.verifyEndpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "ClientId": Constants.clientId,
            "AccessToken": accessToken,
            "ClientSecret": Constants.clientSecret
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    self?.responseLabel.text = "Response: \(responseString)"
                } else if let error = error {
                    self?.responseLabel.text = "Failed to verify: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
