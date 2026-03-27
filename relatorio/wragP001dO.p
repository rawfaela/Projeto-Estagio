{webpro.i}
{wpaddisp.i}

function fprop returns char() forwards.

procedure p_setparams:
    assign vpad-titulo   = "Ocorrências por propriedade"
           vpad-numcol   = 2
           vpad-programa = "wragP001rO.p"
           vpad-btdisp   = true.
end procedure.

procedure p_setinitial:
    {&out}
        fbranco(3,vpad-numcol)
        flabel("Propriedade:","right",0,yes,no,47,yes,yes)
        fselect("vprop",fprop(),get-value("vprop"),1,no,no,"left",0,no,yes,0,yes,yes,"")
        fbranco(1,vpad-numcol)
        flabel("Data inicial:","right",0,yes,no,0,yes,yes)
        fpad-text("vdataini",10,10,get-value("vdataini"),"DT",no,"left",0,no,yes,0,yes,yes,"document.forms[0].submit();","")
        flabel("Data final:","right",0,yes,no,0,yes,yes)
        fpad-text("vdatafim",10,10,get-value("vdatafim"),"DT",no,"left",0,no,yes,0,yes,yes,"document.forms[0].submit();","")
    .
end procedure.

procedure p_disparar:
    create tp-batweb.
    assign tp-batweb.batdes = vpad-titulo
           tp-batweb.batprog = vpad-programa
           tp-batweb.batpardc[1] = 2.2
           tp-batweb.batparlg[1] = yes
           tp-batweb.batpari[1] = int(get-value("vprop"))
           tp-batweb.batpardt[1] = today
           tp-batweb.batpardt[2] = date(get-value("vdataini"))
           tp-batweb.batpardt[3] = date(get-value("vdatafim")).
end procedure.

function fprop returns char():
    def var vselect as char.
    assign vselect =",<-- SELECIONE -->".

    for each prop no-lock by prop.nome:
        assign vselect = vselect + "," + string(prop.codigo) + "," + prop.nome.
    end.

    return vselect.
end function.

procedure p_valida:
    if date(get-value("vdataini")) > date(get-value("vdatafim")) 
    and date(get-value("vdatafim")) <> ? then do:
        {wpaderro.i "erro" "'Data inicial maior que data final'"}
    end.
end procedure.
