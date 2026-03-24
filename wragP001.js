var S = '?';
var url_atual = '';
var inputZoom = null;

//todo --------- BASICO --------------------------------------------------
const state = {
    tab: "P",
    subTab: "An1",
    vselect: "codigo",
    delay: null
}

//? inicial
$(document).ready(function() {
    url_atual = replaceAll(window.location.href, '#','');

    $('.tabs[data-group="main"][data-tab="P"]').click();

    if (window.location.href.indexOf("?") != 1) 
        S = "&";
    fpesquisar();

    $("#valorpesq").on("keyup", function() {
        clearTimeout(state.delay);

        state.delay = setTimeout(fpesquisar, 400);
    });
});


//todo --------- TABS -----------------------------------------------------
//? config tabs
const config = {
    P: {
        getTable: () => $("#contentP tbody"),
        render: (t,d) => renderGeneric(t, d.ds_tudo.tt_prop, [
            { key: "codigo", class: "colunapequena" },
            { key: "nome", class: "alignleft" },
            { key: "criacao", class: "alignleft" }
        ]),
        show: ["#selP", "#valorpesq"],
        hide: ["#selectsEspecificos", "#selF", "#selL", "#selAn1", "#selAn2", "#selA", "#selO", "#selG"]
    },
    F: {
        getTable: () => $("#contentF tbody"),
        render: (t,d) => renderGeneric(t, d.ds_tudo.tt_func, [
            { key: "codigo", class: "colunapequena" },
            { key: "nome", class: "alignleft" },
            { key: "cpf"},
            { key: "cargo", class: "alignleft" },
            { key: "fone"},
            { key: "email"},
            { class: "alignleft", fn: (d) => `${d["lote"] == 0 ? "" : d["lote"]} - ${d["lote-nome"]}`},
            { class: "alignleft", fn: (d) => `${d["prop"]} - ${d["prop-nome"]}`}
        ]),
        show: ["#selF", "#valorpesq"],
        hide: ["#selectsEspecificos", "#selP", "#selL", "#selAn1", "#selAn2", "#selA", "#selO", "#selG"]
    },
    L: {
        getTable: () => $("#contentL tbody"),
        render: (t,d) => renderGeneric(t, d.ds_tudo.tt_lote, [
            { key: "codigo", class: "colunapequena" },
            { key: "nome", class: "alignleft" },
            { key: "capacidade"},
            { class: "alignleft", fn: (d) => `${d["prop"]} - ${d["prop-nome"]}`}
        ]),
        show: ["#selL", "#valorpesq"],
        hide: ["#selectsEspecificos", "#selP", "#selF", "#selAn1", "#selAn2", "#selA", "#selO", "#selG"]
    },
    O: {
        getTable: () => $("#contentO tbody"),
        render: (t,d) => renderGeneric(t, d.ds_tudo.tt_ocorrencia, [
            { key: "codigo", class: "colunapequena" },
            { key: "categoria", class: "alignleft" },
            { key: "descricao", class: "alignleft"},
            { class: "alignleft", fn: (d) => `${d["animal"]} - ${d["animal-nome"]}`},
            { key: "func-nome", class: "alignleft" },
            { key: "data-str"},
            { key: "vstatus"},
            { class: "alignleft", fn: (d) => `${d["lote"]} - ${d["lote-nome"]}`},
            { class: "alignleft", fn: (d) => `${d["prop"]} - ${d["prop-nome"]}`}
        ]),
        show: ["#selO", "#valorpesq", "#selectO", "#selectsEspecificos"],
        hide: ["#selP", "#selL", "#selAn1", "#selAn2", "#selA", "#selF", "#selG","#selectA", "#selectAn", "#selectAn2", "#selectG"]
    },
    A: {
        getTable: () => $("#contentA tbody"),
        render: (t,d) => renderGeneric(t, d.ds_tudo.tt_acesso, [
            { key: "codigo", class: "colunapequena" },
            { key: "nome-visitante", class: "alignleft"},
            { key: "tipo-visitante", class: "alignleft"},
            { key: "motivo", class: "alignleft"},
            { key: "data-str"},
            { key: "hora"},
            { fn: (d) => `${d["aprovado"] ? "Sim" : "Não"}`},
            { fn: (d) => `${d["vstatus"] ? "Realizado" : "Não realizado"}`},
            { class: "alignleft", fn: (d) => `${d["prop"]} - ${d["prop-nome"]}`}
        ]),
        show: ["#selA", "#valorpesq", "#selectA", "#selectsEspecificos"],
        hide: ["#selF", "#selL", "#selAn1", "#selAn2", "#selO", "#selP", "#selG", "#selectO", "#selectG", "#selectAn", "#selectAn2"]
    },
    An: {
        getTable: () => state.subTab === "An1" ? $("#contentAn1 tbody") : $("#contentAn2 tbody"),
        render: (t,d) => {
            if(state.subTab === "An1"){
                renderGeneric(t, d.ds_tudo.tt_animais, [
                    { key: "codigo"},
                    { key: "nome", class: "alignleft"},
                    { key: "qtd"},
                ]);
            } else {
                renderGeneric(t, d.ds_tudo.tt_animal, [
                    { key: "codigo"},
                    { key: "nome", class: "alignleft"},
                    { class: "alignleft", fn: (d) => `${d["animais-id"]} - ${d["animais-nome"]}`},
                    { fn: (d) => `${d.sexo ? "M" : "F"}`},
                    { key: "vstatus"},
                    { key: "nasc-str"},
                    { key: "peso"},
                    { class: "alignleft", fn: (d) => `${d["lote"]} - ${d["lote-nome"]}`},
                    { class: "alignleft", fn: (d) => `${d["prop"]} - ${d["prop-nome"]}`}
                ]);
            }
        },
        show: ["#valorpesq", "#selectsEspecificos"],
        hide: ["#selF", "#selL", "#selO", "#selA", "#selP", "#selG", "#selectO", "#selectA", "#selectG"]
    },
    G: {
        getTable: () => null,
        render: (t,d) => renderSelectGrafico(d),
        show: ["#selectsEspecificos", "#selectG", "#selG"],
        hide: ["#man", "#selectO", "#selectA", "#selectAn", "#selectAn2", "#valorpesq", "#selF", "#selP", "#selO", "#selA", "#selL","#selAn1", "#selAn2"]
    }
}

