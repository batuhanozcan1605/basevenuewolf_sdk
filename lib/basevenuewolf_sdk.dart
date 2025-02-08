/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

export 'src/basevenuewolf_sdk_base.dart';

// TODO: Export any libraries intended for clients of this package.
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class BasevenueWolfSDK {
  final String _apiKey;

  BasevenueWolfSDK()
      : _apiKey = _generateDummyApiKey();

  String baseUrl = 'https://basevenuewolf.com/api';

  // Dummy API key generator for the POC
  static String _generateDummyApiKey() {
    final random = Random();
    return 'bvw-${random.nextInt(1000000)}';
  }

  Future<String> getTokenName(String tokenContractAddress, {String? rpcUrl}) async {
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

  Future<BigInt> getTokenBalance(
      String tokenContractAddress,
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

  // Example method to get a user's main token balance
  Future<double> getUsersMainTokenBalance(String userId) async {
    final uri = Uri.parse('$baseUrl/getBalance?userId=$userId&apiKey=$_apiKey');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // For the POC, assume the response body is a number in string format
      return double.tryParse(response.body) ?? 0.0;
    } else {
      throw Exception('Error fetching token balance');
    }
  }

  // Example method to get the main token address
  Future<String> getMainTokenAddress() async {
    final uri = Uri.parse('$baseUrl/getMainTokenAddress?apiKey=$_apiKey');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error fetching token address');
    }
  }

  String getDummyMainTokenAddress() {
    print("SDK has worked.");
    return "0x123456789";
  }
}
