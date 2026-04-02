{webpro.i}
{wpadfunc.i}

def var vtpl        as class Template.
def var vpad-html   as longchar.

def var vcodigo-global as int no-undo.
def var vtabela-global as char no-undo.

def var vCriou as log.

def temp-table tt_func no-undo 
    like func
    field prop-nome as char
    field lote-nome as char
.

def temp-table tt_prop no-undo like prop.

def temp-table tt_lote no-undo 
    like tlote
    field prop-nome as char
.

def temp-table tt_animais no-undo like animais.

def temp-table tt_animal no-undo 
    like animal
    field animais-nome  as char
    field lote-nome     as char
    field prop-nome     as char
    field nasc-str      as char
.

def temp-table tt_ocorrencia no-undo 
    like ocorrencia
    field animal-nome   as char
    field func-nome     as char
    field lote-nome     as char
    field prop-nome     as char
    field data-str      as char
.

def temp-table tt_acesso no-undo 
    like acesso
    field prop-nome as char
    field data-str  as char
.

def dataset ds_tudo for tt_func, tt_prop, tt_lote, tt_animais, tt_animal, tt_ocorrencia, tt_acesso.

function fput           returns char(vjson as longchar) forward.
function fSemAcento     returns char (pcTexto as char) forwards.
function fMatch         returns log (campo as char, vpesq as char) forwards.
function fMatchProp     returns log (pcodigo as int, vpesq as char) forwards.
function fMatchLote     returns log (lcodigo as int, vpesq as char) forwards.
function fMatchAnimais  returns log (acodigo as int, vpesq as char) forwards.
function fFiltro        returns logical (vselect as char, campo as char, campo2 as char, campo3 as char, codigo as int, vpesq as char) forwards.
function fFiltro        returns log (vselect as char, campo as char, campo2 as char, campo3 as char, codigo as int, vpesq as char) forwards.

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

