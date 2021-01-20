import { assert } from 'chai';
import Web3 from 'web3';

import { randomData } from '../../utils';
import { TestArrayLibUIntContract, TestArrayLibUIntName, IListUIntInstance } from '../../artifacts';
import { configure } from '../../configure';

interface ArrayLibUIntTest {
    contract: TestArrayLibUIntContract;
    name: TestArrayLibUIntName;
}

async function equalArray(list: IListUIntInstance, expected: string[]) {
    const length = (await list.length()).toNumber();
    assert.equal(length, expected.length, 'list.length() != expected.length');

    const promiseList = [];

    for (let i = 0; i < length; i++) {
        promiseList.push(list.get(i));
    }

    const result = (await Promise.all(promiseList)).map(n => n.toString());
    assert.deepEqual(result, expected, '[...contract.get()] != expected');
}

type WriteOpType = 'PUSH' | 'POP' | 'SET' | 'SWAP';
interface WriteOp {
    type: WriteOpType;
    i: number;
    j?: number;
}
const WriteOpTypes: WriteOpType[] = ['PUSH', 'POP', 'SET', 'SWAP'];

export function testArrayLib(test: ArrayLibUIntTest) {
    describe(test.name, function() {
        let list: IListUIntInstance;
        let BIT_LENGTH: number;
        let MAX_INT: BN;

        before(async () => {
            await configure();

            switch (test.name) {
                case 'TestArrayLibUInt16':
                    BIT_LENGTH = 16;
                    break;
                case 'TestArrayLibUInt32':
                    BIT_LENGTH = 32;
                    break;
                case 'TestArrayLibUInt64':
                    BIT_LENGTH = 64;
                    break;
                case 'TestArrayLibUInt128':
                    BIT_LENGTH = 128;
                    break;
            }

            MAX_INT = Web3.utils
                .toBN('2')
                .pow(Web3.utils.toBN(BIT_LENGTH))
                .sub(Web3.utils.toBN('1'));
        });

        beforeEach(async () => {
            list = await test.contract.new();
        });

        describe('full storage slot', function() {
            let list: IListUIntInstance;
            let initialExpected: string[];
            let initalGasCosts: number[];
            beforeEach(async () => {
                list = await test.contract.new();
                const n = Math.floor(256 / BIT_LENGTH) + 1;
                const expected = Array.from({ length: n }).map((_, idx) =>
                    MAX_INT.sub(Web3.utils.toBN(idx)).toString(),
                );
                initialExpected = expected;
                const promiseList = [];
                for (const i of expected) {
                    promiseList.push(list.push(i));
                }
                initalGasCosts = (await Promise.all(promiseList)).map(r => r.receipt.gasUsed - 20000);
            });

            it('arrayEqual()', async () => {
                const results = initalGasCosts;
                const total = results.reduce((acc, v) => acc + v, 0);
                const avg = total / results.length;
                console.debug(`${test.name} push() full storage slot: ${avg} (avg)`);
                await equalArray(list, initialExpected);
            });

            it('swap()', async () => {
                //Regular swap, items are in separate storage slots
                const n = initialExpected.length;
                const swapTx = await list.swap(0, n - 1);
                assert.equal(
                    (await list.get(0)).toString(),
                    MAX_INT.sub(Web3.utils.toBN(n - 1)).toString(),
                    'Invalid swap result array[0]',
                );
                assert.equal(
                    (await list.get(n - 1)).toString(),
                    MAX_INT.toString(),
                    'Invalid regular swap result array[n-1]',
                );
                console.debug(`${test.name} swap() regular: ${swapTx.receipt.gasUsed - 20000}`);
                //Reset
                await list.swap(0, n - 1);
                //Quick swap, items are in same storage slot
                const swapTx2 = await list.swap(0, n - 2);
                assert.equal(
                    (await list.get(0)).toString(),
                    MAX_INT.sub(Web3.utils.toBN(n - 2)).toString(),
                    'Invalid swap result array[0]',
                );
                assert.equal(
                    (await list.get(n - 2)).toString(),
                    MAX_INT.toString(),
                    'Invalid quick swap result array[n-2]',
                );
                console.debug(`${test.name} swap() quick: ${swapTx2.receipt.gasUsed - 20000}`);
                //Reset
                await list.swap(0, n - 2);
                //Double check array unchanged
                await equalArray(list, initialExpected);
            });

            it('getBatch()', async () => {
                const n = initialExpected.length;
                const idxList = Array.from({ length: n }).map((_, i) => i);
                const promiseList = [];

                for (const i of idxList) {
                    promiseList.push(list.get(i));
                }

                const result1 = (await Promise.all(promiseList)).map(n => n.toString());
                const result2 = (await list.getBatch(idxList)).map(v => v.toString());

                assert.deepEqual(result1, result2, 'get() != getBatch()');
            });

            it('setBatch()', async () => {
                const n = initialExpected.length;
                const idxList = Array.from({ length: n }).map((_, i) => `${i}`);
                const setBatchTx = await list.setBatch(idxList, idxList);

                console.debug(`${test.name} setBatch(): ${setBatchTx.receipt.gasUsed - 20000}`);

                await equalArray(list, idxList);
            });

            it('popBatch()', async () => {
                const n = initialExpected.length;
                initialExpected.pop();
                await list.popBatch(1);
                await equalArray(list, initialExpected);

                for (let i = 0; i < Math.floor(n / 2); i++) {
                    initialExpected.pop();
                }

                await list.popBatch(Math.floor(n / 2));
                await equalArray(list, initialExpected);
            });
        });

        it('pushBatch()', async () => {
            const n = Math.floor(256 / BIT_LENGTH) + 1;
            const expected = Array.from({ length: n }).map((_, idx) => MAX_INT.sub(Web3.utils.toBN(idx)).toString());
            const pushBatchTx = await list.pushBatch(expected);
            const total = pushBatchTx.receipt.gasUsed - 20000;
            console.debug(`${test.name} pushBatch() full storage slot: ${total} gas`);

            await equalArray(list, expected);
        });

        describe('fuzzing', function() {
            it('push() 100x', async () => {
                const expected = randomData(100).map(x => `${x}`);
                const promiseList = [];
                for (const i of expected) {
                    promiseList.push(list.push(i));
                }

                const results = (await Promise.all(promiseList)).map(r => r.receipt.gasUsed - 20000);
                const total = results.reduce((acc, v) => acc + v, 0);
                const avg = total / results.length;
                console.debug(`${test.name} push() 100x: ${avg} (avg)`);

                await equalArray(list, expected);
            });

            it('push()/set()/swap()/pop() 100x', async () => {
                const expected: number[] = [];
                const promiseList = [];

                let length = 0; //bypass need to call length()
                for (let i = 0; i < 100; i++) {
                    const writeType = WriteOpTypes[Math.floor(Math.random() * WriteOpTypes.length)];
                    const writeIdx = length > 0 ? Math.floor((Math.random() * 65536) % length) : 0;
                    let writeVal = Math.floor(Math.random() * 65536);
                    switch (writeType) {
                        case 'PUSH':
                            promiseList.push(list.push(writeVal));
                            expected.push(writeVal);
                            length++;
                            break;
                        case 'SET':
                            if (length < 1) break;
                            promiseList.push(list.set(writeIdx, writeVal));
                            expected[writeIdx] = writeVal;
                            break;
                        case 'SWAP':
                            if (length < 2) break;
                            writeVal = writeVal % length;
                            promiseList.push(list.swap(writeIdx, writeVal));
                            const t = expected[writeIdx];
                            expected[writeIdx] = expected[writeVal];
                            expected[writeVal] = t;
                            break;
                        case 'POP':
                            if (length < 1) break;
                            promiseList.push(list.pop());
                            expected.pop();
                            length--;
                            break;
                    }
                }

                const results = (await Promise.all(promiseList)).map(r => r.receipt.gasUsed - 20000);
                const total = results.reduce((acc, v) => acc + v, 0);
                const avg = total / results.length;
                console.debug(`${test.name} random ops 100x: ${avg} (avg)`);

                const expectedString = expected.map(x => `${x}`);
                await equalArray(list, expectedString);
            });
        });
    });
}
