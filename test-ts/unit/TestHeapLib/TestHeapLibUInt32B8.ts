import { testHeapLib } from './index'
import { TestHeapLibUInt32B8 } from "../../artifacts"

const contract = TestHeapLibUInt32B8
const TestHeapLib = 'TestHeapLibUInt32B8'
const HeapLib = 'HeapLibUInt32'
const a = 8
const b = 8

testHeapLib({ contract, TestHeapLib, HeapLib, a, b })