//? trocar de tab
$(document).on("click", ".tabs", function(){
    let grupo = $(this).data("group");
    let tab = $(this).data("tab");

    state.vselect = "codigo";
    $("#valorpesq").val("");

    if(grupo === "main"){
        state.tab = tab;

        if(tab === "An"){
            state.subTab = "An1";
        }
    } else {
        state.subTab = tab;
    }

    attUI();
    fpesquisar();
});

//? ativar tab
function activateTab(grupo, tab){
    $(`.tabs[data-group="${grupo}"]`).removeClass("checked");
    $(`.tabs[data-group="${grupo}"][data-tab="${tab}"]`).addClass("checked");
}


//todo --------- TABELAS --------------------------------------------------
//? mostrar tabela
function showContent(container, tab){
    $(container + " .content").removeClass("show");
    $(`#content${tab}`).addClass("show");
}

//? funcao p mostrar tabelas
function renderGeneric(tabela, data, campos){
    if (state.tab === "O" || state.tab === "A") {
        data = orderbyDate(data);
    }

    $.each(data, function(i, d){
        let dataAttrs = "";
        for(let key in d){
            let valor = d[key];

            if(key === "aprovado" || (key === "vstatus" && typeof valor === "boolean")){
                valor = valor ? "yes" : "no";
            }
            else if(key === "sexo"){
                valor = valor ? "M" : "F";
            }
            
            dataAttrs += ` data-${key}="${valor}"`;
        }

        let linha = `<tr ${dataAttrs}>`;
        linha += `<td class="colunapequena"><input type="radio" name="nome"></td>`;

        campos.forEach(c => {
            linha += `<td class="${c.class || ""}"> ${c.fn ? c.fn(d) : d[c.key]} </td>`;
        });
        linha += `</tr>`;
        
        tabela.append(linha);
    });
}

//? carrega tabela
function renderTabela(data){
    const cfg = config[state.tab];

    if(state.tab === "G"){
        cfg.render(null, data);
        return;
    }
    const tabela = cfg.getTable();
    tabela.empty();
    cfg.render(tabela, data);
    selecionarPrim(tabela);
    selecaoLinha(tabela);
}

