# Deploying CI/CD for Android Mobile Application with Flutter, GitHub Actions, Fastlane, and Google Play

## Target
To establish a CI/CD pipeline using GitHub Actions for our existing Flutter application, supporting the following (automatically) after our preferred trigger (push on branch, create pull request, etc.):

- Setup Fastlane and all configurations related to Fastlane
- Building Android app bundle
- Incrementing Google Play Version Code
- Signing the produced packages with a given Keystore
- Deploying the packages to Google Play alpha/internal/production tracks

## Fastlane Setup for Android

### Installing Fastlane
Fastlane can be installed in multiple ways, but in this project, we will set up Fastlane with Bundler.

### Installing Bundler
It is recommended to use Bundler and a Gemfile to define the Fastlane dependency. This clearly defines the Fastlane version and its dependencies and speeds up execution.

```sh
# Install Bundler
gem install bundler
```

Create a `./Gemfile` in the root directory of your project with the following content:

```ruby
source "https://rubygems.org"
gem "fastlane"
```

Run the following command:

```sh
bundle update
```

Add both `./Gemfile` and `./Gemfile.lock` to version control.

Every time you run Fastlane, use:

```sh
bundle exec fastlane [lane]
```

## Setting Up Fastlane
Navigate to the `/android` directory and run:

```sh
fastlane init
```

Provide the package name of your application and the path for the JSON secret file downloaded from Google Play Console for your service account.

## Setting Up Supply
Supply is a Fastlane tool that uploads app metadata, screenshots, and binaries to Google Play.

### Collecting Google Credentials

1. Open the [Google Play Console](https://play.google.com/console/)
2. Click **Account Details** and note the **Google Cloud Project ID**
3. Enable the **Google Play Developer API**
4. Open **Service Accounts** on Google Cloud
5. Create a new service account with appropriate permissions

## Building Android App Bundle
Build your code in release mode to `build/app/outputs/[apk][appbundle]/release` directory.

## Generating Your Keystore
Generate the keystore for signing the app bundle:

```sh
keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
```

## Signing Your App Bundle
Sign the output app bundle using your keystore:

```sh
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.jks app-release.aab my-key-alias
```

## Manual Upload to Google Play
1. Sign into your **Google Play Console**
2. Navigate to the **Testing** section (internal, alpha, beta, or production)
3. Click **Create Release**
4. Upload your signed app bundle

## Automating Version Configuration
Modify `android/app/build.gradle` to read version details from a `version.properties` file located at `/android/version.properties`.

## Signing the APK Automatically
Instead of hardcoding keystore secrets in `build.gradle`, use a `key.properties` file inside the `/android` directory with the following format:

```ini
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=your-key-alias
storeFile=my-release-key.jks
```

## Fastlane Instead of Manual Deployment
Modify your `/android/fastlane/Fastfile` to include a lane for deployment to your desired track (alpha, beta, or production).

Example lane:

```ruby
define :deploy
  supply(
    track: "alpha",
    json_key: "fastlane-secret.json",
    package_name: "com.yourapp.app"
  )
end
```

Deploy using:

```sh
bundle exec fastlane deploy
```

## Automating with GitHub Actions
Create a workflow file in `.github/workflows/google-play.yml`.

Example steps:

1. **Checkout Code**
   ```yaml
   - name: Checkout code
     uses: actions/checkout@v3
   ```
2. **Set Up Flutter**
   ```yaml
   - name: Setup Flutter
     uses: subosito/flutter-action@v2
   ```
3. **Deploy to Google Play using Fastlane**
   ```yaml
   - name: Deploy
     run: bundle exec fastlane deploy
   ```

## Troubleshooting Guide

- **Ensure you pull the latest changes before pushing a new release.**
- **For GitHub Organizations, add necessary permissions to the workflow YAML file.**

