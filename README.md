# UART Protocol Design Using VHDL

## Project Overview

This project implements a Universal Asynchronous Receiver/Transmitter (UART) communication system using VHDL. The design consists of a UART transmitter, UART receiver, and a top-level module that integrates both components.

The UART transmitter converts parallel data into serial data, while the receiver converts the incoming serial data back into parallel data.

The design was developed and verified using Xilinx Vivado 2026.2. Functional verification was performed through transmitter simulation and TX-RX loopback simulation.

## Project Objectives

- Design and implement a UART transmitter using VHDL.
- Design and implement a UART receiver using VHDL.
- Implement 8-bit serial communication.
- Use finite state machines for transmitter and receiver control.
- Implement synchronization stages in the receiver.
- Verify data transmission and reception through simulation.
- Perform FPGA synthesis and implementation.
- Analyze timing performance after routing.

## UART Communication Specifications

| Parameter | Specification |
|---|---|
| Communication Protocol | UART |
| HDL | VHDL |
| Data Width | 8 Bits |
| Start Bit | 1 Bit |
| Stop Bit | 1 Bit |
| Parity | None |
| Data Transmission | LSB First |
| Default Clock Frequency | 100 MHz |
| Default Baud Rate | 9600 |

The UART frame consists of one start bit, eight data bits, and one stop bit. The communication line remains HIGH during the idle state. Transmission begins with a LOW start bit, followed by the data bits and a HIGH stop bit.

## Design Architecture

### 1. UART Transmitter (uart_tx.vhd)

The transmitter converts 8-bit parallel input data into serial output data.

Main functions:
- Accepts 8-bit parallel input data.
- Initiates transmission when the start signal is asserted.
- Generates the start bit.
- Transmits eight data bits in LSB-first order.
- Generates the stop bit.
- Provides busy status information.

The transmitter uses four FSM states:

- IDLE: Waits for a transmission request.
- START_BIT: Generates the start bit.
- DATA_BITS: Transmits the eight data bits.
- STOP_BIT: Generates the stop bit.

### 2. UART Receiver (uart_rx.vhd)

The receiver converts serial input data into 8-bit parallel output data.

Main functions:
- Receives incoming serial data.
- Uses synchronization stages for the incoming RX signal.
- Detects the start bit.
- Samples the incoming data bits.
- Reconstructs the received 8-bit data.
- Generates a reception completion signal.

The receiver uses four FSM states:

- IDLE: Waits for incoming serial data.
- START_BIT: Detects and validates the start bit.
- DATA_BITS: Receives the eight data bits.
- STOP_BIT: Processes the stop bit and completes reception.

### 3. UART Top Module (uart_top.vhd)

The top-level module integrates the UART transmitter and receiver.

It connects the transmitter serial output to the receiver serial input for loopback communication.

The top module provides the required clock, reset, transmission control, input data, received data, and status interfaces.

## Simulation and Verification

Simulation was performed using Xilinx Vivado behavioral simulation.

### Transmitter Verification

Testbench: tb_uart_tx.vhd

Simulation configuration:

| Parameter | Value |
|---|---|
| Test Clock Frequency | 1 MHz |
| Test Baud Rate | 100000 |
| Test Data | A5 (Hexadecimal) |
| Data Width | 8 Bits |

Result: PASS

The transmitter successfully completed the simulation test. The testbench displayed the confirmation message: UART TRANSMISSION TEST PASSED!

### TX-RX Loopback Verification

Testbench: tb_uart_loopback.vhd

The transmitter and receiver were connected through a loopback connection.

Verification procedure:

1. Reset the UART system.
2. Apply the test data A5.
3. Initiate transmission.
4. Transfer serial data from TX to RX.
5. Reconstruct the received parallel data.
6. Compare the received data with the transmitted data.

| Parameter | Value |
|---|---|
| Transmitted Data | A5 |
| Received Data | A5 |
| Verification Result | PASS |

The received data matched the transmitted data, confirming successful loopback simulation.

