{webpro.i "liberado"}
{wpadfunc.i}

procedure output-header:
    flista("add","vper-chave","dliCbdcbSvbNadud").
    flista("add","vpad-radio", get-value("vpad-radio")).
end procedure.

{wpadgraf.i}

procedure p_setvalue:
end procedure.

procedure p_load:        

    def var vprop    as int  no-undo.
    def var vdataini as char no-undo.
    def var vdatafim as char no-undo.
    def var dIni     as date no-undo.
    def var dFim     as date no-undo.

    vprop    = int(get-value("prop")) no-error.
    vdataini = get-value("dataini").
    vdatafim = get-value("datafim").

    if vdataini <> "" then
    dIni = date(int(substr(vdataini,6,2)),  
                int(substr(vdataini,9,2)),  
                int(substr(vdataini,1,4))).

    if vdatafim <> "" then
    dFim = date(int(substr(vdatafim,6,2)),
                int(substr(vdatafim,9,2)),
                int(substr(vdatafim,1,4))).

    def var cont      as int.
    def var vgra-bars as class GPadBars.
    def var temDados1 as log no-undo.

    vgra-bars = new GPadBars(1,"Ocorrências por Categoria","49.5%","70%").
    vgra-bars:setSubtitle("").
    vgra-bars:setLabel(false).

    for each ocorrencia no-lock
        where ocorrencia.prop = vprop
        and (dIni = ? or ocorrencia.data >= dIni)
        and (dFim = ? or ocorrencia.data <= dFim)
        break by ocorrencia.categoria:

        temDados1 = true.
        cont = cont + 1.

        if last-of(ocorrencia.categoria) then do:
            vgra-bars:setValue(ocorrencia.categoria, cont).
            cont = 0.
        end.
    end.

    if not temDados1 then do:
        vgra-bars:setValue("Sem dados", 0).
    end.
    vpad-grafico:add(vgra-bars).



    def var vgra-lines as class GPadLines.
    def var vmes       as int.
    def var vano       as int.
    def var vlabel     as char.
    def var cont2      as int.
    def var temDados2  as log no-undo.

    assign vgra-lines = new GPadLines(2,"Ocorrências por Período","49.5%","70%").
    vgra-lines:setSubtitle("").
    vgra-lines:setLabel(false).
    vgra-lines:setPointVisible(true).
    vgra-lines:setLegendBottom(true).
    vgra-lines:setExport().
    vgra-lines:setSeries("OC","Ocorrências").

    for each ocorrencia no-lock where ocorrencia.prop = vprop and (dIni = ? or ocorrencia.data >= dIni)
        and (dFim = ? or ocorrencia.data <= dFim)
        break by year(ocorrencia.data)
            by month(ocorrencia.data):
        temDados2 = true.
        cont2 = cont2 + 1.

        if last-of(month(ocorrencia.data)) then do:
            vano   = year(ocorrencia.data).
            vmes   = month(ocorrencia.data).
            vlabel = string(vmes,"99") + "/" + string(vano).
            vgra-lines:addSeries(vlabel).
            vgra-lines:setValue("OC", cont2).
            cont2 = 0.
        end.
    end.
    if not temDados2 then do:
        vgra-lines:addSeries("Sem dados").
        vgra-lines:setValue("OC", 0).
    end.
    vpad-grafico:add(vgra-lines).


    def var vgra-doughnuts as class GPadDoughnut.
    def var cont4          as int.
    def var vtotal         as int.
    def var temDados4      as log no-undo.
    assign vgra-doughnuts = new GPadDoughnut(3,"Distribuição por Sexo","49.5%","70%").
    vgra-doughnuts:setSubtitle("Animais").
    vgra-doughnuts:setLabel(true).
    vgra-doughnuts:setExport().
    vgra-doughnuts:setDisableLegend().
    vgra-doughnuts:setLegendBottom(false).
    vgra-doughnuts:setSeries("CA1","Animais").

    for each animal no-lock where animal.prop = vprop and animal.fstatus =  "Ativo":
        vtotal = vtotal + 1.
    end.

    for each animal no-lock where animal.prop = vprop and animal.fstatus =  "Ativo"
        break by animal.sexo:
        temDados4 = true.
        cont4 = cont4 + 1.

        if last-of(animal.sexo) then do:
            vgra-doughnuts:addSeries(if animal.sexo then "Masculino" else "Feminino").
            if vtotal > 0 then
                vgra-doughnuts:setValue("CA1", cont4 / vtotal).
            cont4 = 0.
        end.
    end.
    if not temDados4 then do:
        vgra-doughnuts:addSeries("Sem dados").
        vgra-doughnuts:setValue("CA1",0).
    end.
    vpad-grafico:add(vgra-doughnuts).



    def var cont5     as int.
    def var temDados5 as log no-undo.
    assign vgra-bars = new GPadBars(4,"Capacidade VS Ocupação dos Lotes","49.5%","70%").
    vgra-bars:setSubtitle("").
    vgra-bars:setRotate(false).
    vgra-bars:setLabel(true).
    vgra-bars:setExport().
    vgra-bars:setLabelAngle(0).
    vgra-bars:setDecimals(0).
    vgra-bars:setDisableLegend().
    vgra-bars:setTooltipInfo(3).
    vgra-bars:setLegendBottom(false).
    vgra-bars:setSeries("CA1","Capacidade").
    vgra-bars:setSeries("CA2","Ocupação").

    for each tlote no-lock where tlote.prop = vprop:
        temDados5 = true.
        cont5 = 0.

        for each animal no-lock where animal.prop = vprop
            and animal.lote = tlote.codigo and animal.fstatus =  "Ativo":
            cont5 = cont5 + 1.
        end.

        vgra-bars:addSeries(tlote.nome).
        vgra-bars:setValue("CA1", tlote.capacidade).
        vgra-bars:setValue("CA2", cont5).
    end.
        
    if not temDados5 then do:
        vgra-bars:addSeries("Sem dados").
        vgra-bars:setValue("CA1", 0).
        vgra-bars:setValue("CA2", 0).
    end.
    vpad-grafico:add(vgra-bars).



    def var cont3     as int.
    def var temDados3 as log no-undo.

    vgra-bars = new GPadBars(5,"Acessos por Tipo de Visitante","49.5%","70%").
    vgra-bars:setSubtitle("").
    vgra-bars:setLabel(false).

    for each acesso no-lock where acesso.prop = vprop 
        and (dIni = ? or acesso.data >= dIni)
        and (dFim = ? or acesso.data <= dFim)
        break by acesso.tipo-visitante:
        temDados3 = true.
        cont3 = cont3 + 1.

        if last-of(acesso.tipo-visitante) then do:
            vgra-bars:setValue(acesso.tipo-visitante, cont3).
            cont3 = 0.
        end.
    end.
    
    if not temDados3 then vgra-bars:setValue("Sem dados",0).
    vpad-grafico:add(vgra-bars).



    def var temDados6 as log no-undo.
    def var cont6     as int.
    assign vgra-lines = new GPadLines(6,"Visitantes por Período","49.5%","70%").
    vgra-lines:setSubtitle("").
    vgra-lines:setLabel(false).
    vgra-lines:setPointVisible(true).
    vgra-lines:setLegendBottom(true).
    vgra-lines:setExport().
    vgra-lines:setSeries("VI","Visitantes").

    for each acesso no-lock where acesso.prop = vprop and (dIni = ? or acesso.data >= dIni)
        and (dFim = ? or acesso.data <= dFim)
        break by year(acesso.data)
            by month(acesso.data):
        temDados6 = true.
        cont6 = cont6 + 1.

        if last-of(month(acesso.data)) then do:
            vano   = year(acesso.data).
            vmes   = month(acesso.data).
            vlabel = string(vmes,"99") + "/" + string(vano).
            vgra-lines:addSeries(vlabel).
            vgra-lines:setValue("VI", cont6).
            cont6 = 0.
        end.
    end.

    if not temDados6 then do:
        vgra-lines:addSeries("Sem dados").
        vgra-lines:setValue("VI", 0).
    end.
    vpad-grafico:add(vgra-lines).
end procedure.
