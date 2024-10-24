#!/usr/bin/env python3.12

import logging
import re
import sys
from dataclasses import dataclass
from functools import lru_cache
from typing import Callable, Literal, Mapping, Sequence

import z3

with open(sys.argv[1], "r") as f:
    circuit_v = f.readlines()

logging.basicConfig(level=logging.DEBUG)
# logging.basicConfig(level=logging.CRITICAL)
log = logging.getLogger(__name__)


class frozendict(dict):
    """i trust you not to mutate it"""

    def __hash__(self):
        if not hasattr(self, "_hash"):
            self._hash = hash(frozenset(self.items()))
        return self._hash


Wire = str
Bit = Literal[0, 1] | z3.BitVecRef


@dataclass(frozen=True)
class Op:
    name: str
    eval: 'Callable[[Bit, ...], Bit]'


AND = Op("AND", lambda x, y: x & y)
NOT = Op("NOT", lambda x: ~x)


@dataclass(frozen=True)
class Gate:
    op: Op
    wires: Sequence[Wire]

    def __str__(self):
        return f"{self.op.name}({', '.join(map(str, self.wires))})"


STATE_W = 3 # width of d-flip-flop
INPUT_W = 64


def parse_circuit(circuit_v: Sequence[str]) -> tuple[list[Wire], list[Wire], Mapping[Wire, Gate]]:
    circuit_it = iter(circuit_v)
    while not next(circuit_it).startswith("module circuit"):
        pass

    inputs: list[Wire] = []
    outputs: list[Wire] = []
    wires: Mapping[Wire, Gate] = {}
    while True:
        match re.split(r"[\s\(\),;]+", next(circuit_it)):
            case ["module", name, *ports, ""]:
                pass
            case ["", "wire", wire, ""]:
                pass
            case ["", "input", wire, ""]:
                inputs.append(wire)
            case ["", "output", wire, ""]:
                outputs.append(wire)
            case ["", "assign", sol, "=", y, "&", z, ""]:
                wires[sol] = Gate(AND, (y, z))
            case ["", "assign", sol, "=", y, ""] if y[0] == "~":
                wires[sol] = Gate(NOT, (y[1:],))
            case ["/*", *_]:
                pass
            case r if any("d_flip_flop_array" in ri for ri in r):
                while not next(circuit_it).endswith(");\n"):
                    pass
            case ["endmodule", ""]:
                break
            case r:
                log.error(f"Unmatched: {r}")

    inputs.remove("clk")
    inputs.remove("reset")
    inputs.extend([f"q_out_{i}" for i in range(STATE_W)])
    outputs.extend([f"d_in_{i}" for i in range(STATE_W)])
    log.debug(inputs)
    log.debug(outputs)

    wires = frozendict(wires)

    return inputs, outputs, wires


inputs, outputs, circuit = parse_circuit(circuit_v)


@lru_cache(maxsize=None)
def resolve(wire: Wire, inputs_map: Mapping[Wire, Bit], circuit: Mapping[Wire, Gate]) -> Bit:
    """recursively resolve wire value until it is a function of inputs

    if circuit = {o: w & i0, w: ~i1} and inputs_map = {i0: b0, i1: b1} (and o is the output wire)
    it will return b1 & ~b0
    """
    if wire in inputs_map:
        return inputs_map[wire]
    gate = circuit[wire]
    return gate.op.eval(*[resolve(w, inputs_map, circuit) for w in gate.wires])


# simbolically resolve `out` wire
inputs_map = frozendict({name: z3.BitVec(name, 1) for name in inputs})
log.debug(resolve("out", inputs_map, circuit))  # q_out_2 & ~q_out_1 & ~q_out_0


def solve_for(targets: Mapping[Wire, int], inputs: list[Wire], circuit: Mapping[Wire, Gate]) -> Mapping[Wire, int]:
    inputs_map = frozendict({name: z3.BitVec(name, 1) for name in inputs})

    s = z3.Solver()
    for name, value in targets.items():
        s.add(resolve(name, inputs_map, circuit) == value)

    assert s.check() == z3.sat
    m = s.model()
    sol = {name: bitsol.as_long() for name in inputs if (bitsol := m[inputs_map[name]]) is not None}

    # check that it is the only solution
    s.add(z3.Or([inputs_map[name] != sol[name] for name in sol.keys()]))
    assert s.check() == z3.unsat

    return sol


sol = solve_for({"out": 1}, inputs, circuit)

out = sum(sol[f"q_out_{i}"] << i for i in range(STATE_W))
log.debug(sol)
log.debug(f"{out:0{STATE_W}b}")
log.debug("---")

flag = b""

for _ in range(4):
    sol = solve_for({f"d_in_{i}": sol[f"q_out_{i}"] for i in range(STATE_W)}, inputs, circuit)
    a = sum(sol[f"a_{i}"] << i for i in range(INPUT_W))
    out = sum(sol[f"q_out_{i}"] << i for i in range(STATE_W))
    log.debug(sol)
    log.debug(f"{a:04x}")
    log.debug(f"{out:0{STATE_W}b}")
    log.debug("---")

    flag = a.to_bytes(8, "big") + flag

print(flag.decode())
