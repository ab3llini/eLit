from hashlib import md5
from pickle import dumps


class A:
    def __init__(self, str):
        self.title = str
        self.md5 = md5(dumps(self)).hexdigest()


class B(A):
    def __init__(self):
        self.title_son = 'B'
        super().__init__('A')


class C(A):
    def __init__(self):
        super().__init__('A')


if __name__ == '__main__':
    print(A('A').md5)
    print(A('a').md5)
    print(B().md5)
    print(C().md5)