//? mostrar tabelas
function fpesquisar() {
    showLoading();
    buscarDados().then(renderTabela)
                 .catch(console.error)
                 .finally(hideLoading);
}

//? pesquisa tabelas
function buscarDados(){
    const dadosSelects = {};
    $("#selectsEspecificos select").each(function(){
        dadosSelects[this.id] = $(this).val();
    });
    return ajax("p_getDados", {
        vpesq: $("#valorpesq").val(),
        vselect: state.vselect,
        vtabela: state.tab,
        vsubtabela: state.subTab,
        ...dadosSelects
    });
}

//? quando select mudar
$(document).on("change", "#selects select", function(){
    if(this.id === "seleG") return;
    state.vselect = $(this).val() || "";
    fpesquisar();
});

//? quando clica num select especifico
$(document).on("change", "#selectsEspecificos select", function(){
    fpesquisar();
});


//todo --------- MANUTENCAO -----------------------------------------------
//? qual form de manutenção vai aparecer
function getForm(tab, subTab){
    if(tab == "An"){
        return (subTab == "An1") ? "#formAn1" : "#formAn2";
    } else {
        return "#form" + tab;
    }
}

//? mostrar tela de manutenção
function abrirManutencao(titulo, tab, subTab){
    $("#consulta, #man, .manutencao").hide();
    $("#manutencao, #man2").css("display","flex");
    $("#titulo").text(titulo);

    if(tab == "An"){
        $("#man" + subTab).show();
    } else {
        $("#man" + tab).show();
    }
}

//? ação botoes de manutenção
$(document).on("click", ".botao", function(){
    let id = $(this).attr("id");

    if(id == "excluir"){
        if(!confirm("Deseja realmente excluir este registro?")) return;

        let linha = $("input[name='nome']:checked").closest("tr");
        let dados = linha.data();

        $.ajax({
            type: "POST",
            contentType: 'Content-type: text/plain; charset=iso-8859-1',
            beforeSend: function(jqXHR) {
                jqXHR.overrideMimeType('text/html;charset=iso-8859-1');
            },
            dataType: "html",
            url: url_atual + S + "vpad_proc=p_excluir",
            data: {vtabela: state.tab,
                   vsubtabela: state.subTab,
                   vcodigo: dados.codigo || ''},
            success:function(response){
                if(response && response.replace(/\?/g, "").trim() !== ""){
                    alert("Não é possível excluir, existem registros vinculados.");  
                } else {
                    fpesquisar();  
                }
            },
            error:function(err){
                console.error("Erro ao excluir:", err);
            }
        });
    }
    
    if(id == "alterar"){
        let linha = $("input[name='nome']:checked").closest("tr");
        let dados = linha.data();
        let formId;
        formId = getForm(state.tab, state.subTab);
    
        codigo = dados.codigo || '';
    
        for(let campo in dados){
            let nomeCampo = campo;

            if(campo === "animaisId"){
                nomeCampo = "animais-id";
            }
            if(campo === "nomeVisitante"){
                nomeCampo = "nome-visitante";
            }
            if(campo === "tipoVisitante"){
                nomeCampo = "tipo-visitante";
            }
        
            let input = $(formId + " [name='"+nomeCampo+"']");
        
            if(input.length){
                input.val(dados[campo]);
            }
        }
        
        abrirManutencao("Alterar", state.tab, state.subTab)
        $("select[name='vstatus'], select[name='aprovado']").removeClass("select-disabled");
        $("input[name='nasc']").addClass("select-disabled");

    }
    
    if(id == "voltar"){
        $("#consulta").show();
        $("#man").show();
        $("#manutencao").hide();
        $("#titulo").text("Gestão de Propriedade Rural");
        $("#man2").css("display","none");
        $(".manutencao").css("display","none");
    };

    if(id == "incluir"){
        $("form").each(function(){ this.reset(); });
        codigo = ''; 
    
        abrirManutencao("Inclusão", state.tab, state.subTab)
        $("select[name='vstatus'], select[name='aprovado']").addClass("select-disabled");
        $("input[type='date']").removeClass("select-disabled");
    }
    
    if(id == "salvar"){
        let formId;
        formId = getForm(state.tab, state.subTab);
        $(formId + " input[name='peso']").each(function(){
            $(this).val($(this).val().replace(".", ","));
        });

        var dadosForm = isoSerialize(formId);
        let proc = (!codigo || codigo == '' || codigo == '0') ? "p_criareg" : "p_grava";
               
        let vazio = false;

        $(formId + " input:not([name='codigo']), " + formId + " select:not([name='status']):not([name='aprovado'])").each(function(){
            if($(this).val().trim() === ""){
                vazio = true;
                $(this).focus();
                return false; 
            }
        });

        if(vazio){
            alert("Preencha todos os campos.");
            return;
        }

        $.ajax({
            type: "POST",
            contentType: 'Content-type: text/plain; charset=iso-8859-1',
            beforeSend: function(jqXHR) {
                jqXHR.overrideMimeType('text/html;charset=iso-8859-1');
            },
            dataType: "html",
            url: url_atual + S + "vpad_proc=" + proc,
            data: dadosForm +
                  "&vtabela=" + state.tab +
                  "&vsubtabela=" + state.subTab +
                  "&vcodigo=" + codigo,
            success:function(){
                codigo = '';
                $("#consulta, #man").show();
                $("#manutencao").hide();
                $("#titulo").text("Gestão de Propriedade Rural");
                $("#man2").css("display","none");
                $(".manutencao").hide();
                fpesquisar();
            },
            error:function(err){
                console.error("Erro ao salvar:", err);
            }
        });
    }
});


