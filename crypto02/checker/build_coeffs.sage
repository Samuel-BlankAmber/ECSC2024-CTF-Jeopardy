import json

def get_coeff(n_shares):
    M = matrix(ZZ, [[x**i for i in range(n_shares)] for x in range(1, n_shares+1)])
    coeffs = M.solve_left(vector(ZZ, [1] + [0]*(n_shares - 1)))
    return coeffs[n_shares-2]

def build_M():
    m = []
    for n_shares in range(2, 101):
        c = get_coeff(n_shares)
        row = c*vector(ZZ, [(n_shares - 1)**i for i in range(n_shares)] + [0]*(100 - n_shares))
        m.append(row)
    c = get_coeff(101)
    m.append(c*vector(ZZ, [(100)**i for i in range(100)]))
    c = get_coeff(102)
    m.append(c*vector(ZZ, [(101)**i for i in range(100)]))

    return matrix(ZZ, m)

M = build_M()
coeffs = M.left_kernel().basis()[0]
assert all(x in ZZ for x in coeffs)

with open("coeffs.json", "w") as wf:
    wf.write(json.dumps([int(x) for x in list(coeffs)]))