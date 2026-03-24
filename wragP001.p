{webpro.i}
{wpadfunc.i}

def var vtpl as class Template.
def var vpad-html as longchar.
def var vcodigo-global as int no-undo.
def var vtabela-global as char no-undo.
def var criou as log.
def temp-table tt_func no-undo 
    like func
    field prop-nome as char
    field lote-nome as char.
def temp-table tt_prop no-undo like prop.
def temp-table tt_lote no-undo 
    like vlote
    field prop-nome as char.
def temp-table tt_animais no-undo like animais.
def temp-table tt_animal no-undo 
    like animal
    field animais-nome as char
    field lote-nome as char
    field prop-nome as char
    field nasc-str as char.
def temp-table tt_ocorrencia no-undo 
    like ocorrencia
    field animal-nome as char
    field func-nome as char
    field lote-nome as char
    field prop-nome as char
    field data-str as char.
def temp-table tt_acesso no-undo 
    like acesso
    field prop-nome as char
    field data-str as char.
def dataset ds_tudo for tt_func, tt_prop, tt_lote, tt_animais, tt_animal, tt_ocorrencia, tt_acesso.

function fput returns char(vjson as longchar) forward.

procedure output-header:
end procedure.

run p_load_html.
run p_replace_html.
run p_show_html.

procedure p_load_html:
    copy-lob file "/agroweb/templates/wragP001.tpl" to vpad-html.
    assign vtpl = new Template(vpad-html).
end procedure.

procedure p_replace_html:
    vtpl:troca("[cache]", string(today, "99999999") + string(time, "999999")).
    vtpl:block("BLOCK_CACHE").
end procedure.

procedure p_show_html:
    vtpl:show().
end procedure.

function fSemAcento returns char (pcTexto as char):
    assign pcTexto = replace(pcTexto, "á","a").
    assign pcTexto = replace(pcTexto, "à","a").
    assign pcTexto = replace(pcTexto, "ã","a").
    assign pcTexto = replace(pcTexto, "â","a").
    assign pcTexto = replace(pcTexto, "ä","a").
    assign pcTexto = replace(pcTexto, "é","e").
    assign pcTexto = replace(pcTexto, "ê","e").
    assign pcTexto = replace(pcTexto, "è","e").
    assign pcTexto = replace(pcTexto, "ë","e").
    assign pcTexto = replace(pcTexto, "í","i").
    assign pcTexto = replace(pcTexto, "ì","i").
    assign pcTexto = replace(pcTexto, "ï","i").
    assign pcTexto = replace(pcTexto, "ó","o").
    assign pcTexto = replace(pcTexto, "ô","o").
    assign pcTexto = replace(pcTexto, "õ","o").
    assign pcTexto = replace(pcTexto, "ò","o").
    assign pcTexto = replace(pcTexto, "ö","o").
    assign pcTexto = replace(pcTexto, "ú","u").
    assign pcTexto = replace(pcTexto, "ù","u").
    assign pcTexto = replace(pcTexto, "ü","u").
    assign pcTexto = replace(pcTexto, "ç","c").
    return pcTexto.
end function.

function fMatch returns logical (campo as char, vpesq as char):
    return upper(fSemAcento(campo)) matches ("*" + vpesq + "*").
end function.

function fFiltro returns logical (vselect as char, campo as char, campo2 as char, campo3 as char, codigo as int, vpesq as char):
    if vpesq = "" then return true.

    if vselect = "codigo" then do:
        def var vnum as int no-undo.
        assign vnum = int(vpesq) no-error.
        if error-status:error then
            return false. 
        return codigo >= vnum.
    end.

    else if vselect = "nome" or vselect = "descricao" then return fMatch(campo, vpesq).

    else if vselect = "cargo" or vselect = "criacao" or vselect = "tipo" then return fMatch(campo2, vpesq).

    else if vselect = "motivo" then return fMatch(campo3, vpesq).
    
    else return false.
end function.

