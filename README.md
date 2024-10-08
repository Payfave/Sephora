# WINK Authentication iOS App

This iOS application demonstrates the integration of Authentication services between an iOS app and Keycloak, specifically using the WINK authentication service.

## Setup Instructions

To run this project, you need to complete the following steps:

1. Configure the project target signing capabilities for both the extension and the example targets.

2. Check/replace the values of the constants in the `kConstants.swift` file.

   Note: Ensure these credentials are kept secure and not shared publicly.

### Key Features

- OAuth 2.0 authentication flow
- SFSafariViewController integration for login and logout
- Secure token handling
- SSL certificate validation
- User profile fetch and display

## Detailed File Descriptions

### 1. kConstants.swift

This file defines a `Constants` structure containing crucial information for authentication:

- `clientId`: The client identifier for the WINK API.
- `clientSecret`: The client secret for the WINK API.
- `tokenEndpoint`: The URL endpoint for obtaining the access token.

These values are essential for the OAuth 2.0 authentication process.

### 2. ViewController.swift

This file contains the main logic of the application:

1. **Initial User Interface:**

   - Creates a login button with the text "Login with WINK".
   - The button has a custom style with a red semicolon icon.

2. **Login Process:**

   - When the login button is tapped, a request is made to the auth endpoint of keycloak for the configured client.

3. **Authentication Handling:**
   - Intercept navigations.
   - Looks for a specific URL indicating successful authentication.
   - Extracts the authorization token and redirect URI from the URL parameters.

### 3. UserInfoViewController.swift

This file handles the screen displayed after successful authentication and the logout feature.

**User Interface:**

- Displays a user dashboard with labels for the token and profile details.
- Includes a button to validate the token and get user profile, and another to go back to home.
- Button to perform the logout.
