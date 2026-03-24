{wparams.i}
{wcabweb.i vurl """ """}

assign vurl = "*" + furl(""" """).

def var vprop as int.
def var vdataini as date.
def var vdatafim as date.
def var vocorrencias as int.
assign vprop = batweb.batpari[1].
assign vdataini = batweb.batpardt[2].
assign vdatafim = batweb.batpardt[3].

find prop where prop.codigo = vprop no-lock no-error.
def buffer bprop for prop.

for each ocorrencia no-lock
    where (vprop = 0 or ocorrencia.prop = vprop)
      and (vdataini = ? or ocorrencia.data >= vdataini)
      and (vdatafim = ? or ocorrencia.data <= vdatafim)
    break by ocorrencia.prop
          by ocorrencia.categoria
          by ocorrencia.data:

    find bprop where bprop.codigo = ocorrencia.prop no-lock no-error.

    if first-of(ocorrencia.categoria) then do:
        assign vocorrencias = 0.
    end.

    finicio(vcor).

    if available bprop then
        fcaixa("C", bprop.nome, "C", "Propriedade", "", 0, 0).
    else
        fcaixa("C", "", "C", "Propriedade", "", 0, 0).

    fcaixa("C",ocorrencia.categoria,"C","Categoria","",0,0).
    fcaixa("C",ocorrencia.descricao,"E","Descrição","", 0,0).
    fcaixa("C",ocorrencia.vstatus,"C","Status","",0,0).
    fcaixa("C",string(ocorrencia.data),"C","Data","",0,0).
    fcaixa("C","", "C", "Total da categoria","",0,0).

    final(no,100,"").

    assign vocorrencias = vocorrencias + 1.

    if last-of(ocorrencia.categoria) then do:
        finicio(vcor).

        fcaixa("C","","C","","",0,0).
        fcaixa("C","","C","","",0,0).
        fcaixa("C","","C","","",0,0).
        fcaixa("C","","C","","",0,0).
        fcaixa("C","","C","","",0,0).
        fcaixa("C",string(vocorrencias),"C","","",0,0).

        final(no,100,"").
    end.

end.

{wrodweb.i}
{warqfim.i}