//todo --------- CRUD ---------------------------------------------
//? mostrar dados
procedure p_getDados:
    def var vjson       as longchar.
    def var vpesq       as char.
    def var vselect     as char.
    def var vcatO       as char.
    def var vcatA       as char.
    def var fstatusO    as char.
    def var fstatusA    as char.
    def var fstatusAn2  as char.
    def var vsexo       as char.
    def var visLote     as log.
    def var vprop       as int.
    def var pesqNome    as log.
    def var pesqCodigo  as log.
    def var pesqCargo   as log.
    def var pesqCriacao as log.

    assign 
        vpesq   = trim(url-decode(get-value("vpesq")))
        vselect = trim(get-value("vselect"))

        vprop   = int(get-value("vprop"))
        visLote = logical(get-value("visLote"))

        pesqNome    = (vselect = "nome")
        pesqCodigo  = (vselect = "codigo")
        pesqCargo   = (vselect = "cargo")
        pesqCriacao = (vselect = "criacao")

        vcatO       = get-value("selcatO")
        vcatA       = get-value("selcatA")
        fstatusO    = get-value("selstatusO")
        fstatusA    = get-value("selstatusA")
        fstatusAn2  = get-value("selstatusAn2")
        vsexo       = get-value("selsexoAn2") no-error
    .

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

    for each func no-lock,
            first prop  where prop.codigo   = func.prop no-lock,
            first tlote where tlote.codigo  = func.lote no-lock:

        if fFiltro(vselect, func.nome, func.cargo, "", func.codigo, vpesq) then
            run p_func.
        else if vselect = "lote" then do:
            if fMatchLote(func.lote, vpesq) then run p_func.
        end.
        else if vselect = "prop" then do:
            if fMatchProp(func.prop, vpesq) then run p_func.
        end.
    end.

    for each tlote no-lock,
            first prop where prop.codigo = tlote.prop no-lock:

        if visLote and tlote.prop <> vprop then next.

        if fFiltro(vselect, tlote.nome, "", "", tlote.codigo, vpesq) then
            run p_lote.
        else if vselect = "prop" then do:
            if fMatchProp(tlote.prop, vpesq) then run p_lote.
        end.
    end.

    for each animais no-lock:
        if fFiltro(vselect, animais.nome, "", "", animais.codigo, vpesq) then
            run p_animais.
    end.

    for each animal no-lock, 
            first tlote     where tlote.codigo   = animal.lote    no-lock,
            first prop      where prop.codigo    = animal.prop    no-lock,
            first animais   where animais.codigo = animal.animais no-lock:

        if vsexo      <> "" and animal.sexo     <> logical(vsexo) then next.
        if fstatusAn2 <> "" and animal.fstatus  <> fstatusAn2     then next.

        if fFiltro(vselect, animal.nome, "", "", animal.codigo, vpesq) then run p_animal.
        else if vselect = "lote" then do:
            if fMatchLote(animal.lote, vpesq) then run p_animal.
        end.
        else if vselect = "prop" then do:
            if fMatchProp(animal.prop, vpesq) then run p_animal.
        end.
        else if vselect = "especie" then do:
            if fMatchAnimais(animal.animais, vpesq) then run p_animal.
        end.
    end.

    for each acesso no-lock,
            first prop where prop.codigo = acesso.prop no-lock:

        if vcatA    <> "" and acesso.aprovado <> logical(vcatA)    then next.
        if fstatusA <> "" and acesso.fstatus  <> logical(fstatusA) then next.

        if fFiltro(vselect, acesso.nome-visitante, acesso.tipo-visitante, acesso.motivo, acesso.codigo, vpesq) then
            run p_acesso.
        else if vselect = "prop" then do:
            if fMatchProp(acesso.prop, vpesq) then run p_acesso.
        end.
    end.

    for each ocorrencia no-lock,
            first animal where animal.codigo = ocorrencia.animal no-lock,
            first func   where func.codigo   = ocorrencia.func   no-lock,
            first tlote  where tlote.codigo  = ocorrencia.lote   no-lock,
            first prop   where prop.codigo   = ocorrencia.prop   no-lock:

        if vcatO    <> "" and ocorrencia.categoria <> vcatO    then next.
        if fstatusO <> "" and ocorrencia.fstatus   <> fstatusO then next.

        if fFiltro(vselect, ocorrencia.descricao, "", "",ocorrencia.codigo, vpesq) then
            run p_ocorrencia.
        else if vselect = "lote" then do:
            if fMatchLote(ocorrencia.lote, vpesq) then run p_ocorrencia.
        end.
        else if vselect = "prop" then do:
            if fMatchProp(ocorrencia.prop, vpesq) then run p_ocorrencia.
        end.
    end.

    dataset ds_tudo:write-json("longchar", vjson, true).

    fput(vjson).
    quit.
end procedure.

//? criar tabela
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
            find last tlote no-lock no-error.
            if avail tlote
            then assign vcodigo = tlote.codigo + 1.

            create tlote.
            assign tlote.codigo = vcodigo.
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
    assign vCriou = true.
    run p_grava.

end procedure.

//? salvar dados na tabela
procedure p_grava:
    def var vtabela as char.
    def var vcodigo as int.
    def var hBuffer as handle.
    def var hField  as handle.
    def var i       as int.

    assign vtabela = get-value("vtabela").
    if vtabela = "" or vtabela = ? then assign vtabela = vtabela-global.
    if trim(get-value("vcodigo")) <> "" then do:
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
        when "L"  then vtabela = "tlote".
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

    create buffer hBuffer for table vtabela.
    hBuffer:FIND-FIRST("WHERE codigo = " + trim(string(vcodigo)), EXCLUSIVE-LOCK) no-error.

    if not hBuffer:avail then
        hBuffer:BUFFER-CREATE().

    do i = 1 to hBuffer:num-fields:
        assign hField = hBuffer:buffer-field(i).
        
        if hField:name = "codigo" or
          (hField:name = "nasc" and not vCriou)
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
            else if hField:name = "fstatus" and vCriou then do:
                case vtabela:
                    when "animal"     then assign hField:buffer-value = "Ativo".
                    when "acesso"     then assign hField:buffer-value = "Não realizado".
                    when "ocorrencia" then assign hField:buffer-value = "Aberto".
                end case.
            end.
            else if hfield:name = "aprovado" and vCriou then assign hField:buffer-value = "Não".
            else
                assign hField:buffer-value = trim(get-value(hField:name)).
        end.
    end.

    assign vCriou = false.
    hBuffer:BUFFER-RELEASE().
    delete object hBuffer.
