/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

export 'src/basevenuewolf_sdk_base.dart';

// TODO: Export any libraries intended for clients of this package.
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class BasevenueWolfSDK {

  String baseUrl = 'https://basevenue-wolf.vercel.app';

  Future<String> getUserTokenAddress(String userWalletAddress) async {

    debugPrint("userWalletAddress $userWalletAddress");
    // If your API is served from the same origin as your app, you can use a relative URL.
    final Uri url = Uri.parse(
        "$baseUrl/api/sdk?userWalletAddress=$userWalletAddress");

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
    });
    debugPrint("response.statusCode ${response.statusCode}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse["data"] as String;
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }

  Future<String> getTokenSymbol(String tokenContractAddress,
      {String? rpcUrl}) async {
    // Use the provided rpcUrl or a default value.
    final String _rpcUrl = rpcUrl ?? "https://sepolia.base.org";

    // Create an HTTP client and initialize the Web3 client.
    final httpClient = http.Client();
    final ethClient = Web3Client(_rpcUrl, httpClient);

    // Minimal ERC-20 ABI for the symbol function.
    final String abi = '''
    [
      {
        "constant": true,
        "inputs": [],
        "name": "symbol",
        "outputs": [
          { "name": "", "type": "string" }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      }
    ]
    ''';

    // Create a contract instance using the token's contract address.
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "ERC20"),
      EthereumAddress.fromHex(tokenContractAddress),
    );

    // Get the 'symbol' function from the contract.
    final symbolFunction = contract.function("symbol");

    // Call the 'symbol' function; no parameters are required.
    final result = await ethClient.call(
      contract: contract,
      function: symbolFunction,
      params: [],
    );

    // Close the HTTP client.
    httpClient.close();

    // Return the token symbol.
    return result.first as String;
  }

  Future<BigInt> getTokenTotalSupply(String tokenContractAddress,
      {String? rpcUrl}) async {
    // Use the provided rpcUrl or a default value.
    final String _rpcUrl = rpcUrl ?? "https://sepolia.base.org";

    // Create an HTTP client and initialize the Web3 client.
    final httpClient = http.Client();
    final ethClient = Web3Client(_rpcUrl, httpClient);

    // Minimal ERC-20 ABI for the totalSupply function.
    final String abi = '''
    [
      {
        "constant": true,
        "inputs": [],
        "name": "totalSupply",
        "outputs": [
          { "name": "", "type": "uint256" }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      }
    ]
    ''';

    // Create a contract instance using the token contract address.
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "ERC20"),
      EthereumAddress.fromHex(tokenContractAddress),
    );

    // Get the totalSupply function from the contract.
    final totalSupplyFunction = contract.function("totalSupply");

    // Call the totalSupply function (no parameters needed).
    final result = await ethClient.call(
      contract: contract,
      function: totalSupplyFunction,
      params: [],
    );

    // Close the HTTP client.
    httpClient.close();

    // Return the total supply (as a BigInt).
    return result.first as BigInt;
  }

  Future<String> getTokenName(String tokenContractAddress,
      {String? rpcUrl}) async {
    // Set up the RPC URL; replace YOUR_INFURA_PROJECT_ID with your actual project ID.
    final String _rpcUrl = rpcUrl ?? "https://sepolia.base.org";

    // Create an HTTP client and a Web3 client
    final httpClient = http.Client();
    final ethClient = Web3Client(_rpcUrl, httpClient);

    // Minimal ERC20 ABI for the 'name' function
    // This ABI only includes the function definition needed to get the token name.
    final String abi = '''
    [
      {
        "constant": true,
        "inputs": [],
        "name": "name",
        "outputs": [
          {
            "name": "",
            "type": "string"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      }
    ]
    ''';

    // Create a contract instance using the token's contract address
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "ERC20"),
      EthereumAddress.fromHex(tokenContractAddress),
    );

    // Get the 'name' function from the contract
    final nameFunction = contract.function("name");

    // Call the 'name' function; no parameters are required
    final result = await ethClient.call(
      contract: contract,
      function: nameFunction,
      params: [],
    );

    // Clean up the HTTP client
    httpClient.close();

    // The result is returned as a list; the first element is the token name.
    return result.first as String;
  }

  Future<BigInt> getTokenBalance(String tokenContractAddress,
      String ownerAddress, {
        String? rpcUrl,
      }) async {
    // Set up the RPC URL; replace with your actual endpoint or use a default.
    final String _rpcUrl = rpcUrl ?? "https://sepolia.base.org";

    // Create an HTTP client and a Web3 client.
    final httpClient = http.Client();
    final ethClient = Web3Client(_rpcUrl, httpClient);

    // Minimal ERC20 ABI for the 'balanceOf' function.
    final String abi = '''
    [
      {
        "constant": true,
        "inputs": [
          { "name": "_owner", "type": "address" }
        ],
        "name": "balanceOf",
        "outputs": [
          { "name": "balance", "type": "uint256" }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      }
    ]
    ''';

    // Create a contract instance using the token's contract address.
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "ERC20"),
      EthereumAddress.fromHex(tokenContractAddress),
    );

    // Get the 'balanceOf' function from the contract.
    final balanceOfFunction = contract.function("balanceOf");

    // Call the 'balanceOf' function with the owner's address.
    final result = await ethClient.call(
      contract: contract,
      function: balanceOfFunction,
      params: [EthereumAddress.fromHex(ownerAddress)],
    );

    // Clean up the HTTP client.
    httpClient.close();

    // The result is returned as a list; the first element is the token balance as BigInt.
    return result.first as BigInt;
  }

  String formatTokenBalance(BigInt balance, {int decimals = 18}) {
    // Convert the BigInt to a double.
    double value = double.parse(balance.toString());
    // Calculate the divisor based on the decimals.
    double divisor = math.pow(10, decimals).toDouble();
    // Get the token amount in standard units.
    double tokens = value / divisor;

    // Create a formatter that displays no decimal places and uses commas as thousand separators.
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(tokens);
  }

   String formatTotalSupply(BigInt rawSupply, {int decimals = 18}) {
    print("rawSupply $rawSupply");
    // Convert BigInt to double value based on token decimals.
    double supplyValue = rawSupply / BigInt.from(math.pow(10, decimals));

    // Use NumberFormat to add commas (no decimal places)
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(supplyValue);
  }

}
