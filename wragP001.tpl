<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script type="text/javascript" src="/sistema/jquery/jquery-3.7.0.min.js"></script>
    <script src="/sistema/jquery/webfuncs.js"></script>
    <link rel="stylesheet" href="/sistema/templates/webstyle.css">
    <!-- BEGIN BLOCK_CACHE -->
    <link rel="stylesheet" href="/sistema/templates/wragP001.css?vcache=[cache]">
    <script src="/sistema/templates/wragP001.js?vcache=[cache]"></script>
    <!-- END BLOCK_CACHE -->
    <title>Projeto</title>
</head>
<body>
    <div id="redor">
        <div id="fundotitulo">
            <span id="titulo">Gestão de Propriedade Rural</span>
        </div>
        <div id="consulta">
            <div id="naveg" class="naveg">
                <input type="button" class="tabs" data-group="main" data-tab="P" value="Propriedades">
                <input type="button" class="tabs" data-group="main" data-tab="L" value="Lotes">
                <input type="button" class="tabs" data-group="main" data-tab="F" value="Funcionários">
                <input type="button" class="tabs" data-group="main" data-tab="An" value="Animais">
                <input type="button" class="tabs" data-group="main" data-tab="A" value="Acessos">
                <input type="button" class="tabs" data-group="main" data-tab="O" value="Ocorrências">
                <input type="button" class="tabs" data-group="main" data-tab="G" value="Gráficos">
            </div>

            <div id="pesq" class="pesq">
                <div id="selects">
                    <div id="selF" style="display: none;">
                        <select name="select" id="seleF">
                            <option value="codigo">Código</option>
                            <option value="nome">Nome</option>
                            <option value="cargo">Cargo</option>
                            <option value="lote">Lote</option>
                            <option value="prop">Propriedade</option>
                        </select>
                    </div>
                    <div id="selP" style="display: none;">
                        <select name="select" id="seleP">
                            <option value="codigo">Código</option>
                            <option value="nome">Nome</option>
                            <option value="criacao">Criação</option>
                        </select>
                    </div>
                    <div id="selL" style="display: none;">
                        <select name="select" id="seleL">
                            <option value="codigo">Código</option>
                            <option value="nome">Nome</option>
                            <option value="prop">Propriedade</option>
                        </select>
                    </div>
                    <div id="selAn1" style="display: none;">
                        <select name="select" id="seleAn1">
                            <option value="codigo">Código</option>
                            <option value="nome">Nome</option>
                        </select>
                    </div>
                    <div id="selAn2" style="display: none;">
                        <select name="select" id="seleAn2">
                            <option value="codigo">Código</option>
                            <option value="nome">Nome</option>
                            <option value="especie">Espécie</option>
                            <option value="lote">Lote</option>
                            <option value="prop">Propriedade</option>
                        </select>
                    </div>
                    <div id="selA" style="display: none;">
                        <select name="select" id="seleA">
                            <option value="codigo">Código</option>
                            <option value="nome">Nome</option>
                            <option value="tipo">Tipo</option>
                            <option value="motivo">Motivo</option>
                            <option value="prop">Propriedade</option>
                        </select>
                    </div>
                    <div id="selO" style="display: none;">
                        <select name="select" id="seleO">
                            <option value="codigo">Código</option>
                            <option value="descricao">Descrição</option>
                            <option value="lote">Lote</option>
                            <option value="prop">Propriedade</option>
                        </select>
                    </div>
                    <div id="selG" style="display: none;">
                        <select name="select" id="seleG"></select>
                    </div>
                </div>
                <input type="text" name="valorpesq" id="valorpesq">

                <select id="selgraf" style="display:none"></select>
                <div id="selectsEspecificos" style="gap: 4px;">
                    <div id="selectO" style="display: none;">
                        <select name="selcat" id="selcatO">
                            <option value=""><--CATEGORIA--></option>
                            <option value="Doenca">Doença</option>
                            <option value="Queda de producao">Queda de produção</option>
                            <option value="Problema alimentar">Problema alimentar</option>
                            <option value="Mortalidade">Mortalidade</option>
                            <option value="Acidente">Acidente</option>
                        </select>
                        <select name="selstatus" id="selstatusO">
                            <option value=""><--STATUS--></option>
                            <option value="Aberto">Aberto</option>
                            <option value="Em analise">Em análise</option>
                            <option value="Em tratamento">Em tratamento</option>
                            <option value="Resolvido">Resolvido</option>
                            <option value="Cancelado">Cancelado</option>
                        </select>
                    </div>
                    <div id="selectA" style="display: none;">
                        <select name="selcat" id="selcatA">
                            <option value=""><--APROVADO--></option>
                            <option value="true">Sim</option>
                            <option value="false">Não</option>
                        </select>
                        <select name="selstatus" id="selstatusA">
                            <option value=""><--STATUS--></option>
                            <option value="true">Realizado</option>
                            <option value="false">Não realizado</option>
                        </select>
                    </div>
                    <div id="selectAn2" style="display: none;">
                        <select name="selsexo" id="selsexoAn2">
                            <option value=""><--SEXO--></option>
                            <option value="true">Masculino</option>
                            <option value="false">Feminino</option>
                        </select>
                        <select name="selstatus" id="selstatusAn2">
                            <option value=""><--STATUS--></option>
                            <option value="Ativo">Ativo</option>
                            <option value="Morto">Morto</option>
                            <option value="Vendido">Vendido</option>
                        </select>
                    </div>
                    <div id="selectG" style="display: none;">
                        <span>Data inicial</span>
                        <input type="date" name="dataini" id="dataini">
                        <span>Data final</span>
                        <input type="date" name="datafim" id="datafim">
                    </div>
                </div>
            </div>

            <div id="divtable">
                <div class="content" id="contentP">
                    <table>
                        <thead>
                            <tr>
                                <th></th>
                                <th>Código</th>
                                <th class="alignleft">Nome</th>
                                <th class="alignleft">Criação</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="content" id="contentL">
                    <table>
                        <thead>
                            <tr>
                                <th></th>
                                <th>Código</th>
                                <th class="alignleft">Nome</th>
                                <th>Capacidade</th>
                                <th class="alignleft">Propriedade</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="content" id="contentF">
                    <table>
                        <thead>
                            <tr>
                                <th></th>
                                <th>Código</th>
                                <th class="alignleft">Nome</th>
                                <th>CPF</th>
                                <th class="alignleft">Cargo</th>
                                <th>Telefone</th>
                                <th>Email</th>
                                <th class="alignleft">Lote</th>
                                <th class="alignleft">Propriedade</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="content" id="contentAn">
                    <div class="naveg" id="naveg2">
                        <input type="button" class="tabs" data-group="animais" data-tab="An1" value="Geral">
                        <input type="button" class="tabs" data-group="animais" data-tab="An2" value="Específico">
                    </div>
                    <div class="content" id="contentAn1">
                        <table>
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Código</th>
                                    <th class="alignleft">Nome</th>
                                    <th>Quantidade</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div class="content" id="contentAn2">
                        <table>
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Código</th>
                                    <th class="alignleft">Nome</th>
                                    <th class="alignleft">Espécie</th>
                                    <th>Sexo</th>
                                    <th>Status</th>
                                    <th>Nascimento</th>
                                    <th>Peso (kg)</th>
                                    <th class="alignleft">Lote</th>
                                    <th class="alignleft">Propriedade</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>                    
                    </div>
                </div>
                <div class="content" id="contentA">
                    <table>
                        <thead>
                            <tr>
                                <th></th>
                                <th>Código</th>
                                <th class="alignleft">Nome</th>
                                <th>Tipo</th>
                                <th class="alignleft">Motivo</th>
                                <th>Data</th>
                                <th>Hora</th>
                                <th>Aprovado</th>
                                <th>Status</th>
                                <th class="alignleft">Propriedade</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="content" id="contentO">
                    <table>
                        <thead>
                            <tr>
                                <th></th>
                                <th>Código</th>
                                <th>Categoria</th>
                                <th class="alignleft">Descrição</th>
                                <th class="alignleft">Animal</th>
                                <th class="alignleft">Funcionário</th>
                                <th>Data</th>
                                <th>Status</th>
                                <th class="alignleft">Lote</th>
                                <th class="alignleft">Propriedade</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="content" id="contentG">
                    <iframe id="iframeG" style="width: 100%;"></iframe>
                </div>
            </div>
            <div class="content" id="contentR">
                <iframe id="iframeR" style="width: 100%; height: 100%;"></iframe>
            </div>
        </div>
        <div id="manutencao">
            <form id="formF">
                <div id="manF" class="manutencao">
                    <div class="campo"><span>CPF</span> <input type="text" name="cpf"></div>
                    <div class="campo"><span>Nome</span> <input type="text" name="nome"></div>
                    <div class="campo"><span>Cargo</span> <input type="text" name="cargo"></div>
                    <div class="campo"><span>Telefone</span> <input type="text" name="fone"></div>
                    <div class="campo"><span>E-mail</span> <input type="text" name="email"></div>
                    <div class="campo"><span>Propriedade</span> <input type="text" name="prop" data-zoom="P"></div>
                    <div class="campo"><span>Lote</span> <input type="text" name="lote" data-zoom="L"></div>
                </div>
            </form>
            <form id="formP">
                <div id="manP" class="manutencao">
                    <div class="campo"><span>Código</span> <input type="text" name="codigo" disabled></div>
                    <div class="campo"><span>Nome</span> <input type="text" name="nome"></div>
                    <div class="campo"><span>Criação</span> <input type="text" name="criacao"></div>
                </div>
            </form>
            <form id="formL">
                <div id="manL" class="manutencao">
                    <div class="campo"><span>Código</span> <input type="text" name="codigo" disabled></div>
                    <div class="campo"><span>Nome</span> <input type="text" name="nome"></div>
                    <div class="campo"><span>Capacidade</span> <input type="text" name="capacidade"></div>
                    <div class="campo"><span>Propriedade</span> <input type="text" name="prop" data-zoom="P"></div>
                </div>
            </form>
            <form id="formAn1">
                <div id="manAn1" class="manutencao">
                    <div class="campo"><span>Código</span> <input type="text" name="codigo" disabled></div>
                    <div class="campo"><span>Nome</span> <input type="text" name="nome"></div>
                </div>
            </form>
            <form id="formAn2">
                <div id="manAn2" class="manutencao">
                    <div class="campo"><span>Código</span> <input type="text" name="codigo" disabled></div>
                    <div class="campo"><span>Nome</span> <input type="text" name="nome"></div>
                    <div class="campo"><span>Sexo</span>
                        <select name="sexo">
                            <option value="M">Masculino</option>
                            <option value="F">Feminino</option>
                        </select>
                    </div>
                    <div class="campo"><span>Status</span>
                        <select name="vstatus">
                            <option value="Ativo">Ativo</option>
                            <option value="Morto">Morto</option>
                            <option value="Vendido">Vendido</option>
                        </select>
                    </div>
                    <div class="campo"><span>Nascimento</span> <input type="date" name="nasc"></div>
                    <div class="campo"><span>Peso (kg)</span> <input type="text" name="peso"></div>
                    <div class="campo"><span>ID animais</span> <input type="text" name="animais-id" data-zoom="An2"></div>
                    <div class="campo"><span>Propriedade</span> <input type="text" name="prop" data-zoom="P"></div>
                    <div class="campo"><span>Lote</span> <input type="text" name="lote" data-zoom="L"></div>
                </div>
            </form>
            <form id="formA">
                <div id="manA" class="manutencao">
                    <div class="campo"><span>Código</span> <input type="text" name="codigo" disabled></div>
                    <div class="campo"><span>Nome</span> <input type="text" name="nome-visitante"></div>
                    <div class="campo"><span>Tipo</span> <input type="text" name="tipo-visitante"></div>
                    <div class="campo"><span>Motivo</span> <input type="text" name="motivo"></div>
                    <div class="campo"><span>Data</span> <input type="date" name="data"></div>
                    <div class="campo"><span>Hora</span> <input type="time" name="hora"></div>
                    <div class="campo"><span>Aprovado</span>
                        <select name="aprovado">
                            <option value="no">Não</option>
                            <option value="yes">Sim</option>
                        </select>
                    </div>
                    <div class="campo"><span>Status</span>
                        <select name="vstatus">
                            <option value="no">Não realizado</option>
                            <option value="yes">Realizado</option>
                        </select>
                    </div>
                    <div class="campo"><span>Propriedade</span> <input type="text" name="prop" data-zoom="P"></div>
                </div>
            </form>
            <form id="formO">
                <div id="manO" class="manutencao">
                    <div class="campo"><span>Código</span> <input type="text" name="codigo" disabled></div>
                    <div class="campo"><span>Categoria</span> 
                        <select name="categoria">
                            <option value="Doenca">Doença</option>
                            <option value="Queda de producao">Queda de produção</option>
                            <option value="Problema alimentar">Problema alimentar</option>
                            <option value="Mortalidade">Mortalidade</option>
                            <option value="Acidente">Acidente</option>
                        </select>
                    </div>
                    <div class="campo"><span>Descrição</span> <input type="text" name="descricao"></div>
                    <div class="campo"><span>Animal</span> <input type="text" name="animal" data-zoom="An1"></div>
                    <div class="campo"><span>Funcionário</span> <input type="text" name="func" data-zoom="F"></div>
                    <div class="campo"><span>Data</span> <input type="date" name="data"></div>
                    <div class="campo"><span>Status</span>
                        <select name="vstatus">
                            <option value="Aberto">Aberto</option>
                            <option value="Em analise">Em análise</option>
                            <option value="Em tratamento">Em tratamento</option>
                            <option value="Resolvido">Resolvido</option>
                            <option value="Cancelado">Cancelado</option>
                        </select>
                    </div>
                    <div class="campo"><span>Propriedade</span> <input type="text" name="prop" data-zoom="P"></div>
                    <div class="campo"><span>Lote</span> <input type="text" name="lote" data-zoom="L"></div>
                </div>
            </form>
        </div>
        
        <div id="man">
            <div class="btrelat">
                <input type="button" value="Relatório" id="relatorio" class="botao">
            </div>
            <div class="man">
                <input type="button" value="Excluir" class="botao" id="excluir">
                <input type="button" value="Alterar" class="botao" id="alterar">
                <input type="button" value="Incluir" class="botao" id="incluir">
            </div>
        </div>
        <div id="man2">
            <div class="man">
                <input type="button" value="Voltar" class="botao" id="voltar">
                <input type="button" value="Salvar" class="botao" id="salvar">
            </div>
        </div>

        <div class="overlay">
            <div class="zoom">
                <div class="content" id="zoomP">
                    <div class="pesq" id="pesqZ">
                        <span>Nome:</span>
                        <input type="text" name="nome" class="valorpesq">
                    </div>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Código</th>
                                    <th class="alignleft">Nome</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                </div>
                </div>
                <div class="content" id="zoomF">
                    <div class="pesq" id="pesqZ">
                        <span>Nome:</span>
                        <input type="text" name="nome" class="valorpesq">
                    </div>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Código</th>
                                    <th class="alignleft">Nome</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="content" id="zoomL">
                    <div class="pesq" id="pesqZ">
                        <span>Nome:</span>
                        <input type="text" name="nome" class="valorpesq">
                    </div>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Código</th>
                                    <th class="alignleft">Nome</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="content" id="zoomAn1">
                    <div class="pesq" id="pesqZ">
                        <span>Nome:</span>
                        <input type="text" name="nome" class="valorpesq">
                    </div>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Código</th>
                                    <th class="alignleft">Nome</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="content" id="zoomAn2">
                    <div class="pesq" id="pesqZ">
                        <span>Nome:</span>
                        <input type="text" name="nome" class="valorpesq">
                    </div>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Código</th>
                                    <th class="alignleft">Nome</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>  
                    </div>                  
                </div>
            </div>
        </div>
        <div id="loading">
            <div class="spinner"></div>
        </div>
    </div>
</body>
</html>
