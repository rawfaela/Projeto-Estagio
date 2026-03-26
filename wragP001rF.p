{wparams.i}
{wcabweb.i vurl """ """}

assign vurl = "*" + furl(""" """).
def var vprop as int.
def var vvlote as int.

assign vprop = batweb.batpari[1].
assign vvlote = batweb.batpari[2].

find prop where prop.codigo = vprop no-lock no-error.
find vlote where vlote.codigo = vvlote no-lock no-error.

def buffer bprop for prop.
def buffer blote for vlote.

for each func no-lock
    where (vprop = 0 or func.prop = vprop) and
          (vvlote = 0 or func.lote = vvlote)
    break by func.prop
          by func.lote:

    find bprop where bprop.codigo = func.prop no-lock no-error.

    if first-of(func.prop) then do:
        finicio(2).
        final(yes, 100, "agrupar").
        finicio(1).
        fcaixa("C","<b>" + bprop.nome + "</b>","C","<b>Propriedade</b>","",1,0).
        final(yes, 100, "agrupar").
    end.

    find blote where blote.codigo = func.lote no-lock no-error.

    if first-of(func.lote) then do:
        finicio(2).
        final(yes, 100, "agrupar").
        finicio(3).
        fcaixa("E",if available blote then blote.nome else "Não especificado","E","<b>Lote</b>","",1,0).
        final(yes,100,"agrupar").
    end.

    finicio(vcor).
    fcaixa("E",func.nome,"E","<b>Nome</b>","",4,0).
    fcaixa("E",func.cargo,"E","<b>Cargo</b>","",2,0).
    fcaixa("C",func.fone,"C","<b>Telefone</b>","",2,0).
    fcaixa("C",func.email,"C","<b>Email</b>","",2,0).
    if last-of(func.prop) then final(yes,100,"").
    else if last-of(func.lote) then final(yes,100,"agrupar").
    else final(no,100,"").
end.
{wrodweb.i}
{warqfim.i}