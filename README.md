# BaseVenueWolf SDK

A Dart SDK library that provides functionality for BaseVenueWolf integration.

## Features

- Simple and easy-to-use API for interacting with BaseVenueWolf
- ERC20 token information retrieval
- Token balance and supply formatting
- Built with Dart 3.6.1
- Full Flutter compatibility
- Web3 integration capabilities

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  basevenuewolf_sdk: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Usage

```dart
import 'package:basevenuewolf_sdk/basevenuewolf_sdk.dart';

void main() async {
  final sdk = BasevenueWolfSDK();
  
  // Get user token address
  String tokenAddress = await sdk.getUserTokenAddress('0x123...abc');
  
  // Get token information
  String symbol = await sdk.getTokenSymbol(tokenAddress);
  String name = await sdk.getTokenName(tokenAddress);
  BigInt totalSupply = await sdk.getTokenTotalSupply(tokenAddress);
  
  // Get token balance for an address
  BigInt balance = await sdk.getTokenBalance(
    tokenAddress,
    '0x456...def'
  );
  
  // Format token amounts
  String formattedBalance = sdk.formatTokenBalance(balance);
  String formattedSupply = sdk.formatTotalSupply(totalSupply);
}
```

## API Reference

### getUserTokenAddress
```dart
Future<String> getUserTokenAddress(String userWalletAddress)
```
Retrieves the token address associated with a user's wallet address.

### getTokenSymbol
```dart
Future<String> getTokenSymbol(String tokenContractAddress, {String? rpcUrl})
```
Gets the symbol of an ERC20 token (e.g., "WOLF").

### getTokenName
```dart
Future<String> getTokenName(String tokenContractAddress, {String? rpcUrl})
```
Gets the full name of an ERC20 token.

### getTokenTotalSupply
```dart
Future<BigInt> getTokenTotalSupply(String tokenContractAddress, {String? rpcUrl})
```
Retrieves the total supply of an ERC20 token.

### getTokenBalance
```dart
Future<BigInt> getTokenBalance(
  String tokenContractAddress,
  String ownerAddress,
  {String? rpcUrl}
)
```
Gets the token balance for a specific address.

### formatTokenBalance
```dart
String formatTokenBalance(BigInt balance, {int decimals = 18})
```
Formats a token balance with proper decimal places and thousand separators.

### formatTotalSupply
```dart
String formatTotalSupply(BigInt rawSupply, {int decimals = 18})
```
Formats the total supply with proper decimal places and thousand separators.

## Dependencies

The SDK uses the following dependencies:
- http: ^1.3.0 - For making HTTP requests
- web3dart: ^2.7.1 - For Web3 functionality
- intl: ^0.20.2 - For internationalization
- flutter/foundation - For debug printing functionality

## Development Dependencies

- lints: ^5.0.0 - For code analysis
- test: ^1.24.0 - For unit testing

## Requirements

- Dart SDK: ^3.6.1

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request


## Support

For support, please open an issue in the GitHub repository or contact the maintainers.
