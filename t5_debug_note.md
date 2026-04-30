# SUB 第三步结果异常排查

当 RAM 使用 `inst5.coe` 时，第 4 条指令是 `0401`，含义是 **SUB 立即数 0x01**，不是 `SUB_A [0x01]`。

- `0401`：opcode `04`（SUB immediate），ALU 执行 `ACC - 0x0001`。
- `1401`：opcode `14`（SUB_A direct address），ALU 执行 `ACC - MEM[0x01]`。

另外，`inst5.coe` 里地址 `0x01` 存放的是程序指令（`2242`），不是纯数据。
如果直接做 `SUB_A [0x01]`，实际会减去 `0x2242`，这通常会被误认为“结果不对”。

为便于对照，新增了 `inst5_sub_addr_fix.coe`，把原程序中两个 `0401` 改成了 `1440`，即减去数据区 `MEM[0x40]`（值 `0x001A`）。