procedure p_getDados:
    def var vjson   as longchar.
    def var vpesq   as char.
    def var vselect as char.
    def var vcatO    as char.
    def var vcatA    as char.
    def var vstatusO as char.
    def var vstatusA as char.
    def var vstatusAn2 as char.
    def var vsexo   as char.
    def var visLote as log.
    def var vprop as int.
    def var pesqNome   as log.
    def var pesqCodigo as log.
    def var pesqCargo as log.
    def var pesqCriacao as log.

    assign 
        vpesq = upper(trim(url-decode(get-value("vpesq"))))
        vpesq = fSemAcento(vpesq)
        vselect = trim(get-value("vselect"))

        vprop = int(get-value("vprop"))
        visLote = logical(get-value("visLote"))

        pesqNome   = (vselect = "nome")
        pesqCodigo = (vselect = "codigo")
        pesqCargo = (vselect = "cargo")
        pesqCriacao = (vselect = "criacao")

        vcatO    = get-value("selcatO")
        vcatA    = get-value("selcatA")
        vstatusO = get-value("selstatusO")
        vstatusA = get-value("selstatusA")
        vstatusAn2 = get-value("selstatusAn2")
        vsexo   = get-value("selsexoAn") no-error.

    empty temp-table tt_func.
    empty temp-table tt_prop.
    empty temp-table tt_lote.
    empty temp-table tt_animais.
    empty temp-table tt_animal.
    empty temp-table tt_ocorrencia.
    empty temp-table tt_acesso.

    for each prop no-lock:
        if fFiltro(vselect, prop.nome, prop.criacao, "", prop.codigo, vpesq) then
            run p_prop.
    end.

    for each func no-lock:
        if fFiltro(vselect, func.nome, func.cargo, "", func.codigo, vpesq) then
            run p_func.
        else if vselect = "lote" then do:
            find first vlote where vlote.codigo = func.lote no-lock no-error.
            if available vlote and fMatch(vlote.nome, vpesq) then
                run p_func.
        end.
        else if vselect = "prop" then do:
            find first prop where prop.codigo = func.prop no-lock no-error.
            if available prop and fMatch(prop.nome, vpesq) then
                run p_func.
        end.
    end.

    for each vlote no-lock:
        if visLote and vlote.prop <> vprop then next.

        if fFiltro(vselect, vlote.nome, "", "", vlote.codigo, vpesq) then
            run p_lote.
        else if vselect = "prop" then do:
            find first prop where prop.codigo = vlote.prop no-lock no-error.
            if available prop and fMatch(prop.nome, vpesq) then
                run p_lote.
        end.
    end.

    for each animais no-lock:
        if fFiltro(vselect, animais.nome, "", "", animais.codigo, vpesq) then
            run p_animais.
    end.

    for each animal no-lock:
        if vsexo <> "" and animal.sexo <> logical(vsexo) then next.
        if vstatusAn2 <> "" and animal.vstatus <> vstatusAn2 then next.

        if fFiltro(vselect, animal.nome, "", "", animal.codigo, vpesq) then
            run p_animal.
        else if vselect = "lote" then do:
            find first vlote where vlote.codigo = animal.lote no-lock no-error.
            if available vlote and fMatch(vlote.nome, vpesq) then
                run p_animal.
        end.
        else if vselect = "prop" then do:
            find first prop where prop.codigo = animal.prop no-lock no-error.
            if available prop and fMatch(prop.nome, vpesq) then
                run p_animal.
        end.
        else if vselect = "especie" then do:
            find first animais where animais.codigo = animal.animais no-lock no-error.
            if available animais and fMatch(animais.nome, vpesq) then
                run p_animal.
        end.
    end.

    for each acesso no-lock:
        if vcatA <> "" and acesso.aprovado <> logical(vcatA) then next.
        if vstatusA <> "" and acesso.vstatus <> logical(vstatusA) then next.

        if fFiltro(vselect, acesso.nome-visitante, acesso.tipo-visitante, acesso.motivo, acesso.codigo, vpesq) then
            run p_acesso.
        else if vselect = "prop" then do:
            find first prop where prop.codigo = acesso.prop no-lock no-error.
            if available prop and fMatch(prop.nome, vpesq) then
                run p_acesso.
        end.
    end.

    for each ocorrencia no-lock:
        if vcatO <> "" and ocorrencia.categoria <> vcatO then next.
        if vstatusO <> "" and ocorrencia.vstatus <> vstatusO then next.

        if fFiltro(vselect, ocorrencia.descricao, "", "",ocorrencia.codigo, vpesq) then
            run p_ocorrencia.
        else if vselect = "lote" then do:
            find first vlote where vlote.codigo = ocorrencia.lote no-lock no-error.
            if available vlote and fMatch(vlote.nome, vpesq) then
                run p_ocorrencia.
        end.
        else if vselect = "prop" then do:
            find first prop where prop.codigo = ocorrencia.prop no-lock no-error.
            if available prop and fMatch(prop.nome, vpesq) then
                run p_ocorrencia.
        end.
    end.


    dataset ds_tudo:write-json("longchar", vjson, true).

    fput(vjson).
    quit.

end procedure.

function fput returns char (vjson as longchar):
    def var vcont as int.
    def var vnum as int init 1.

    if length(vjson) > 30000
    then do vcont = 1 to trunc(length(vjson) / 30000,0) + 1.
        {&out} string(substring(vjson,vnum,30000)).
        assign vnum = vnum + 30000.
    end.
    else {&out} string(vjson).
end function.

