{webpro.i}
{wpaddisp.i}

function fprop returns char() forwards.
function flote returns char() forwards.
def var vsexo   as char.
def var fstatus as char.

procedure p_setparams:
    assign vpad-titulo   = "Animais por propriedade"
           vpad-numcol   = 2
           vpad-programa = "wragP001rAn.p"
           vpad-btdisp   = true.
end procedure.

procedure p_setinitial:
    {&out}
        fbranco(2,vpad-numcol)
        flabel("Propriedade:","right",0,yes,no,47,yes,yes)
        fselect("vprop",fprop(),get-value("vprop"),1,no,no,"left",0,no,yes,0,yes,yes,"document.forms[0].submit();")


        flabel("Lote:","right",0,yes,no,0,yes,yes)
        fselect("vlote",flote(),get-value("vlote"),1,no,no,"left",0,no,yes,0,yes,yes,"document.forms[0].submit();")
        

        fbranco(1,vpad-numcol)
        flabel("Sexo:","right",0,yes,yes,0,yes,yes)
        fpad-check("M","yes",yes,no,"right",0,yes,no,0,yes,yes,"","")
        flabel("Masculino","left",0,no,yes,0,yes,yes)
        
        fpad-check("F","yes",yes,no,"right",0,yes,no,0,yes,yes,"","")
        flabel("Feminino","left",0,no,yes,0,yes,yes)


        fbranco(1,vpad-numcol)
        flabel("Status:","right",0,yes,yes,0,yes,yes)
        fpad-check("ativo","yes",yes,no,"right",0,yes,no,1,yes,yes,"","")
        flabel("Ativo","left",0,no,yes,0,yes,yes)

        fpad-check("morto","yes",yes,no,"right",0,yes,no,0,yes,yes,"","")
        flabel("Morto","left",0,no,yes,0,yes,yes)

        fpad-check("vendido","yes",yes,no,"right",0,yes,no,0,yes,yes,"","")
        flabel("Vendido","left",0,no,yes,0,yes,yes)


        fbranco(1,vpad-numcol)
        flabel("Data inicial:","right",0,yes,no,0,yes,yes)
        fpad-text("vdataini",10,10,get-value("vdataini"),"DT",no,"left",0,no,yes,0,yes,yes,"document.forms[0].submit();","")

        flabel("Data final:","right",0,yes,no,0,yes,yes)
        fpad-text("vdatafim",10,10,get-value("vdatafim"),"DT",no,"left",0,no,yes,0,yes,yes,"document.forms[0].submit();","")
    .
end procedure.

procedure p_disparar: 
    create tp-batweb.
    assign tp-batweb.batdes      = vpad-titulo
           tp-batweb.batprog     = vpad-programa
           tp-batweb.batpardc[1] = 2.2
           tp-batweb.batparlg    = yes
           tp-batweb.batpari     = int(get-value("vprop"))
           tp-batweb.batpari[2]  = int(get-value("vlote"))
           tp-batweb.batparc[1]  = vsexo
           tp-batweb.batparc[2]  = fstatus
           tp-batweb.batpardt[1] = today
           tp-batweb.batpardt[2] = date(get-value("vdataini"))
           tp-batweb.batpardt[3] = date(get-value("vdatafim")).
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
    def var vprop as int.

    assign vselect2 = ",<-- SELECIONE -->"
           vprop = int(get-value("vprop")).

    for each tlote no-lock where (vprop = 0 or tlote.prop = vprop) by tlote.nome:
        assign vselect2 = vselect2 + "," + string(tlote.codigo) + "," + tlote.nome.
    end.

    return vselect2.
end function.

procedure p_valida:
    def var vM       as log no-undo.
    def var vF       as log no-undo.
    def var vativo   as log no-undo.
    def var vmorto   as log no-undo.
    def var vvendido as log no-undo.

    assign vM       = (get-value("M")       = "yes")
           vF       = (get-value("F")       = "yes")
           vativo   = (get-value("ativo")   = "yes")
           vmorto   = (get-value("morto")   = "yes")
           vvendido = (get-value("vendido") = "yes").

    if not (vM or vF) then do:
        {wpaderro.i "erro" "'Nenhum sexo selecionado'"}
        return.
    end.

    if not (vativo or vmorto or vvendido) then do:
        {wpaderro.i "erro" "'Nenhum status selecionado'"}
        return.
    end.

    if vM then assign vsexo =         (if vsexo = "" then "" else ",") + "M".
    if vF then assign vsexo = vsexo + (if vsexo = "" then "" else ",") + "F".

    if vativo   then assign fstatus =           (if fstatus = "" then "" else ",") + "Ativo".
    if vmorto   then assign fstatus = fstatus + (if fstatus = "" then "" else ",") + "Morto".
    if vvendido then assign fstatus = fstatus + (if fstatus = "" then "" else ",") + "Vendido".

    if date(get-value("vdataini")) > date(get-value("vdatafim")) and date(get-value("vdatafim")) <> ? then do:
        {wpaderro.i "erro" "'Data inicial maior que data final'"}
    end.
end procedure.
