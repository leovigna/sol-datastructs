import { testHeapLib } from './index'
import { TestHeapLibUInt16B8 } from "../../artifacts"

const contract = TestHeapLibUInt16B8
const TestHeapLib = 'TestHeapLibUInt16B8'
const HeapLib = 'HeapLibUInt16'
const a = 16
const b = 8

testHeapLib({ contract, TestHeapLib, HeapLib, a, b })