end procedure.

//? procedures de excluir tabelas
procedure p_excluirP:
    def var vcodigo      as int.
    def var vPodeExcluir as log init true.

    if trim(get-value("vcodigo")) <> "" and trim(get-value("vcodigo")) <> ? then do:
        assign vcodigo = int(trim(get-value("vcodigo"))).
        if can-find(first tlote      where tlote.prop      = vcodigo) or
           can-find(first func       where func.prop       = vcodigo) or
           can-find(first animal     where animal.prop     = vcodigo) or
           can-find(first ocorrencia where ocorrencia.prop = vcodigo) or
           can-find(first acesso     where acesso.prop     = vcodigo) 
        then vPodeExcluir = false.
        
        find first prop where prop.codigo = vcodigo exclusive-lock no-error.
        if avail prop then do:
            if vPodeExcluir then delete prop.
            else {&out} "msg".
        end.
    end.
end procedure.

procedure p_excluirF:
    def var vcodigo      as int.
    def var vPodeExcluir as log init true.

    if trim(get-value("vcodigo")) <> "" and trim(get-value("vcodigo")) <> ? then do:
        assign vcodigo = int(trim(get-value("vcodigo"))).
        if can-find(first ocorrencia where ocorrencia.func = vcodigo) then vPodeExcluir = false.

        find first func where func.codigo = vcodigo exclusive-lock no-error.
        if avail func then do:
            if vPodeExcluir then delete func.
            else {&out} "msg".
        end.
    end.
end procedure.

procedure p_excluirL:
    def var vcodigo      as int.
    def var vPodeExcluir as log init true.

    if trim(get-value("vcodigo")) <> "" and trim(get-value("vcodigo")) <> ? then do:
        assign vcodigo = int(trim(get-value("vcodigo"))).
        if can-find(first func       where func.lote       = vcodigo) or
           can-find(first animal     where animal.lote     = vcodigo) or
           can-find(first ocorrencia where ocorrencia.lote = vcodigo) 
        then vPodeExcluir = false.

        find first tlote where tlote.codigo = vcodigo exclusive-lock no-error.
        if avail tlote then do:
            if vPodeExcluir then delete tlote.
            else {&out} "msg".
        end.
    end.
end procedure.

procedure p_excluirA:
    def var vcodigo as int.

    if trim(get-value("vcodigo")) <> "" and trim(get-value("vcodigo")) <> ? then do:
        assign vcodigo = int(trim(get-value("vcodigo"))).
        find first acesso where acesso.codigo = vcodigo exclusive-lock no-error.
        if avail acesso then delete acesso.
    end.
end procedure.

procedure p_excluirO:
    def var vcodigo as int.

    if trim(get-value("vcodigo")) <> "" and trim(get-value("vcodigo")) <> ? then do:
        assign vcodigo = int(trim(get-value("vcodigo"))).
        find first ocorrencia where ocorrencia.codigo = vcodigo exclusive-lock no-error.
        if avail ocorrencia then delete ocorrencia.
    end.
end procedure.

procedure p_excluirAn:
    def var vcodigo      as int.
    def var vPodeExcluir as log init true.
    def var vsubtabela   as char.

    assign vsubtabela = trim(get-value("vsubtabela")).

    case vsubtabela:
        when "An1" 
        then do:
            if trim(get-value("vcodigo")) <> "" and trim(get-value("vcodigo")) <> ? then do:
                assign vcodigo = int(trim(get-value("vcodigo"))).
                if can-find(first animal where animal.animais = vcodigo) then vPodeExcluir = false.
                
                find first animais where animais.codigo = vcodigo exclusive-lock no-error.
                if avail animais then do:
                    if vPodeExcluir then delete animais.
                    else {&out} "msg".
                end.
            end.
        end.
        when "An2" 
        then do:
            if trim(get-value("vcodigo")) <> "" and trim(get-value("vcodigo")) <> ? then do:
                assign vcodigo = int(trim(get-value("vcodigo"))).
                if can-find(first ocorrencia where ocorrencia.animal = vcodigo) then vPodeExcluir = false.
                
                find first animal where animal.codigo = vcodigo exclusive-lock no-error.
                if avail animal then do:
                    if vPodeExcluir then delete animal.
                    else {&out} "msg".
                end.
            end.
        end.
    end case.
