import {
    TestHeapLibUInt16B2Contract,
    TestHeapLibUInt16B8Contract,
    TestHeapLibUInt32B8Contract,
    TestHeapLibUInt32B16Contract,
    TestHeapLibUInt64B16Contract,
    TestArrayLibUInt16Contract,
    TestArrayLibUInt32Contract,
    TestArrayLibUInt64Contract,
    TestArrayLibUInt128Contract,
    TestTreeLibContract,
    TestLogBaseNContract,
    KeyStoreContract,
    IHeapUInt16Instance,
    IHeapUInt32Instance,
    IListUInt16Instance,
    IListUInt32Instance,
    IListUInt64Instance,
    IListUInt128Instance,
    IHeapUInt64Instance,
    TestHeapLibUInt16B2Instance,
    TestHeapLibUInt16B8Instance,
    TestHeapLibUInt32B16Instance,
    TestHeapLibUInt32B8Instance,
    TestHeapLibUInt64B16Instance,
    KeyStoreInstance
} from "../types/truffle-contracts"

import TestLogBaseNArtifact from "../build/contracts/TestLogBaseN.json"

import TestArrayLibUInt16Artifact from "../build/contracts/TestArrayLibUInt16.json"
import TestArrayLibUInt32Artifact from "../build/contracts/TestArrayLibUInt32.json"
import TestArrayLibUInt64Artifact from "../build/contracts/TestArrayLibUInt64.json"
import TestArrayLibUInt128Artifact from "../build/contracts/TestArrayLibUInt128.json"

import TestTreeLibArtifact from "../build/contracts/TestTreeLib.json"

import TestHeapLibUInt16B2Artifact from "../build/contracts/TestHeapLibUInt16B2.json"
import TestHeapLibUInt16B8Artifact from "../build/contracts/TestHeapLibUInt16B8.json"
import TestHeapLibUInt32B8Artifact from "../build/contracts/TestHeapLibUInt32B8.json"
import TestHeapLibUInt32B16Artifact from "../build/contracts/TestHeapLibUInt32B16.json"
import TestHeapLibUInt64B16Artifact from "../build/contracts/TestHeapLibUInt64B16.json"

import KeyStoreArtifact from "../build/contracts/KeyStore.json"

const Contract = require('@truffle/contract');

export const TestLogBaseN = Contract(TestLogBaseNArtifact) as TestLogBaseNContract

export const TestArrayLibUInt16 = Contract(TestArrayLibUInt16Artifact) as TestArrayLibUInt16Contract
export const TestArrayLibUInt32 = Contract(TestArrayLibUInt32Artifact) as TestArrayLibUInt32Contract
export const TestArrayLibUInt64 = Contract(TestArrayLibUInt64Artifact) as TestArrayLibUInt64Contract
export const TestArrayLibUInt128 = Contract(TestArrayLibUInt128Artifact) as TestArrayLibUInt128Contract
export type TestArrayLibUIntContract = TestArrayLibUInt16Contract | TestArrayLibUInt32Contract | TestArrayLibUInt64Contract | TestArrayLibUInt128Contract
export type IListUIntInstance = IListUInt128Instance | IListUInt64Instance | IListUInt32Instance | IListUInt16Instance
const TestArrayLibContracts = {
    TestArrayLibUInt16,
    TestArrayLibUInt32,
    TestArrayLibUInt64,
    TestArrayLibUInt128
}
export type TestArrayLibUIntName = keyof (typeof TestArrayLibContracts)

export const TestTreeLib = Contract(TestTreeLibArtifact) as TestTreeLibContract

export const TestHeapLibUInt16B2 = Contract(TestHeapLibUInt16B2Artifact) as TestHeapLibUInt16B2Contract
export const TestHeapLibUInt16B8 = Contract(TestHeapLibUInt16B8Artifact) as TestHeapLibUInt16B8Contract
export const TestHeapLibUInt32B8 = Contract(TestHeapLibUInt32B8Artifact) as TestHeapLibUInt32B8Contract
export const TestHeapLibUInt32B16 = Contract(TestHeapLibUInt32B16Artifact) as TestHeapLibUInt32B16Contract
export const TestHeapLibUInt64B16 = Contract(TestHeapLibUInt64B16Artifact) as TestHeapLibUInt64B16Contract
export type TestHeapLibUIntContract = TestHeapLibUInt16B2Contract | TestHeapLibUInt16B8Contract | TestHeapLibUInt32B8Contract | TestHeapLibUInt32B16Contract | TestHeapLibUInt64B16Contract
export type TestHeapLibUIntInstance = TestHeapLibUInt16B2Instance | TestHeapLibUInt16B8Instance | TestHeapLibUInt32B8Instance | TestHeapLibUInt32B16Instance | TestHeapLibUInt64B16Instance
export type IHeapUIntInstance = IHeapUInt16Instance | IHeapUInt32Instance | IHeapUInt64Instance
const TestHeapLibUIntContracts = {
    TestHeapLibUInt16B2,
    TestHeapLibUInt16B8,
    TestHeapLibUInt32B8,
    TestHeapLibUInt32B16,
    TestHeapLibUInt64B16
}
export type TestHeapLibUIntName = keyof (typeof TestHeapLibUIntContracts)
export type HeapLibUIntName = 'HeapLibUInt16' | 'HeapLibUInt32' | 'HeapLibUInt64'

export const KeyStore = Contract(KeyStoreArtifact) as KeyStoreContract

export const contracts = {
    ...TestArrayLibContracts,
    ...TestHeapLibUIntContracts,
    TestLogBaseN,
    TestTreeLib,
    KeyStore
}
export type ContractName = keyof typeof contracts;

//patch mock artifacts object for backwards-compatibility
export const artifacts = {
    require(name: ContractName) {
        return contracts[name];
    },
};
