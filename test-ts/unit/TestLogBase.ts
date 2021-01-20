import assert from 'assert';
import Web3 from 'web3';

import { TestLogBaseNInstance } from '../../types/truffle-contracts';
import { TestLogBaseN } from '../artifacts';
import { configure } from '../configure';

async function testLogBaseN(contract: TestLogBaseNInstance, n: number) {
    const overflowN = Math.ceil(Math.log2(n)); // eg. 2 we test up to i < 256, 4 we test up to i < 128, 5 we test up to i < 64

    const powPromiseList = [];
    const powAddPromiseList = [];
    const powSubPromiseList = [];
    for (let i = 0; i < 256 / overflowN; i++) {
        const powN = Web3.utils.toBN(n).pow(Web3.utils.toBN(i));
        powPromiseList.push(contract.logbaseN(n, powN));
        powAddPromiseList.push(contract.logbaseN(n, powN.add(Web3.utils.toBN(1))));
        powSubPromiseList.push(contract.logbaseN(n, powN.sub(Web3.utils.toBN(1))));
    }

    const powResults = await Promise.all(powPromiseList);
    const powAddResults = await Promise.all(powAddPromiseList);
    const powSubResults = await Promise.all(powSubPromiseList);
    for (let i = 0; i < 256 / overflowN; i++) {
        assert.equal(powResults[i][0].toString(), `${i}`, `logbaseN(${n}^${i}) != ${i}`);
        if (!(n == 2 && i == 0)) {
            //Handle 2^0 + 1 exception
            assert.equal(powAddResults[i][0].toString(), `${i}`, `logbaseN(${n}^${i} + 1) != ${i}`);
        }

        if (i != 0) {
            assert.equal(powSubResults[i][0].toString(), `${i - 1}`, `logbaseN(${n}^${i} - 1) != ${i - 1}`);
        }
    }
}

describe('LogBase2', function() {
    before(async () => {
        await configure();
    });

    for (let i = 2; i <= 32; i++) {
        it(`logbaseN(${i}, x)`, async () => {
            const benchmark = await TestLogBaseN.new();
            await testLogBaseN(benchmark, i);
        });
    }
});
