import subprocess, sys, re
from expected import EXPECTED

tests = ["t1_arith","t2_imm","t3_loadstore","t4_upperimm","t5_branch","t6_jump","t7_branch2"]
results = []

for t in tests:
    asm_path = f"tests/{t}.asm"
    hex_path = "sim/prog.hex"

    r = subprocess.run(["python3", "assembler/assem.py", asm_path, hex_path], 
                       capture_output=True, text=True)

    if r.returncode != 0:
        print(f"{t}: ASSEMBLE FAIL\n{r.stderr}")
        results.append((t, False, "assemble error"))
        continue

    r2 = subprocess.run(["vvp", "tests/cpu_sim"], capture_output=True, text=True)
    print(r2.stdout)

    regs = {}
    with open("sim/register_dump.txt") as f:
        for line in f:
            m = re.match(r"x(\d+) = ([0-9a-fA-F]+)", line.strip())
            if m:
                regs[int(m.group(1))] = int(m.group(2), 10)

    exp = EXPECTED[t]
    mismatches = []

    for reg, val in exp.items():
        actual = regs.get(reg)
        if actual != val:
            mismatches.append([reg, val, actual])

    passed = len(mismatches) == 0
    results.append([t, passed, mismatches])
    status = "PASSED" if passed else "FAILED"
    print(f"{t}: {status}  (checked {len(exp)} registers)")
    if mismatches:
        for reg, exp_v, act_v in mismatches:
            print(f"    x{reg}: expected {exp_v}, got {act_v}")

n_pass = sum(1 for _,p,_ in results if p)
print(f"\n{n_pass}/{len(results)} test programs passed")