end procedure.

//todo --------- TEMP-TABLES -----------------------------------------
procedure p_func:
    create tt_func.
    buffer-copy func to tt_func.

    if avail prop then
        tt_func.prop-nome = prop.nome.

    if avail tlote then
        tt_func.lote-nome = tlote.nome.
end procedure.

procedure p_prop:
    create tt_prop.
    buffer-copy prop to tt_prop.
end procedure.

procedure p_lote:
    create tt_lote.
    buffer-copy tlote to tt_lote.

    if avail prop then
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

    if avail tlote then
        tt_animal.lote-nome = tlote.nome.
    if avail prop then
        tt_animal.prop-nome = prop.nome.
    if avail animais then
        tt_animal.animais-nome = animais.nome.
end procedure.

procedure p_ocorrencia:
    create tt_ocorrencia.
    buffer-copy ocorrencia to tt_ocorrencia.
    assign tt_ocorrencia.data-str = STRING(ocorrencia.data, "99/99/9999").

    if avail animal then
        tt_ocorrencia.animal-nome = animal.nome.

    if avail func then
        tt_ocorrencia.func-nome = func.nome.

    if avail tlote then
        tt_ocorrencia.lote-nome = tlote.nome.

    if avail prop then
        tt_ocorrencia.prop-nome = prop.nome.
end procedure.

procedure p_acesso:
    create tt_acesso.
    buffer-copy acesso to tt_acesso.
    assign tt_acesso.data-str = STRING(acesso.data, "99/99/9999").

    if avail prop then
        tt_acesso.prop-nome = prop.nome.
end procedure.

//todo --------- FUNÇÕES -----------------------------------------
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

//todo --------- PESQUISA -------------------------------------------
//? formata textos sem acento (pra pesquisa)
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

//? compara strings (se substring vpesq existe dentro da string campo)
function fMatch returns log (campo as char, vpesq as char):
    return index(fSemAcento(campo), fSemAcento(vpesq)) > 0.
end function.

//? pesquisa a prop vinculada
function fMatchProp returns log (pcodigo as int, vpesq as char):
    find first prop where prop.codigo = pcodigo no-lock no-error.
    if avail prop then return fMatch(prop.nome, vpesq).
    return false.
end function.

//? pesquisa o lote vinculado
function fMatchLote returns log (lcodigo as int, vpesq as char):
    find first tlote where tlote.codigo = lcodigo no-lock no-error.
    if avail tlote then return fMatch(tlote.nome, vpesq).
    return false.
end function.

//? pesquisa a especie vinculada
function fMatchAnimais returns log (acodigo as int, vpesq as char):
    find first animais where animais.codigo = acodigo no-lock no-error.
    if avail animais then return fMatch(animais.nome, vpesq).
    return false.
end function.

//? pesquisa principal (com select e input)
function fFiltro returns logical (vselect as char, campo as char, campo2 as char, campo3 as char, codigo as int, vpesq as char):
    if vpesq = "" then return true.

    if vselect = "codigo" then do:
        def var vnum as int no-undo.
        assign  vnum = int(vpesq) no-error.
        if error-status:error then
            return false. 
        return codigo >= vnum.
    end.

    else if vselect = "nome" or vselect = "descricao" then return fMatch(campo, vpesq).

    else if vselect = "cargo" or vselect = "criacao" or vselect = "tipo" then return fMatch(campo2, vpesq).

    else if vselect = "motivo" then return fMatch(campo3, vpesq).
    
    else return false.
end function.
