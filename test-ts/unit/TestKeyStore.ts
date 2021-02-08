import { assert } from 'chai';
import Web3 from 'web3';

import { KeyStoreInstance } from '../../types/truffle-contracts';
import { KeyStore } from '../artifacts';
import { configure } from '../configure';

describe('KeyStore', function () {
    let web3: Web3
    let accounts: string[]
    let storage: KeyStoreInstance

    before(async () => {
        const config = await configure();
        web3 = config.ganache.web3
        accounts = config.accounts
    });

    beforeEach(async () => {
        storage = await KeyStore.new()
    });

    it('getUInt256(), setUInt256()', async () => {
        const slot = Web3.utils.keccak256('KeyStore.uint256')
        assert.equal((await storage.getUInt256(slot)).toString(), '0', 'getUInt256');
        await storage.setUInt256(slot, '1')
        assert.equal((await storage.getUInt256(slot)).toString(), '1', 'getUInt256');
    });

    it('getAddress(), setAddress()', async () => {
        const slot = Web3.utils.keccak256('KeyStore.address')
        assert.equal((await storage.getAddress(slot)).toString(), '0x0000000000000000000000000000000000000000', 'getAddress');
        await storage.setAddress(slot, accounts[0])
        assert.equal((await storage.getAddress(slot)).toString(), accounts[0], 'getAddress');
    });

    it('getUInt256Array(), pushUInt256Array()', async () => {
        const slot = Web3.utils.keccak256('KeyStore.uint256[]')

        await storage.pushUInt256Array(slot, '1')
        assert.equal((await storage.getUInt256Array(slot, 0)).toString(), '1', 'getUInt256Array');
    });

    it('getUInt256Array(), pushUInt256Array()', async () => {
        const slot = Web3.utils.keccak256('KeyStore.mapping(uint256,uint256)')
        const key = 42
        assert.equal((await storage.getUInt256Mapping(slot, key)).toString(), '0', 'getUInt256Mapping');
        await storage.setUInt256Mapping(slot, key, '1')
        assert.equal((await storage.getUInt256Mapping(slot, key)).toString(), '1', 'getUInt256Mapping');
    });
});