# iOS Akakçe Case Study App

An application that displays products from the FakeStoreAPI. This project demonstrates clean architecture principles, and practices.

## Features

- Browse products in horizontal carousel and vertical grid layouts
- View detailed product information including images, descriptions, and ratings
- Responsive UI adapts to different device sizes
- Clean network layer with Combine framework
- Error handling and loading states

## Screenshots

![SS](https://github.com/user-attachments/assets/b6554dbe-9d48-42a9-857d-9796d56c7980)


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
