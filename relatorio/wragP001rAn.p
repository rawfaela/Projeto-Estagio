{wparams.i}
{wcabweb.i vurl """ """}

assign vurl = "*" + furl(""" """).
def var vprop as int.
def var vvlote as int.
def var vsexo as char.
def var vvstatus as char.
def var vdataini as date.
def var vdatafim as date.

assign vprop = batweb.batpari[1]
       vvlote = batweb.batpari[2]
       vsexo = batweb.batparc[1]
       vvstatus = batweb.batparc[2]
       vdataini = batweb.batpardt[2]
       vdatafim = batweb.batpardt[3]
.

find prop where prop.codigo = vprop no-lock no-error.
find vlote where vlote.codigo = vvlote no-lock no-error.

for each animal no-lock 
    where (vprop = 0 or animal.prop = vprop) and
          (vvlote = 0 or animal.lote = vvlote) and
          (vsexo = "" or can-do(vsexo, if animal.sexo = yes then "M" else "F")) and
          (vvstatus = "" or can-do(vvstatus, animal.vstatus)) and
          (vdataini = ? or animal.nasc >= vdataini) and
          (vdatafim = ? or animal.nasc <= vdatafim)
    break by animal.prop by animal.lote by animal.nasc desc by animal.sexo:

    find prop where prop.codigo = animal.prop no-lock no-error.

    if first-of(animal.prop) then do:
        finicio(3).
        fcaixa("C","<b>" + prop.nome + "</b>","C","<b>Propriedade</b>","",1,0).
        final(yes,100,"agrupar").
    end.

    find vlote where vlote.codigo = animal.lote no-lock no-error.

    if first-of(animal.lote) then do:
        finicio(2).
        fcaixa("E", vlote.nome, "E","<b>Lote</b>","",1,0).
        final(yes,100,"agrupar").
    end.

    finicio(vcor).
    fcaixa("E",animal.nome,"E","<b>Nome</b>","",4,0).
    fcaixa("C",(if animal.sexo then "M" else "F"),"C","<b>Sexo</b>","",0,0).
    fcaixa("C",animal.vstatus,"C","<b>Status</b>","",0,0).
    fcaixa("C",string(animal.peso),"C","<b>Peso (kg)</b>","",0,0).
    fcaixa("C",string(animal.nasc, "99/99/9999"),"C","<b>Nascimento</b>","",0,0).
    if last-of(animal.prop) then final(yes,100,"").
    else if last-of(animal.lote) then final(yes,100,"agrupar").
    else final(no,100,"").
end.

{wrodweb.i}
{warqfim.i}
