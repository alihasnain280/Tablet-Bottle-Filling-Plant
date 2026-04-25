# Tablet Bottle Filling Plant Controller

## Overview
This project is a hardware-oriented Digital Logic Design (DLD) implementation of an automated tablet bottle filling plant. The system is designed to control the sequential operations of detecting bottles, dispensing a precise number of tablets, and managing conveyor movement using purely digital logic.

## System Architecture & Logic
The control system relies on digital logic gates to process physical inputs and trigger the appropriate mechanical responses. 
* **Sensor Integration:** Processes inputs from proximity and counting sensors to detect when a bottle is in position and how many tablets have been dispensed.
* **Combinational & Sequential Logic:** Utilizes custom-designed logic gate circuits to manage state transitions (e.g., stopping the conveyor when a bottle is detected, initiating the filling process, and resuming conveyor movement once the target tablet count is reached).
* **Fault Prevention:** Includes logic conditions to prevent overflow and ensure bottles are only filled when properly aligned under the dispenser.

## Technologies & Tools
* **Core Concepts:** Digital Logic Design (DLD), Boolean Algebra, State Machines
* **Hardware/Simulation:** Logic Gates (AND, OR, NOT, Flip-Flops), Sensor Input Simulation
* **Tools:**  Proteus

## How It Works
1. The conveyor moves empty bottles toward the filling station.
2. A sensor detects the presence of a bottle, triggering a logic state change that halts the conveyor motor.
3. The tablet dispenser is activated, and a secondary sensor counts the falling tablets.
4. Once the predetermined logic threshold (tablet count) is met, the dispenser shuts off.
5. The system resets the state, restarting the conveyor to bring in the next bottle.
