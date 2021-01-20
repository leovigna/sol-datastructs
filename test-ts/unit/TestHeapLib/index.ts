import { assert } from 'chai';
import PriorityQueue from 'ts-priority-queue';
import truffleAssert from 'truffle-assertions';

import { randomData } from '../../utils'
import { TestHeapLibUIntContract, TestHeapLibUIntInstance, TestHeapLibUIntName, HeapLibUIntName } from "../../artifacts"
import { configure } from "../../configure"


/** Stats
 * TestHeapLibUInt16B2
 * 1001th (h: 2, max: 14896) insert 71362
 * 1001th (h: 2, max: 14896) remove 181092
 * 10001th (h: 2, max: 14896) insert 76771
 * 10001th (h: 2, max: 14896) remove 132462
 * 20001th (h: 3, max: 446896) insert 100526
 * 20001th (h: 3, max: 446896) remove 203440
 *
 * TestHeapLibUInt16B8
 * 1001th (h: 1, max: 1936) insert 47607
 * 1001th (h: 1, max: 1936) remove 125238
 * 10001th (h: 2, max: 232336) insert 76771
 * 10001th (h: 2, max: 232336) remove 152416
 *
 * TestHeapLibUInt32B8
 * 101th (h: 1, max: 456) insert 47499
 * 101th (h: 1, max: 456) remove 81186
 * 1001th (h: 2, max: 25544) insert 76626
 * 1001th (h: 2, max: 25544) remove 113272
 * 10001th (h: 2, max: 25544) insert 76626
 * 10001th (h: 2, max: 25544) remove 104428
 * 20001th (h: 2, max: 25544) insert 76626
 * 20001th (h: 2, max: 25544) remove 110412
 *
 * TestHeapLibUInt32B16
 * 101th (h: 1, max: 904) insert 47499
 * 101th (h: 1, max: 904) remove 106425
 * 1001th (h: 2, max: 101256) insert 76626
 * 1001th (h: 2, max: 101256) remove 163867
 */

interface HeapLibTest {
  contract: TestHeapLibUIntContract,
  TestHeapLib: TestHeapLibUIntName
  HeapLib: HeapLibUIntName,
  a: 16 | 8 | 4,
  b: 2 | 8 | 16
}

async function equalHeap(heap: TestHeapLibUIntInstance, expected: PriorityQueue<number>) {
  const length = (await heap.length()).toNumber()
  assert.equal(length, expected.length, "heap.length() != expected.length")

  const promiseList = []

  for (let i = 0; i < length; i++) {
    //console.debug(i)
    //hard code gas limit to avoid race condition where gas is insufficient
    promiseList.push(heap.removeRoot({ gas: 1000000 }));
  }

  const txList = await Promise.all(promiseList)
  const gasUsed = txList.map((r) => r.receipt.gasUsed - 20000)
  const total = gasUsed.reduce((acc, v) => acc + v, 0)
  const avg = total / gasUsed.length
  //@ts-ignore
  const roots = txList.map((tx) => { return tx.logs[0].args.val.toNumber() })

  const expectedRoots = []
  for (let i = 0; i < length; i++) {
    expectedRoots.push(expected.dequeue())
  }

  //console.debug(roots)
  //console.debug(expectedRoots)

  assert.deepEqual(roots, expectedRoots, "roots != expectedRoots")
  assert.equal((await heap.length()).toNumber(), 0, "heap.length() != 0")

  return { avg, total }
}

async function heapPush(contract: TestHeapLibUIntInstance, data: number[]) {
  const pushPromiseList = []
  for (let i = 0; i < data.length; i++) {
    pushPromiseList.push(contract.push(data[i]))
  }

  return Promise.all(pushPromiseList)
}

/*
async function heapPushMargin(heap: TestHeapLibUIntInstance) {
  //Marginal worst case cost
  const marginalInsert = await heap.push(0)
  const length = (await heap.length()).toNumber()
  const height = (await heap.height()).toNumber()
  const maxLength = (await heap.maxLength()).toNumber()
  console.debug(`${length}th (h: ${height}, max: ${maxLength}) insert ${marginalInsert.receipt.gasUsed - 20000}`)
  const marginalRemove = await heap.removeRoot()
  console.debug(`${length}th (h: ${height}, max: ${maxLength}) remove ${marginalRemove.receipt.gasUsed - 20000}`)
}
*/

