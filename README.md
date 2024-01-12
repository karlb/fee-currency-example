# Interface for Celo fee currencies

On the Celo blockchain, you can send [CIP-64](https://github.com/celo-org/celo-proposals/blob/master/CIPs/cip-0064.md) transactions that will consume certain ERC20 tokens to pay for gas.

This repository contains:
* The [IFeeCurrency interface](src/IFeeCurrency.sol), which must be implemented by tokens to be used as fee currencies.
* An [example implementation](src/FeeCurrency.sol) of such a token.
* [Tests](test/FeeCurrency.t.sol) to check the main requirements for a valid fee currency.

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```
