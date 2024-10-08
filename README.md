# DegenLend Protocol


The **DegenLend Protocol** is a decentralized finance (DeFi) protocol built on the SX Network. It allows users to **supply** assets (Ether or ERC-20 tokens) to earn interest or **borrow** assets by using their supplied assets as collateral. The protocol achieves this by using **cToken** contracts, which represent claims to supplied assets and generate interest based on the algorithmically set interest rates. Users can interact with these contracts to manage their loans and collateral. This system is largely inspired by Compound V2.

## Core Features:
- **Supply Assets**: Earn interest on deposited assets by receiving cTokens that represent your balance in the protocol.
- **Borrow Assets**: Use supplied assets as collateral to borrow other supported assets.
- **Interest Rate Modeling**: Interest rates are automatically adjusted by the protocol based on supply and demand through the **JumpRateModelV2**.

---

## Contract Addresses

Here are the key contracts and addresses that make up the DegenLend Protocol. Each contract serves a specific role in managing the supply, borrowing, and rate calculations:

| Contract Type | Name/Address | Notes |
|---------------|--------------|-------|
| **Unitroller** | `0xF1c01bCe4802935Df07a452dae85F88D9f197948` | Proxy contract controlling access to the Comptroller. |
| **Comptroller (Old)** | `0x8D1230e6Ae4C1Bc573697D93103349C3FDefC944` | The initial implementation of the protocol's logic. |
| **Comptroller (2nd)** | `0xF490B8E1cC2AE794DA3D5AF36B7b2610883D7733` | Updated implementation. |
| **degenWSX#CErc20Immutable (Deprecated)** | `0x5cB7786A478eEc37Da5F6EA2e946cD860E784743` | Previous market implementation for WSX token. |
| **degenUSDC#CErc20Immutable (Deprecated)** | `0xC863E82CD46296F1F81C63cDEB3708505B5b0d97` | Previous market implementation for USDC token. |
| **SimplePriceOracle (Deprecated)** | `0x6ca684b4773aF95AB5AE8d0aB7bA078237536DDF` | Old price oracle implementation. |
| **JumpRateModelV2** | `0xe5ADAbf78627cE464FaceE2970D0b71c0a525038` | Interest rate model used by the protocol. |
| **SimplePriceOracle (Final)** | `0x97F1Ffc1139e742c1A5A4B80847687C736752988` | Latest price oracle used in the system. |

### Token Addresses:
- **USDC**: `0x5147891461a7C81075950f8eE6384e019e39ab98`
- **Wrapped SX**: `0x2D4e10Ee64CCF407C7F765B363348f7F62D2E06e`
- **degenUSDC**: [Address Missing]
- **degenWSX**: [Address Missing]

---

## Security Notes

1. **Hundred Finance Exploit (Ref: [Compound Discussion](https://www.comp.xyz/t/hundred-finance-exploit-and-compound-v2/4266))**: This exploit is related to opening markets with a vulnerable collateral factor, making the protocol open to attack.
   
2. **Solidity Security Lesson - Initial Deposit Exploit**: 
   - When initializing a new market, set the **collateral factor** to zero and mint/burn cTokens to ensure a non-zero total supply before adjusting the collateral factor to the desired value. This ensures enhanced security against potential exploits.

---

## Current Implementations (SX Testnet)

- **Comptroller**: `0x937C076C8D9F85291F5cd22E95b1212C0138A609`
- **Unitroller**: `0xB078459124e55Eb9F2937c86c0Ec893ff4FF082b`
- **Simple Price Oracle**: ``
- **SX Interest Rate Model**: `0x353e7839870604Edf9D766bEFb7929c95c215e00`
- **USDC Interest Rate Model**: `0xeE1bFEE55C42048735c04A9bE7133EB62417F131`
- **Degen USDC**: `0xc3eAff959EB22aea6581D7bf52d4d44BdbbDCcD1`
- **Degen Wrapped SX**: `0xf547a2FE994E2207d4d7F13e69B0b2C0aC24cc2f`

### SX Network Testnet Assets:
- **USDC**: `0x5147891461a7C81075950f8eE6384e019e39ab98`
- **Wrapped SX**: `0x2D4e10Ee64CCF407C7F765B363348f7F62D2E06e`

---

### To-Do:

1. **Update Missing Token Addresses**:
   - `degenUSDC`: [Address Required]
   - `degenWSX`: [Address Required]

2. **Integrate Improvements from Security Audits**:
   - Ensure all improvements from the audit are integrated into the current contract versions.

