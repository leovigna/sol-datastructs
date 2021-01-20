import { assert } from 'chai';

import { TestTreeLib } from '../artifacts';
import { TestTreeLibInstance } from '../../types/truffle-contracts';
import { configure } from '../configure';

interface TreeNode {
    i: number; //idx
    c: number[]; //children
    p: number; //parent
    x: number; //x pack
    y: number; //yth node in pack
}

interface TreeStat {
    a: number; //a parameter
    b: number; //b parameter
    length: number;
    height: number;
    maxLength: number;
}

const treeStats: TreeStat[] = [
    { a: 2, b: 2, length: 0, height: 0, maxLength: 2 },
    { a: 2, b: 2, length: 1, height: 0, maxLength: 2 },
    { a: 2, b: 2, length: 2, height: 1, maxLength: 6 },
    { a: 2, b: 2, length: 5, height: 1, maxLength: 6 },
    { a: 2, b: 2, length: 6, height: 2, maxLength: 14 },
    { a: 2, b: 2, length: 13, height: 2, maxLength: 14 },
    { a: 3, b: 2, length: 0, height: 0, maxLength: 3 },
    { a: 3, b: 2, length: 2, height: 0, maxLength: 3 },
    { a: 3, b: 2, length: 3, height: 1, maxLength: 15 },
    { a: 3, b: 2, length: 14, height: 1, maxLength: 15 },
    { a: 4, b: 2, length: 0, height: 0, maxLength: 4 },
    { a: 4, b: 2, length: 3, height: 0, maxLength: 4 },
    { a: 4, b: 2, length: 4, height: 1, maxLength: 28 },
    { a: 4, b: 2, length: 27, height: 1, maxLength: 28 },
];

//Sketch these out to test
const tree22: TreeNode[] = [
    { i: 0, x: 0, y: 0, p: 0, c: [1] },
    { i: 1, x: 0, y: 1, p: 0, c: [2, 4] },
    { i: 2, x: 1, y: 0, p: 1, c: [3] },
    { i: 3, x: 1, y: 1, p: 2, c: [6, 8] },
    { i: 4, x: 2, y: 0, p: 1, c: [5] },
    { i: 5, x: 2, y: 1, p: 4, c: [10, 12] },
    { i: 6, x: 3, y: 0, p: 3, c: [7] },
    { i: 8, x: 4, y: 0, p: 3, c: [9] },
    { i: 10, x: 5, y: 0, p: 5, c: [11] },
    { i: 12, x: 6, y: 0, p: 5, c: [13] },
];

const tree32: TreeNode[] = [
    { i: 0, x: 0, y: 0, p: 0, c: [1, 2] },
    { i: 1, x: 0, y: 1, p: 0, c: [3, 6] },
    { i: 2, x: 0, y: 2, p: 0, c: [9, 12] },
    { i: 3, x: 1, y: 0, p: 1, c: [4, 5] },
    { i: 4, x: 1, y: 1, p: 3, c: [15, 18] },
    { i: 5, x: 1, y: 2, p: 3, c: [21, 24] },
    { i: 6, x: 2, y: 0, p: 1, c: [7, 8] },
    { i: 7, x: 2, y: 1, p: 6, c: [27, 30] },
    { i: 8, x: 2, y: 2, p: 6, c: [33, 36] },
    { i: 9, x: 3, y: 0, p: 2, c: [10, 11] },
    { i: 10, x: 3, y: 1, p: 9, c: [39, 42] },
    { i: 11, x: 3, y: 2, p: 9, c: [45, 48] },
    { i: 12, x: 4, y: 0, p: 2, c: [13, 14] },
    { i: 13, x: 4, y: 1, p: 12, c: [51, 54] },
    { i: 14, x: 4, y: 2, p: 12, c: [57, 60] },
    { i: 15, x: 5, y: 0, p: 4, c: [16, 17] },
    { i: 16, x: 5, y: 1, p: 15, c: [63, 66] },
    { i: 17, x: 5, y: 2, p: 15, c: [69, 72] },
    { i: 18, x: 6, y: 0, p: 4, c: [19, 20] },
    { i: 19, x: 6, y: 1, p: 18, c: [75, 78] },
    { i: 20, x: 6, y: 2, p: 18, c: [81, 84] },
];

