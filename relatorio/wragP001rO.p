{wparams.i}
{wcabweb.i vurl """ """}

assign vurl = "*" + furl(""" """).

def var vprop    as int.
def var vdataini as date.
def var vdatafim as date.

assign vprop    = batweb.batpari[1]
       vdataini = batweb.batpardt[2]
       vdatafim = batweb.batpardt[3].

find prop where prop.codigo = vprop no-lock no-error.

for each ocorrencia no-lock
    where (vprop    = 0 or ocorrencia.prop  = vprop)
      and (vdataini = ? or ocorrencia.data >= vdataini)
      and (vdatafim = ? or ocorrencia.data <= vdatafim)

    break by ocorrencia.prop
          by ocorrencia.categoria
          by ocorrencia.data:

    find prop where prop.codigo = ocorrencia.prop no-lock no-error.

    if first-of(ocorrencia.prop) then do:
        finicio(3).
        fcaixa("C", "<b>" + prop.nome + "</b>", "C", "<b>Propriedade</b>", "", 1, 0).
        final(yes, 100, "agrupar").
    end.

    if first-of(ocorrencia.categoria) then do:
        finicio(2).
        fcaixa("E",ocorrencia.categoria, "E", "<b>Categoria</b>", "", 1, 0).
        final(yes, 100, "agrupar").
    end.

    find func where func.codigo = ocorrencia.func no-lock no-error.
    find animal where animal.codigo = ocorrencia.animal no-lock no-error.
    find vlote where vlote.codigo = ocorrencia.lote no-lock no-error.

    finicio(vcor).
    fcaixa("C", string(ocorrencia.data,"99/99/9999"),"C", "Data", "", 1, 0).
    fcaixa("E", ocorrencia.descricao,"E", "Descrição", "", 6, 0).
    fcaixa("E",string(ocorrencia.animal, "99") + " - " + animal.nome,"E","Animal","",2,0).
    fcaixa("E",string(ocorrencia.func,"99") + " - " + func.nome,"E","Funcionário","",2,0).
    fcaixa("E",string(ocorrencia.lote, "99") + " - " + vlote.nome,"E","Lote","",2,0).
    fcaixa("C", ocorrencia.vstatus,"C", "Status", "", 2, 0).
    if last-of(ocorrencia.prop) then
        final(yes, 100, "").
    else if last-of(ocorrencia.categoria) then
        final(yes, 100, "agrupar").
    else final(no, 100, "").
end.

{wrodweb.i}
{warqfim.i}
