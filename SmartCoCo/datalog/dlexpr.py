from enum import Enum, auto
from typing import List

from datalog.dltypes import FunctionName, SouffleListItem


class Expr:
    def __init__(self, content: str):
        self.content = content

    def __str__(self) -> str:
        return f"$Literal(\"{self.content}\")"


class SouffleList:
    def __init__(self, items: List[SouffleListItem]):
        self.items: List[SouffleListItem] = items

    def __str__(self) -> str:
        if len(self.items) == 0:
            return "nil"
        str_par = []
        for i in self.items:
            if isinstance(i, Expr):
                str_par.append(str(i.content))
            else:
                str_par.append(str(i))
        return str(str_par)


class FnApply(Expr):
    func: FunctionName
    args: SouffleList


class UnaryOp(Enum):
    NEG = auto


class BinLogicOp(Enum):
    OR = auto()
    AND = auto()


class BinOp(Enum):
    LT = auto()
    LEQ = auto()
    EQ = auto()
    NEQ = auto()
    GT = auto()
    GEQ = auto()


class MathBinOp(Enum):
    ADD = auto()
    SUB = auto()
    MUL = auto()
    DIV = auto()


class Cmp(Expr):
    def __init__(self, op: BinOp, left: Expr, right: Expr):
        super().__init__("")
        self.op = op
        self.left = left
        self.right = right

    def __str__(self) -> str:
        return f"$Cmp({self.left}, {self.right}, {self.op.name})"


class MathExpr(Expr):
    def __init__(self, op: MathBinOp, left: Expr, right: Expr):
        super().__init__("")
        self.op = op
        self.left = left
        self.right = right

    def __str__(self) -> str:
        return f"$Math({self.left}, {self.right}, {self.op.name})"


class NegExpr(Expr):
    def __init__(self, e: Expr):
        super().__init__("")
        self.e = e

    def __str__(self) -> str:
        return f"$Neg({self.e})"


class BinLogExpr(Expr):
    def __init__(self, left: Expr, right: Expr, bin_logic_op: BinLogicOp):
        super().__init__("")
        self.left = left
        self.right = right
        self.op = bin_logic_op

    def __str__(self) -> str:
        return f"$Logic({self.left}, {self.right}, {self.op.name})"


class Bool(Expr):
    def __init__(self, b: bool):
        super().__init__("")
        self.b = b

    def __str__(self) -> str:
        return f"$Bool({self.b})"