procedure p_criareg:
    def var vcodigo as int init 1. 
    def var vtabela as char.
    assign vtabela = trim(get-value("vtabela")).

    case vtabela:
        when "P" then do:
            find last prop no-lock no-error.
            if avail prop
            then assign vcodigo = prop.codigo + 1.

            create prop.
            assign prop.codigo = vcodigo.
        end.
        when "F" then do:
            find last func no-lock no-error.
            if avail func
            then assign vcodigo = func.codigo + 1.

            create func.
            assign func.codigo = vcodigo.
        end.
        when "A" then do:
            find last acesso no-lock no-error.
            if avail acesso
            then assign vcodigo = acesso.codigo + 1.

            create acesso.
            assign acesso.codigo = vcodigo.
        end.
        when "O" then do:
            find last ocorrencia no-lock no-error.
            if avail ocorrencia
            then assign vcodigo = ocorrencia.codigo + 1.

            create ocorrencia.
            assign ocorrencia.codigo = vcodigo.
        end.
        when "L" then do:
            find last vlote no-lock no-error.
            if avail vlote
            then assign vcodigo = vlote.codigo + 1.

            create vlote.
            assign vlote.codigo = vcodigo.
        end.
        when "An" then do:
            def var vsubtabela as char.
            assign vsubtabela = trim(get-value("vsubtabela")).
            case vsubtabela:
                when "An1" then do:
                    find last animais no-lock no-error.
                    if avail animais
                    then assign vcodigo = animais.codigo + 1.

                    create animais.
                    assign animais.codigo = vcodigo.
                end.
                when "An2" then do:
                    find last animal no-lock no-error.
                    if avail animal
                    then assign vcodigo = animal.codigo + 1.

                    create animal.
                    assign animal.codigo = vcodigo.
                end.
            end case.
        end.
    end case.

    assign vcodigo-global = vcodigo.
    assign vtabela-global = trim(get-value("vtabela")).
    assign criou = true.
    run p_grava.

end procedure.

procedure p_grava:
    def var vtabela as char.
    def var vcodigo as int.
    def var hBuffer as handle.
    def var hField  as handle.
    def var i       as int.

    assign vtabela = get-value("vtabela").
    if vtabela = "" or vtabela = ?
    then assign vtabela = vtabela-global.
    if trim(get-value("vcodigo")) <> "" 
    then do:
        def var vtest as int no-undo.
        assign vtest = integer(trim(get-value("vcodigo"))) no-error.
        if not error-status:error
        then assign vcodigo = vtest.
        else assign vcodigo = vcodigo-global.
    end.
    else assign vcodigo = vcodigo-global.

    case vtabela:
        when "F"  then vtabela = "func".
        when "P"  then vtabela = "prop".
        when "L"  then vtabela = "vlote".
        when "An" then do:
            def var vsubtabela as char.
            assign vsubtabela = trim(get-value("vsubtabela")).
            case vsubtabela:
                when "An1" then vtabela = "animais".
                when "An2" then vtabela = "animal".
            end case.
        end.
        when "O"  then vtabela = "ocorrencia".
        when "A"  then vtabela = "acesso".
    end case.
    {&out} vtabela.
    create buffer hBuffer for table vtabela.


    hBuffer:FIND-FIRST("WHERE codigo = " + trim(string(vcodigo)), EXCLUSIVE-LOCK) no-error.

    if not hBuffer:AVAILABLE then
        hBuffer:BUFFER-CREATE().

    do i = 1 to hBuffer:num-fields:
        assign hField = hBuffer:buffer-field(i).
        
        if hField:name = "codigo" or
           (hField:name = "nasc" and not criou)
           then next.
        
        if trim(get-value(hField:name)) <> "" then do:
            if hField:data-type = "date" then do:
                def var vdata as char no-undo.
                assign vdata = trim(get-value(hField:name)).
                assign hField:buffer-value = date(
                    int(substring(vdata,6,2)),
                    int(substring(vdata,9,2)),
                    int(substring(vdata,1,4))
                ).
            end.
            else if hField:name = "vstatus" and criou then do:
                case vtabela:
                    when "animal" then assign hField:buffer-value = "Ativo".
                    when "acesso" then assign hField:buffer-value = "Não realizado".
                    when "ocorrencia" then assign hField:buffer-value = "Aberto".
                end case.
            end.
            else if hfield:name = "aprovado" and criou then assign hField:buffer-value = "Não".
            else
                assign hField:buffer-value = trim(get-value(hField:name)).
        end.
    end.

    assign criou = false.
    hBuffer:BUFFER-RELEASE().
    delete object hBuffer.

end procedure.

