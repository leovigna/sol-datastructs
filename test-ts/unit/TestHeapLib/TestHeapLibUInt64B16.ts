import { testHeapLib } from './index'
import { TestHeapLibUInt64B16 } from "../../artifacts"

const contract = TestHeapLibUInt64B16
const TestHeapLib = 'TestHeapLibUInt64B16'
const HeapLib = 'HeapLibUInt64'
const a = 4
const b = 16

testHeapLib({ contract, TestHeapLib, HeapLib, a, b })
