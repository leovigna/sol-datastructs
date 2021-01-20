import { testHeapLib } from './index'
import { TestHeapLibUInt32B16 } from "../../artifacts"

const contract = TestHeapLibUInt32B16
const TestHeapLib = 'TestHeapLibUInt32B16'
const HeapLib = 'HeapLibUInt32'
const a = 8
const b = 16

testHeapLib({ contract, TestHeapLib, HeapLib, a, b })
