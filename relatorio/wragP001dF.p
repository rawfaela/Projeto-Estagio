{webpro.i}
{wpaddisp.i}

function fprop returns char() forwards.
function flote returns char() forwards.

procedure p_setparams:
    assign vpad-titulo   = "Funcionários por propriedade"
           vpad-numcol   = 2
           vpad-programa = "wragP001rF.p"
           vpad-btdisp   = true.
end procedure.

procedure p_setinitial:
    {&out}
        fbranco(3,vpad-numcol)
        flabel("Propriedade:","right",0,yes,no,47,yes,yes)
        fselect("vprop",fprop(),get-value("vprop"),1,no,no,"left",0,no,yes,0,yes,yes,"document.forms[0].submit();")

        flabel("Lote:","right",0,no,no,0,yes,yes)
        fselect("tlote",flote(),get-value("tlote"),1,no,no,"left",0,no,yes,0,yes,yes,"")
    .
end procedure.

procedure p_disparar:
    create tp-batweb.
    assign tp-batweb.batdes      = vpad-titulo
           tp-batweb.batprog     = vpad-programa
           tp-batweb.batpari[1]  = int(get-value("vprop"))
           tp-batweb.batpari[2]  = int(get-value("tlote"))
           tp-batweb.batpardc[1] = 2.2
           tp-batweb.batparlg[1] = yes
           tp-batweb.batpardt[1] = today.
end procedure.

function fprop returns char():
    def var vselect as char.
    assign vselect = ",<-- SELECIONE -->".

    for each prop no-lock by prop.nome:
        assign vselect = vselect + "," + string(prop.codigo) + "," + prop.nome.
    end.
    return vselect.
end function.

function flote returns char():
    def var vselect2 as char.
    def var vprop    as int.

    assign vselect2 = ",<-- SELECIONE -->"
           vprop    = int(get-value("vprop")).

    for each tlote no-lock
        where (vprop = 0 or tlote.prop = vprop)
        by tlote.nome:

        assign vselect2 = vselect2 + "," 
                        + string(tlote.codigo) + "," 
                        + tlote.nome.
    end.

    return vselect2.
end function.
