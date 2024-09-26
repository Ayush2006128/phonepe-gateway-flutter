PhonePe Payment Gateway Demo 
============================

This Flutter project demonstrates the integration of the PhonePe payment gateway for processing payments within your mobile application.

Getting Started
---------------

1\. \*\*Prerequisites:\*\*

*   Flutter development environment set up (\[https://flutter.dev/docs/get-started/install\](https://flutter.dev/docs/get-started/install))
*   A PhonePe merchant account with valid API credentials (contact PhonePe for details)

2\. \*\*Installation:\*\*

1.  Clone this repository: \`git clone https://your-repo-url.git\`
2.  Navigate to the project directory: \`cd phonepe\_payment\_demo\`
3.  Install dependencies: \`flutter pub get\`

3\. \*\*Configuration:\*\*

Open \`lib/main.dart\` and replace the placeholder values with your obtained PhonePe credentials:

*   \`environment\` (e.g., \`ENVIRONMENT.TEST\` for testing)
*   \`appId\`
*   \`merchantId\`
*   (Optional) \`enableLogging\` (set to \`true\` for debugging)

Demo Usage
----------

1\. \*\*Run the App:\*\*

From the project directory, execute: \`flutter run\`

2\. \*\*Payment Flow:\*\*

*   The app presents a button to initiate a payment.
*   Clicking the button triggers the transaction process using the PhonePe SDK.
*   Upon successful payment, the PhonePe app launches on the user's device for authorization.
*   The outcome (success or failure) is displayed within the app.

Important Notes
---------------

*   Replace placeholder values in \`lib/main.dart\` with your valid PhonePe credentials.
*   This demo is intended for illustrative purposes only.
*   Refer to the official PhonePe documentation for detailed integration instructions: \[https://developer.phonepe.com/\](https://developer.phonepe.com/)