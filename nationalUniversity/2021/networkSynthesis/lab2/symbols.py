import operator
import numpy as np
import sympy as sp

def mem2mem(equation,opp):
    sel=opp[0]
    expr=sp.sympify(opp[1::])
    
    if sel=="+":
        return sp.Eq(equation.lhs+expr,equation.rhs+expr)
    elif sel=="-":
        return sp.Eq(equation.lhs-expr,equation.rhs-expr)
    elif sel=="*":
        return sp.Eq(equation.lhs*expr,equation.rhs*expr)
    elif sel=="/":
        return sp.Eq(equation.lhs/expr,equation.rhs/expr)

######################################################################################################

Avf,Avfi,avf,wh,s,w=sp.symbols("Avf,Avfi,avf,omega_h,s,omega")

#ganancia nomalizada
avfEqq=sp.Eq(avf,1/(1+s/wh))
sp.pprint(avfEqq)
sp.print_latex(avfEqq)

#modulo y fase
avfmodEqq=sp.Eq(sp.Abs(avfEqq.lhs),1/sp.sqrt(1+(w/wh)**2))
fi=sp.symbols("phi")
avffasEqq=sp.Eq(fi,-sp.atan(w/wh))

#sp.pprint(avfmodEqq)
sp.print_latex(avfmodEqq)
#sp.pprint(avffasEqq)
sp.print_latex(avffasEqq)

#error vectorial (o de ganancia ianiselaberdad)
ev=sp.symbols("epsilon_v")

evEqq=sp.Eq(ev,sp.Abs(1-Avf/Avfi))
#sp.pprint(evEqq)
sp.print_latex(evEqq)

evmodEqq=sp.Eq(sp.Abs(ev),1-avfmodEqq.rhs)
evfasEqq=sp.Eq(fi,sp.pi/2-sp.atan(w/wh))

#sp.pprint(evmodEqq)
sp.print_latex(evmodEqq)
#sp.pprint(evfasEqq)
sp.print_latex(evfasEqq)


