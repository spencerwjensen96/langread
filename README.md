<p align="center" width="100%">
    <img src="ios/Runner/Assets.xcassets/AppIcon.appiconset/72.png?raw=true">
</p>

# LangRead

LangRead is a Flutter application designed to help users improve their language reading skills through interactive exercises and engaging content.

## Getting Started

Follow these instructions to get up and running on your local machine.

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)

### Installation

1. **Clone the repository:**

    ```sh
    git clone https://github.com/yourusername/LangRead.git
    cd LangRead
    ```

2. **Get the Flutter packages:**

    ```sh
    flutter pub get
    ```

3. **Setup environment**

    Change the [.env.example] file to [.env] and fill in the missing settings with correct API keys, ids, and urls. 

### Running the App

1. **Start the [Pocketbase](https://pocketbase.io/docs) backend** 
    ```sh
    cd backend
    ./pocketbase serve
    ```
    This should run the pocketbase instance on localhost:8090

    You should go to the admin dashboard at http://localhost:8090/_/. On the first start up, you should be prompted to set up the admin email and password.

2. **Connect a device or start an emulator.**

    If you are running iOS devices, you may need to open the project in [ios/Runner] with XCode and sign the project with a Team. This is found under the tab '_Signing and Capabilities_'

3. **Run the app:**

    ```sh
    flutter run
    ```