Note: The 1 MHz clock and 100000 baud rate are testbench settings. They are different from the default design configuration of 100 MHz and 9600 baud.

## FPGA Development Environment

| Parameter | Details |
|---|---|
| FPGA Design Tool | Xilinx Vivado 2026.2 |
| Target FPGA Family | Spartan-7 |
| Target Device | xc7s50csga324-1 |
| HDL | VHDL |
| Design Top Module | uart_top |
| Simulation Top Module | tb_uart_loopback |
| Clock Period Constraint | 10 ns |
| Clock Frequency Constraint | 100 MHz |

## Synthesis Results

The design was successfully synthesized using Xilinx Vivado.

| FPGA Resource | Utilization |
|---|---:|
| Slice LUTs | 60 |
| Slice Registers | 66 |
| Bonded IOB | 24 |
| BUFGCTRL | 1 |

## Implementation and Routing Results

The implementation process completed successfully.

| Parameter | Result |
|---|---:|
| Logical Nets | 217 |
| Nets Not Requiring Routing | 77 |
| Routable Nets | 140 |
| Fully Routed Nets | 140 |
| Nets with Routing Errors | 0 |

All 140 routable nets were successfully routed, with zero routing errors.

## Static Timing Analysis

Static timing analysis was performed after implementation and routing.

Clock configuration:
- Clock Name: sys_clk
- Clock Period: 10 ns
- Clock Frequency: 100 MHz

### Timing Summary

| Timing Parameter | Result |
|---|---:|
| WNS | +6.134 ns |
| TNS | 0.000 ns |
| WHS | +0.150 ns |
| THS | 0.000 ns |
| WPWS | +4.500 ns |
| TPWS | 0.000 ns |

### Timing Analysis

- Positive WNS indicates that the reported constrained setup paths meet the timing requirement.
- Zero TNS indicates no failing setup endpoints.
- Positive WHS indicates that the reported constrained hold paths meet the timing requirement.
- Zero THS indicates no failing hold endpoints.
- Positive WPWS indicates that the reported pulse-width checks meet the timing requirement.

**Timing Constraint Limitation:**

The timing report identified 11 input ports and 12 output ports without specified input/output delay constraints.

Therefore, the reported internal clock-domain timing checks passed under the specified 100 MHz clock constraint. Complete external input/output timing closure has not been established.

Timing report: uart_top_timing_summary_routed.rpt

## Project File Structure

The project contains the following main design and verification files:

| File Name | Description |
|---|---|
| uart_tx.vhd | UART transmitter module |
| uart_rx.vhd | UART receiver module |
| uart_top.vhd | Top-level integration module |
| tb_uart_tx.vhd | Transmitter testbench |
| tb_uart_loopback.vhd | TX-RX loopback testbench |
| uart_top.xdc | Clock constraint file |
| uart_top_timing_summary_routed.rpt | Routed timing summary report |
| README.md | Project documentation |

## Tools and Technologies

- VHDL
- Xilinx Vivado 2026.2
- Behavioral Simulation
- Finite State Machines
- FPGA Synthesis
- Implementation and Routing
- Static Timing Analysis

## Conclusion

The UART communication system was successfully designed and implemented using VHDL.

The transmitter and receiver functionalities were verified through behavioral simulation. The transmitter successfully transmitted the test data A5, and the loopback test confirmed that the receiver correctly reconstructed the same data.

The design completed synthesis, implementation, and routing in Xilinx Vivado. Static timing analysis reported positive setup, hold, and pulse-width slack for the analyzed constrained paths.

The project demonstrates the implementation and simulation-based verification of a UART communication system using VHDL.

**Project Status:** Simulation, synthesis, implementation, and routing completed successfully.

**Hardware Verification:** Not performed because a physical FPGA development board was not available.

## Future Enhancements

- Configurable baud-rate selection.
- Parity generation and checking.
- Framing error detection.
- Receive overrun error detection.
- Physical FPGA board verification.
- Complete external input and output timing constraints.
