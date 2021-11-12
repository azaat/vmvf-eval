import argparse
import pandas as pd
from decimal import *
import os


VINS_RES = "vins_result_no_loop.csv"
VINS_RES_LOOP = "vins_result_loop.csv"

def main():
    parser = argparse.ArgumentParser(
        description="Convert traj"
    )
    parser.add_argument(
        "--traj_file",
        required=True
    )
    parser.add_argument(
        "--date",
        required=True
    )
    parser.add_argument(
        "--traj_path",
        required=True
    )

    args = parser.parse_args()
    traj_path = os.path.join(args.traj_path, args.traj_file)
    output_path = os.path.join(args.traj_path, f'{args.date}.txt')
    
    traj = pd.read_csv(traj_path, index_col=False, names=['t', 'tx', 'ty', 'tz', 'rw', 'rx', 'ry', 'rz'])
    traj = traj[['t', 'tx', 'ty', 'tz', 'rx', 'ry', 'rz', 'rw']]
    traj.t = traj.t / Decimal(1e9)
    traj.to_csv(output_path, sep=" ", index=False, header=False)


if __name__ == '__main__':
    main()