procedure p_excluir:
    def var vtabela   as char.
    def var vsubtabela as char.
    def var vcodigo   as int.
    def var hBuffer   as handle.
    def var vPodeExcluir as log init true.

    assign vtabela    = trim(get-value("vtabela")).
    assign vsubtabela = trim(get-value("vsubtabela")).

    if trim(get-value("vcodigo")) <> "" and trim(get-value("vcodigo")) <> ?
    then assign vcodigo = int(trim(get-value("vcodigo"))).
    else assign vcodigo = 0.

    case vtabela:
        when "F" then do:
            vtabela = "func".
            if can-find(first ocorrencia where ocorrencia.func = vcodigo) then vPodeExcluir = false.
        end.
        when "P" then do:
            vtabela = "prop".
            if can-find(first vlote where vlote.prop = vcodigo) or
               can-find(first func where func.prop = vcodigo) or
               can-find(first animal where animal.prop = vcodigo) or
               can-find(first ocorrencia where ocorrencia.prop = vcodigo) or
               can-find(first acesso where acesso.prop = vcodigo) then vPodeExcluir = false.
        end.
        when "L" then do:
            vtabela = "vlote".
            if can-find(first func where func.lote = vcodigo) or
               can-find(first animal where animal.lote = vcodigo) or
               can-find(first ocorrencia where ocorrencia.lote = vcodigo) 
            then vPodeExcluir = false.
        end.
        when "O"  then vtabela = "ocorrencia".
        when "A"  then vtabela = "acesso".
        when "An" then do:
            case vsubtabela:
                when "An1" then do:
                    vtabela = "animais".
                    if can-find(first animal where animal.animais = vcodigo) then vPodeExcluir = false.
                end.
                when "An2" then do:
                    vtabela = "animal".
                    if can-find(first ocorrencia where ocorrencia.animal = vcodigo) then vPodeExcluir = false.
                end.
            end case.
        end.
    end case.

    create buffer hBuffer for table vtabela.

    do transaction:
        if vcodigo > 0 then
            hBuffer:FIND-FIRST("WHERE codigo = " + string(vcodigo), EXCLUSIVE-LOCK) no-error.

        if hBuffer:AVAILABLE then do:
            if vPodeExcluir then
                hBuffer:BUFFER-DELETE().
            else
                {&out} "msg".
        end.
    end.

    delete object hBuffer.
end procedure.

procedure p_func:
    create tt_func.
    buffer-copy func to tt_func.

    find first prop where prop.codigo  = func.prop  no-lock no-error.
    if available prop then
        tt_func.prop-nome = prop.nome.

    find first vlote where vlote.codigo = func.lote no-lock no-error.
    if available vlote then
        tt_func.lote-nome = vlote.nome.
end procedure.

procedure p_prop:
    create tt_prop.
    buffer-copy prop to tt_prop.
end procedure.

procedure p_lote:
    create tt_lote.
    buffer-copy vlote to tt_lote.

    find first prop where prop.codigo = vlote.prop no-lock no-error.
    if available prop then
        tt_lote.prop-nome = prop.nome.
end procedure.

procedure p_animais:
    def var vqtd as int no-undo.
    assign vqtd = 0.

    for each animal no-lock
        where animal.animais = animais.codigo:
        vqtd = vqtd + 1.
    end.

    create tt_animais.
    buffer-copy animais to tt_animais.
    assign tt_animais.qtd = vqtd.
end procedure.

procedure p_animal:
    create tt_animal.
    buffer-copy animal to tt_animal.
    assign tt_animal.nasc-str = STRING(animal.nasc, "99/99/9999").

    find first vlote where vlote.codigo = animal.lote no-lock no-error.
    if available vlote then
        tt_animal.lote-nome = vlote.nome.

    find first prop where prop.codigo = animal.prop no-lock no-error.
    if available prop then
        tt_animal.prop-nome = prop.nome.
    find first animais where animais.codigo = animal.animais no-lock no-error.
    if available animais then
        tt_animal.animais-nome = animais.nome.
end procedure.

procedure p_ocorrencia:
    create tt_ocorrencia.
    buffer-copy ocorrencia to tt_ocorrencia.
    assign tt_ocorrencia.data-str = STRING(ocorrencia.data, "99/99/9999").

    find first animal where animal.codigo = ocorrencia.animal no-lock no-error.
    if available animal then
        tt_ocorrencia.animal-nome = animal.nome.

    find first func where func.codigo = ocorrencia.func no-lock no-error.
    if available func then
        tt_ocorrencia.func-nome = func.nome.

    find first vlote where vlote.codigo = ocorrencia.lote no-lock no-error.
    if available vlote then
        tt_ocorrencia.lote-nome = vlote.nome.

    find first prop where prop.codigo = ocorrencia.prop no-lock no-error.
    if available prop then
        tt_ocorrencia.prop-nome = prop.nome.
end procedure.

procedure p_acesso:
    create tt_acesso.
    buffer-copy acesso to tt_acesso.
    assign tt_acesso.data-str = STRING(acesso.data, "99/99/9999").

    find first prop where prop.codigo = acesso.prop no-lock no-error.
    if available prop then
        tt_acesso.prop-nome = prop.nome.
end procedure.