//todo --------- ZOOM ----------------------------------------------------
//? entrar no zoom
$(document).on("focus", "input[data-zoom]", function(){
    let tipo = $(this).data("zoom");
    inputZoom = $(this);

    $(".zoom:visible .valorpesq").val("");

    $(".overlay, .zoom, #pesqZ").css("display","flex");
    $(".zoom .content").hide();
    $("#zoom"+tipo).show();
    fzoom(tipo, "");
});

//? sair do zoom
$(document).on("click", ".overlay", function(e){
    if($(e.target).is(".overlay")){
        $(".overlay, .zoom").hide();
    }
});

//? pesquisa do zoom
$(document).on("keyup", ".zoom .valorpesq", function(){
    let valor = $(this).val();
    let tipo = $(this).closest(".content").attr("id").replace("zoom","");

    fzoom(tipo, valor);
});

//? func do zoom
function fzoom(tipo, valor){
    let params = { vpesq: valor, vselect: "nome" };

    if(tipo == "L"){
        let prop = inputZoom.closest("form").find("input[name='prop']").val();
        if(prop){
            params.vprop = prop;
            params.visLote = true;
        }
    }

    ajax("p_getDados", params)
    .then((data)=>{
        const cfg = configZoom[tipo];
        if(!cfg) return;
    
        const tabela = cfg.table();
        tabela.empty();
    
        cfg.render(tabela, data);    
    })
}

//? config zoom
const configZoom = {
    F: {
        table: () => $("#zoomF tbody"),
        render: (t,d) => renderGeneric(t, d.ds_tudo.tt_func, [
            { key: "codigo", class: "colunapequena" },
            { key: "nome", class: "alignleft" }
        ])
    },
    L: {
        table: () => $("#zoomL tbody"),
        render: (t,d) => renderGeneric(t, d.ds_tudo.tt_lote, [
            { key: "codigo", class: "colunapequena" },
            { key: "nome", class: "alignleft" }
        ])
    },
    P: {
        table: () => $("#zoomP tbody"),
        render: (t,d) => renderGeneric(t, d.ds_tudo.tt_prop, [
            { key: "codigo", class: "colunapequena" },
            { key: "nome", class: "alignleft" }
        ])
    },
    An1: {
        table: () => $("#zoomAn1 tbody"),
            render: (t,d) => renderGeneric(t, d.ds_tudo.tt_animal, [
                { key: "codigo", class: "colunapequena" },
                { key: "nome", class: "alignleft" }
            ])
    },
    An2: {
        table: () => $("#zoomAn2 tbody"),
            render: (t,d) => renderGeneric(t, d.ds_tudo.tt_animais, [
                { key: "codigo", class: "colunapequena" },
                { key: "nome", class: "alignleft" }
            ])
    }
}

