import sympy as sp

#variables
vi,vo,vp,g1,g2,g3,g4,gl=sp.symbols("v_i v_o v_+ g_1 g_2 g_3 g_4 g_L")

#nodos
eq0=sp.Eq(g3*(vi-vp)+g1*(vo-vp),gl*vp)
eq1=sp.Eq(g4*vp,g2*(vo-vp))

eqvo0=sp.Eq(sp.solve(eq0,vo)[0],vo)
eqvo1=sp.Eq(sp.solve(eq1,vo)[0],vo)

sp.pprint((eqvo0,eqvo1))


il,rl,r1,r2,r3,r4=sp.symbols("i_L R_L R_1 R_2 R_3 R_4")

eqil=sp.solve((eqvo0.lhs-eqvo1.lhs).subs({vp:il*rl}),il)

eqil=eqil[0].subs({g1:1/r1,g2:1/r2,g3:1/r3,g4:1/r4,gl:1/rl})

sp.pprint(sp.numer(eqil)/sp.expand(sp.denom(eqil)))
# sp.pprint(sp.simplify(sp.solve(eqvo0[0]-eqvo1[0],vp)[0]))


