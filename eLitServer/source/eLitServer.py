import sys
import pymongo


def start_server(ip: str, port: int):
    pass


if __name__ == '__main__':
    args = sys.argv
    if len(args != 3):
        start_server('localhost', 0)
    else:
        start_server(args[1], int(args[2]))