//? seleciona fk no zoom
$(document).on("click",".zoom tbody tr",function(){
    let codigo = $(this).data("codigo");
    if(inputZoom){
        inputZoom.val(codigo);
    }
    $(".overlay").hide();
});


//todo --------- INTERFACE ----------------------------------------------
//? telinha de carregar
function showLoading(){
    $("#loading").css("display", "flex");
}
function hideLoading(){
    $("#loading").hide();
}

//? mostrar/esconder elementos de cada tab
function toggleElements(show = [], hide = []){
    hide.forEach(sel => $(sel).hide());
    show.forEach(sel => $(sel).show());
}

//? atualiza interface
function attUI(){
    activateTab("main", state.tab);
    showContent("#divtable", state.tab);
    
    if(state.tab === "An"){
        activateTab("animais", state.subTab);
        showContent("#contentAn", state.subTab);
    }
    $("#man, #pesq").css("display", "flex");
    toggleElements(config[state.tab].show, config[state.tab].hide)
    
    if(state.tab === "An"){
        $("#selectsEspecificos").css("display","flex");
        if(state.subTab === "An1"){
            toggleElements(
                ["#selAn1", "#selectAn"],
                ["#selAn2", "#selectAn2"]
            );
        } else {
            toggleElements(
                ["#selAn2", "#selectAn", "#selectAn2"],
                ["#selAn1"]
            );
        }
    }
}

//? selecao de linha da tabela
function selecionarPrim(tabela){
    const first = tabela.find('input[name="nome"]').first();
    if(first.length){
        first.prop("checked", true)
             .closest("tr")
             .addClass("linha-selecionada");
    }
}
function selecaoLinha(tabela){
    tabela.find("tr").on("click", function(){
        tabela.find("tr").removeClass("linha-selecionada");
        $(this).addClass("linha-selecionada")
               .find('input[name="nome"')
               .prop("checked",true);
    })
}


//todo --------- GRAFICO ------------------------------------------------
//? select dos graficos
function renderSelectGrafico(data){
    $("#seleG").empty();

    $.each(data.ds_tudo.tt_prop, function(i,d){
        $("#seleG").append(`<option value="${d.codigo}">${d.nome}</option>`);
    });
    renderGrafico();
}

//? carrega graficos
function renderGrafico(){
    let prop = $("#seleG").val();
    let dataini = $("#dataini").val() || "";
    let datafim = $("#datafim").val() || "";

    let url = "/webpro/weball/wragP001g" +
              "?prop=" + prop +
              "&dataini=" + dataini +
              "&datafim=" + datafim;

    $("#iframe").attr("src", url);
}

//? pesquisa no grafico
$(document).on("change", "#seleG, #dataini, #datafim", function(){
    renderGrafico();
});


//todo --------- FORMATAÇÃO ---------------------------------------------
//? ordena lista por data
function orderbyDate(lista){
    return lista.sort((a, b) => new Date(b.data) - new Date(a.data));
}

//? formata cpf ao digitar
$(document).on("input", "input[name='cpf']", function() {
    let v = $(this).val().replace(/\D/g, '');
    if (v.length > 11) v = v.substr(0,11);
    v = v.replace(/(\d{3})(\d)/, "$1.$2");
    v = v.replace(/(\d{3})(\d)/, "$1.$2");
    v = v.replace(/(\d{3})(\d{1,2})$/, "$1-$2");
    $(this).val(v);
});

//? formata fone ao digitar
$(document).on("input", "input[name='fone']", function() {
    let v = $(this).val().replace(/\D/g, ''); 
    if(v.length > 11) v = v.substr(0,11);
    
    if(v.length > 10) {
        v = v.replace(/(\d{2})(\d{5})(\d{4})/, "($1) $2-$3");
    } else if(v.length > 2) {
        v = v.replace(/(\d{2})(\d{0,5})/, "($1) $2");
    }
    $(this).val(v);
});

//? salvar acento no banco
function isoSerialize(formId) {
    return $(formId + " input, " + formId + " select")
        .not("[name='codigo']")
        .not("[disabled]")
        .serializeArray()
        .map((c) => agroEscape(c.name) + "=" + agroEscape(c.value))
        .join("&");
}