export function testHeapLib(test: HeapLibTest) {
  describe(test.TestHeapLib, function () {
    before(async () => {
      await configure()
    })

    let heap: TestHeapLibUIntInstance

    describe('read', function () {
      //These tests create the heap in the before() stage and then run all read-only tests with this single contract
      describe('Empty', function () {
        before(async () => {
          heap = await test.contract.new()
        })

        it("searchUp(42,0)", async () => {
          const val = 42; const startIdx = 0;
          await truffleAssert.reverts(heap.searchUp(val, startIdx), `${test.HeapLib}.searchUp: idx out of bounds.`);
        })

        it("searchDown(42,0)", async () => {
          const val = 42; const startIdx = 0;
          await truffleAssert.reverts(heap.searchDown(val, [startIdx]), `${test.HeapLib}.searchDown: v not found.`);
        })

        it("search(42,0)", async () => {
          const val = 42; const startIdx = 0;
          await truffleAssert.reverts(heap.search(val, startIdx), `${test.HeapLib}.searchUp: idx out of bounds.`);
        })

        it("searchRoot(42)", async () => {
          const val = 42;
          await truffleAssert.reverts(heap.searchRoot(val), `${test.HeapLib}.searchUp: idx out of bounds.`);
        })
      })

      describe('Single', function () {
        before(async () => {
          heap = await test.contract.new()
          await heapPush(heap, [42])
        })

        it("searchUp(42,0)", async () => {
          const val = 42; const startIdx = 0;
          assert.equal((await heap.searchUp(val, startIdx)).toNumber(), 0, `heap.searchUp(${val},${startIdx})`)
        })

        it("searchDown(42,0)", async () => {
          const val = 42; const startIdx = 0;
          assert.equal((await heap.searchUp(val, startIdx)).toNumber(), 0, `heap.searchDown(${val},${startIdx})`)
        })

        it("search(42,0)", async () => {
          const val = 42; const startIdx = 0;
          assert.equal((await heap.search(val, startIdx)).toNumber(), 0, `heap.search(${val},${startIdx})`)
        })

        it("searchRoot(42)", async () => {
          const val = 42; const startIdx = 0;
          assert.equal((await heap.searchRoot(val)).toNumber(), 0, `heap.searchRoot(${val})`)
        })

        //Out of bounds
        it("searchUp(42,1)", async () => {
          const val = 42; const startIdx = 1;
          await truffleAssert.reverts(heap.searchUp(val, startIdx), `${test.HeapLib}.searchUp: idx out of bounds.`);
        })

        it("searchDown(42,1)", async () => {
          const val = 42; const startIdx = 1;
          await truffleAssert.reverts(heap.searchDown(val, [startIdx]), `${test.HeapLib}.searchDown: v not found.`);
        })

        it("search(42,1)", async () => {
          const val = 42; const startIdx = 1;
          await truffleAssert.reverts(heap.search(val, startIdx), `${test.HeapLib}.searchUp: idx out of bounds.`);
        })
      })

      /**
       * HeapLibUInt16: 1-16
       * HeapLibUInt32: 1-8
       * HeapLibUInt64: 1-4
       */
      describe(`1-${test.a} ascending`, function () {
        /** 1 root, 15 leaves packed in 256bits
         *            1
         *  2 3 4 5 ...
         */
        before(async () => {
          heap = await test.contract.new()
          const data = Array.from(Array(test.a).keys()).map((x) => x + 1)
          await heapPush(heap, data)
        })

        it(`searchUp(${test.a / 2 + 1},${test.a / 2})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a / 2;
          assert.equal((await heap.searchUp(val, startIdx)).toNumber(), test.a / 2, `heap.searchUp(${val},${startIdx})`)
        })

        it(`searchUp(${test.a / 2 + 1},0)`, async () => {
          //This just returns root since 9 is below the root
          const val = test.a / 2 + 1; const startIdx = 0;
          assert.equal((await heap.searchUp(val, startIdx)).toNumber(), 0, `heap.searchUp(${val},${startIdx})`)
        })

        it(`searchDown(${test.a / 2 + 1},${test.a / 2})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a / 2;
          assert.equal((await heap.searchDown(val, [startIdx])).toNumber(), test.a / 2, `heap.searchDown(${val},${startIdx})`)
        })

        it(`searchDown(${test.a / 2 + 1},0)`, async () => {
          const val = test.a / 2 + 1; const startIdx = 0;
          assert.equal((await heap.searchDown(val, [startIdx])).toNumber(), test.a / 2, `heap.searchDown(${val},${startIdx})`)
        })

        it(`searchDown(${test.a / 2 + 1},${test.a / 2 - 1})`, async () => {
          //Fails as starts from wrong leaf
          const val = test.a / 2 + 1; const startIdx = test.a / 2 - 1;
          await truffleAssert.reverts(heap.searchDown(val, [startIdx]), `${test.HeapLib}.searchDown: v not found.`);
        })

        it(`search(${test.a / 2 + 1},${test.a / 2})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a / 2;
          assert.equal((await heap.search(val, startIdx)).toNumber(), test.a / 2, `heap.search(${val},${startIdx})`)
        })

        it(`search(${test.a / 2 + 1},${test.a / 2 - 1})`, async () => {
          //heap[a/2 - 1] = a/2 < a/2+1 -> Searches from there and can't find.
          const val = test.a / 2 + 1; const startIdx = test.a / 2 - 1;
          await truffleAssert.reverts(heap.search(val, startIdx), `${test.HeapLib}.searchDown: v not found.`);
        })

        it(`search(${test.a / 2 + 1},${test.a / 2 + 1})`, async () => {
          //heap[a/2 + 1] = a/2+2 > a/2+1 -> Goes up to root, finds by searching down leaves
          const val = test.a / 2 + 1; const startIdx = test.a / 2 + 1;
          assert.equal((await heap.search(val, startIdx)).toNumber(), test.a / 2, `heap.search(${val},${startIdx})`)
        })

        it(`searchRoot(${test.a / 2 + 1})`, async () => {
          const val = test.a / 2 + 1;
          assert.equal((await heap.searchRoot(val)).toNumber(), test.a / 2, `heap.searchRoot(${val})`)
        })

        it(`searchRoot(x) for x in [1...${test.a}]`, async () => {
          for (let i = 1; i <= test.a; i++) {
            let idx = (await heap.searchRoot(i)).toNumber()
            assert.equal((await heap.get(idx)).toNumber(), i, `heap.get(heap.searchRoot(${i})) = ${i}`)
          }
        })

        //Out of bounds
        it(`searchUp(${test.a / 2 + 1},${test.a})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a;
          await truffleAssert.reverts(heap.searchUp(val, startIdx), `${test.HeapLib}.searchUp: idx out of bounds.`);
        })

        it(`searchDown(${test.a / 2 + 1},${test.a})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a;
          await truffleAssert.reverts(heap.searchDown(val, [startIdx]), `${test.HeapLib}.searchDown: v not found.`);
        })

        it(`search(${test.a / 2 + 1},${test.a})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a;
          await truffleAssert.reverts(heap.search(val, startIdx), `${test.HeapLib}.searchUp: idx out of bounds.`);
        })

      })

      describe(`1-${test.a} descending`, function () {
        /** 1 root, 15 leaves packed in 256bits
         *            1
         *  16 15 14 13 ...
         */
        before(async () => {
          heap = await test.contract.new()
          const data = Array.from(Array(test.a).keys()).sort((a, b) => b - a).map((x) => x + 1)
          await heapPush(heap, data)
        })

        it(`searchUp(${test.a / 2 + 1},${test.a / 2})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a / 2;
          assert.equal((await heap.searchUp(val, startIdx)).toNumber(), test.a / 2, `heap.searchUp(${val},${startIdx})`)
        })

        it(`searchUp(${test.a / 2 + 1},0)`, async () => {
          //This just returns root since a/2 + 1 is below the root
          const val = test.a / 2 + 1; const startIdx = 0;
          assert.equal((await heap.searchUp(val, startIdx)).toNumber(), 0, `heap.searchUp(${val},${startIdx})`)
        })

        it(`searchDown(${test.a / 2 + 1},${test.a / 2})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a / 2;
          assert.equal((await heap.searchDown(val, [startIdx])).toNumber(), test.a / 2, `heap.searchDown(${val},${startIdx})`)
        })

        it(`searchDown(${test.a / 2 + 1},0)`, async () => {
          const val = test.a / 2 + 1; const startIdx = 0;
          assert.equal((await heap.searchDown(val, [startIdx])).toNumber(), test.a / 2, `heap.searchDown(${val},${startIdx})`)
        })

        it(`searchDown(${test.a / 2 + 1},${test.a / 2 - 1})`, async () => {
          //Fails as starts from wrong leaf
          const val = test.a / 2 + 1; const startIdx = test.a / 2 - 1;
          await truffleAssert.reverts(heap.searchDown(val, [startIdx]), `${test.HeapLib}.searchDown: v not found.`);
        })

        it(`search(${test.a / 2 + 1},${test.a / 2})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a / 2;
          assert.equal((await heap.search(val, startIdx)).toNumber(), test.a / 2, `heap.search(${val},${startIdx})`)
        })

        it(`search(${test.a / 2 + 1},${test.a / 2 + 1})`, async () => {
          //heap[a/2+1] = a/2 < a/2+1 -> Searches from there and can't find.
          const val = test.a / 2 + 1; const startIdx = test.a / 2 + 1;
          await truffleAssert.reverts(heap.search(val, startIdx), `${test.HeapLib}.searchDown: v not found.`);
        })

        it(`search(${test.a / 2 + 1},${test.a / 2 - 1})`, async () => {
          //heap[a/2-1] = a/2+2 > a/2+1 -> Goes up to root, finds by searching down leaves
          const val = test.a / 2 + 1; const startIdx = test.a / 2 - 1;
          assert.equal((await heap.search(val, startIdx)).toNumber(), test.a / 2, `heap.search(${val},${startIdx})`)
        })

        it(`searchRoot(${test.a / 2 + 1})`, async () => {
          const val = test.a / 2 + 1;
          assert.equal((await heap.searchRoot(val)).toNumber(), test.a / 2, `heap.searchRoot(${val})`)
        })

        it(`searchRoot(x) for x in [1...${test.a}]`, async () => {
          for (let i = 1; i <= test.a; i++) {
            let idx = (await heap.searchRoot(i)).toNumber()
            assert.equal((await heap.get(idx)).toNumber(), i, `heap.get(heap.searchRoot(${i})) = ${i}`)
          }
        })

        //Out of bounds
        it(`searchUp(${test.a / 2 + 1},${test.a})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a;
          await truffleAssert.reverts(heap.searchUp(val, startIdx), `${test.HeapLib}.searchUp: idx out of bounds.`);
        })

        it(`searchDown(${test.a / 2 + 1},${test.a})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a;
          await truffleAssert.reverts(heap.searchDown(val, [startIdx]), `${test.HeapLib}.searchDown: v not found.`);
        })

        it(`search(${test.a / 2 + 1},${test.a})`, async () => {
          const val = test.a / 2 + 1; const startIdx = test.a;
          await truffleAssert.reverts(heap.search(val, startIdx), `${test.HeapLib}.searchUp: idx out of bounds.`);
        })
      })

      describe('random 100', function () {
        let data: number[]

        before(async () => {
          heap = await test.contract.new()
          data = randomData(100)
          await heapPush(heap, data)
        })

        it("searchRoot(x) for x in [1...100]", async () => {
          //15 seconds
          for (let i of data) {
            let idx = (await heap.searchRoot(i)).toNumber()
            assert.equal((await heap.get(idx)).toNumber(), i, `heap.get(heap.searchRoot(${i})) = ${i}`)
          }
        })
      })
    })

    describe('write', function () {
      //These tests create the heap in the beforeEach() stage since tests write data
      describe('heapTest()', function () {
        beforeEach(async () => {
          heap = await test.contract.new()
        })

        it("push(x) 20", async () => {
          const data = randomData(20)
          const expected: PriorityQueue<number> = new PriorityQueue({ comparator: function (a, b) { return a - b; } });
          const promiseList = []

          for (let d of data) {
            promiseList.push(heap.push(d))
            expected.queue(d)
          }

          const results = (await Promise.all(promiseList)).map((r) => r.receipt.gasUsed - 20000)
          const total = results.reduce((acc, v) => acc + v, 0)
          const avg = total / results.length

          const removeRootGas = await equalHeap(heap, expected)

          console.debug(`${test.TestHeapLib} avg gas push():${avg} removeRoot():${removeRootGas.avg}`)

        })


        /*
        it("push(x) 1000 batched random", async () => {
            await heapTest(heap, 1000, 100, false)
        })

        it("push(x) 20000 batched random", async () => {
            for (let i = 0; i < 2; i++) {
                const data = randomData(10000)
                await heapPushBatch(heap, data, 100)
                await heapPushMargin(heap)
            }
        }).timeout(30000000)
        */

      })
    })
  })
}

