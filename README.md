# iOS Akakce Case Study App

An application that displays products from the FakeStoreAPI. This project demonstrates clean architecture principles, and practices.

## Features

- Browse products in horizontal carousel and vertical grid layouts
- View detailed product information including images, descriptions, and ratings
- Responsive UI adapts to different device sizes
- Clean network layer with Combine framework
- Error handling and loading states

## Screenshots

(Screenshots will be added here)

## Architecture

This project follows MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures like `Product`
- **Views**: UIKit components (`MainViewController`, `DetailViewController`, custom cells)
- **ViewModels**: Business logic components (`MainViewModel`, `DetailViewModel`)

### Key Components

- **Network Layer**: Clean architecture with protocols and Combine publishers
- **UI Components**: Custom-built collection view cells with auto-layout
- **Error Handling**: Robust error handling with custom error types

## Technologies Used

- **Swift**: Primary programming language
- **UIKit**: UI framework
- **Combine**: Reactive programming framework for handling asynchronous events
- **Kingfisher**: Image loading and caching library
- **FakeStoreAPI**: RESTful API service for product data

## API Integration

This app uses the [FakeStoreAPI](https://fakestoreapi.com/) to retrieve product data. The API provides endpoints for:

- Fetching all products
- Fetching product details
- Fetching products by category

## Requirements

- iOS 14.0+
- Xcode 14.0+
- Swift 5.0+

## Setup and Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/ihsanakbay/ios-akakce-cs.git
   ```

2. Navigate to the project directory:
   ```bash
   cd ios-shopping-app
   ```

3. Create a `Config.plist` file with your API configuration:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>API_KEY</key>
       <string>your_api_key_if_needed</string>
       <key>API_HOST</key>
       <string>https://fakestoreapi.com</string>
   </dict>
   </plist>
   ```

4. Open the `.xcodeproj` file in Xcode

5. Build and run the application
