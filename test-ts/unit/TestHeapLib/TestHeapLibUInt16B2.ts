import { testHeapLib } from './index'
import { TestHeapLibUInt16B2 } from "../../artifacts"

const contract = TestHeapLibUInt16B2
const TestHeapLib = 'TestHeapLibUInt16B2'
const HeapLib = 'HeapLibUInt16'
const a = 16
const b = 2

testHeapLib({ contract, TestHeapLib, HeapLib, a, b })