const tree42: TreeNode[] = [
    { i: 0, x: 0, y: 0, p: 0, c: [1, 2, 3] },
    { i: 1, x: 0, y: 1, p: 0, c: [4, 8] },
    { i: 2, x: 0, y: 2, p: 0, c: [12, 16] },
    { i: 3, x: 0, y: 3, p: 0, c: [20, 24] },
    { i: 4, x: 1, y: 0, p: 1, c: [5, 6, 7] },
    { i: 5, x: 1, y: 1, p: 4, c: [28, 32] },
    { i: 6, x: 1, y: 2, p: 4, c: [36, 40] },
    { i: 7, x: 1, y: 3, p: 4, c: [44, 48] },
    { i: 8, x: 2, y: 0, p: 1, c: [9, 10, 11] },
    { i: 9, x: 2, y: 1, p: 8, c: [52, 56] },
    { i: 10, x: 2, y: 2, p: 8, c: [60, 64] },
    { i: 11, x: 2, y: 3, p: 8, c: [68, 72] },
    { i: 12, x: 3, y: 0, p: 2, c: [13, 14, 15] },
    { i: 13, x: 3, y: 1, p: 12, c: [76, 80] },
    { i: 14, x: 3, y: 2, p: 12, c: [84, 88] },
    { i: 15, x: 3, y: 3, p: 12, c: [92, 96] },
    { i: 16, x: 4, y: 0, p: 2, c: [17, 18, 19] },
    { i: 17, x: 4, y: 1, p: 16, c: [100, 104] },
    { i: 18, x: 4, y: 2, p: 16, c: [108, 112] },
    { i: 19, x: 4, y: 3, p: 16, c: [116, 120] },
    { i: 20, x: 5, y: 0, p: 3, c: [21, 22, 23] },
    { i: 24, x: 6, y: 0, p: 3, c: [25, 26, 27] },
];

const tree54 = [
    { i: 0, x: 0, y: 0, p: 0, c: [1, 2, 3, 4] },
    { i: 1, x: 0, y: 1, p: 0, c: [5, 10, 15, 20] },
    { i: 2, x: 0, y: 2, p: 0, c: [25, 30, 35, 40] },
    { i: 3, x: 0, y: 3, p: 0, c: [45, 50, 55, 60] },
    { i: 4, x: 0, y: 4, p: 0, c: [65, 70, 75, 80] },
    { i: 5, x: 1, y: 0, p: 1, c: [6, 7, 8, 9] },
    { i: 6, x: 1, y: 1, p: 5, c: [85, 90, 95, 100] },
    { i: 7, x: 1, y: 2, p: 5, c: [105, 110, 115, 120] },
    { i: 8, x: 1, y: 3, p: 5, c: [125, 130, 135, 140] },
    { i: 9, x: 1, y: 4, p: 5, c: [145, 150, 155, 160] },
    { i: 10, x: 2, y: 0, p: 1, c: [11, 12, 13, 14] },
];

async function treeEqual(a: number, b: number, tree: TestTreeLibInstance, expected: TreeNode[]) {
    //Parent, Leaves, XY
    const parentPromiseList = expected.map(v => tree.parentIdx(a, b, v.i));
    const leavesPromiseList = expected.map(v => tree.leavesIdx(a, b, v.i));
    const xyPromiseList = expected.map(v => tree.getIdx(a, v.i));

    const parentResults = await Promise.all(parentPromiseList);
    parentResults.forEach((v, i) => assert.equal(v.toNumber(), expected[i].p, 'Error: tree.parent()'));

    const leavesResults = await Promise.all(leavesPromiseList);
    leavesResults.forEach((v, i) =>
        assert.deepEqual(
            v.map(v => v.toNumber()),
            expected[i].c,
            'Error: tree.leaves()',
        ),
    );

    const xyResults = await Promise.all(xyPromiseList);
    xyResults.forEach((v, i) => {
        assert.equal(v[0].toNumber(), expected[i].x, 'Error: tree.getIdx().x');
        assert.equal(v[1].toNumber(), expected[i].y, 'Error: tree.getIdx().x');
    });
}

describe('TreeLib', function() {
    before(async () => {
        await configure();
    });

    it('tree.height()', async () => {
        const tree = await TestTreeLib.new();
        for (const t of treeStats) {
            assert.equal(
                (await tree.height(t.a, t.b, t.length)).toNumber(),
                t.height,
                `tree.height(${t.a},${t.b},${t.length})`,
            );
            assert.equal(
                (await tree.maxLength(t.a, t.b, t.height)).toNumber(),
                t.maxLength,
                `tree.maxLength(${t.a},${t.b},${t.height})`,
            );
        }
    });

    it('(2,2) => 2Tree, 2 nodes/pack', async () => {
        const tree = await TestTreeLib.new();
        await treeEqual(2, 2, tree, tree22);
    });

    it('(3,2) => 2Tree, 3 nodes/pack', async () => {
        const tree = await TestTreeLib.new();
        await treeEqual(3, 2, tree, tree32);
    });

    it('(4,2) => 2Tree, 4 nodes/pack', async () => {
        const tree = await TestTreeLib.new();
        await treeEqual(4, 2, tree, tree42);
    });

    it('(5,4) => 4Tree, 5 nodes/pack', async () => {
        const tree = await TestTreeLib.new();
        await treeEqual(5, 4, tree, tree54);
    });
});
