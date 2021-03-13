// SPDX-License-Identifier: MIT

// solhint-disable-next-line compiler-version
pragma solidity >=0.4.24 <0.8.0;

import '../Storage/KeyStoreLib.sol';

//WARNING: READ BELOW to understand differences with original contract
/** Modified from @openzeppelin/contracts/proxy/Initializable.sol
 * Contracts that inherit from a parent class often can't also
 * be made Initializable because of conflicts with parent contract's
 * storage layer. The solution until now was to make the parent contract
 * Initializable but this cannot always be done (eg. using a library such as OpenGSN).
 *
 * This version of the Initializable contract uses KeyStoreLib to store the
 * variables at InitializableKeyStored._initialized and
 * InitializableKeyStored._initializing.
 */

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 */
abstract contract InitializableKeyStored {
    using KeyStoreLib for bytes32;

    /**
     * @dev Indicates that the contract has been initialized.
     */
    bytes32 private constant _initializedSlot = keccak256('InitializableKeyStored._initialized');

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bytes32 private constant _initializingSlot = keccak256('InitializableKeyStored._initializing');

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        bool _initialized = _initializedSlot.getBool();
        bool _initializing = _initializingSlot.getBool();

        require(_initializing || _isConstructor() || !_initialized, 'Initializable: contract is already initialized');

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function _isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            cs := extcodesize(self)
        }
        return cs == 0;
    }
}
