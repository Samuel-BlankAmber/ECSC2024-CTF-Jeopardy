import os

n_teams=37

flags={}

base_flag="ECSC{JUS7_D0NT_G0_4ROUND_M3SS1NG_W1TH_P30PLE5_PHON3S_N0W!_%s}"

for team in range(n_teams):
    flag = base_flag % os.urandom(4).hex().upper()
    team_id_padded=str(team+1).rjust(2, '0')
    flags[f"team{team_id_padded}"]=flag

print(flags)