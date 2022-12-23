# The Simplest CPU

# What is it?
As a laboratory work.
This is the simplest version of the CPU and is not a complete implementation of it.
The main goal of the laboratory work is conflict resolving (see table below).

Presented in this project:
* RAM,
* four-stage conveyor;
* registries.

Not presented in this project:
* command memory;
* mechanism for reading commands from command memory.

Realised on VHDL.

|                            Author                            | branch        | Quantity conveyors | Quantity registries |            Supported instructions             |            Conflict type             |
|:------------------------------------------------------------:|:--------------|:------------------:|:-------------------:|:---------------------------------------------:|:------------------------------------:|
| [@johuex](https://github.com/johuex "johuex GitHub profile") | master        |         5          |         10          | Load, Store, Sum, Mul (performed in 4 cycles) | Data conflict, external memory cells |
| [@ErmPav](https://github.com/ErmPav "ErmPav GitHub profile") | pav           |         6          |          8          |             Load, Store, Sum, Sub             | Data conflict, external memory cells |

# How to launch and test
0. Uncomment `19-27` lines and comment `35-39` + `339-360` lines in top-level file (`simple_vhdl_cpu.vhd`);
1. Check VHDL syntax errors in Quartus Prime;
2. Comment `19-27` lines and uncomment `35-39` + `339-360` lines in top-level file (`simple_vhdl_cpu.vhd`);
3. Testing this RTL models in ModelSim: Compile + Simulation.

