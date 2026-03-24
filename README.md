<h1 align = 'center'> Sistema de Gestão de Propriedade Rural</h1>
<h2 align = 'center'> Projeto de Conclusão de Estágio na Agrosys</h2>

<h3>Escopo</h3> 
<p>&emsp;&emsp;A proposta consiste em realizar o desenvolvimento de um sistema web para gestão de propriedades rurais com foco na digitalização das informações da propriedade, permitindo maior organização dos dados, melhor controle das atividades e geração de indicadores estratégicos por meio de gráficos analíticos. </p>
<p>O documento consiste em sete itens para desenvolvimento, sendo eles:</p>

<h4> CDU001 – Manutenção da Propriedade </h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade que permita o cadastro, visualização e gestão das informações estruturais da propriedade.</p>
<p><b>Ações disponíveis:</b></p>
  <ul>
    <li>Incluir Nova Propriedade: permite cadastrar uma nova propriedade com todas as associações necessárias.</li>
    <li>Editar Propriedade Existente: permite alterar nome, tipo de criação, lotes, capacidade e infraestrutura.</li>
  </ul>
Dados: id, nome, tipo de criação.

<br>

<h4> CDU002 – Manutenção de Lotes </h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade para permitir o cadastro, visualização e gestão dos lotes da propriedade.</p>
<p><b>Ações Disponíveis:</b></p>
  <ul>
    <li>Incluir novos lotes.</li>
    <li>Editar dados dos lotes.</li>
  </ul>
Dados: id, capacidade, nome, propriedade vinculada.

<br>

<h4>CDU003 – Manutenção de Funcionários</h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade para permitir o cadastro, visualização e gestão dos funcionários da propriedade. </p>
<p><b>Ações Disponíveis:</b></p>
  <ul>
    <li>Incluir novos funcionários.</li>
    <li>Editar dados dos funcionários.</li>
  </ul>
Dados: nome, CPF, cargo, telefone, e-mail, propriedade vinculada, lote vinculado.

<br>

<h4>CDU004 – Manutenção de Animais</h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade que permita o cadastro, visualização e gestão dos animais da propriedade.</p>
<p><b>Ações Disponíveis:</b></p>
  <ul>
    <li>Incluir novos animais.</li>
    <li>Editar dados dos animais.</li>
    <li>Dados gerais: id, nome, sexo, quantidade.</li>
  </ul>
Dados específicos: id, nome, data de nascimento, peso, sexo, status, propriedade vinculada, lote vinculado.

<br>

<h4> CDU005 – Manutenção de Ocorrências </h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade que permita o cadastro, visualização e gestão das ocorrências na propriedade.</p>
<p><b>Ações Disponíveis:</b></p>
  <ul>
    <li>Incluir novas ocorrências.</li>
    <li>Editar status da ocorrência.</li>
  </ul>
Dados: id, categoria, descrição, status, data, animal vinculado, funcionário vinculado, lote vinculado, propriedade vinculada.

<br>

<h4> CDU006 – Manutenção de Acessos </h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade que permita o cadastro, visualização e gestão dos acessos de visitantes na propriedade.</p>
<p><b>Ações Disponíveis:</b></p>
  <ul>
    <li>Incluir novos acessos.</li>
    <li>Editar dados do acesso enquanto o status da aprovação estiver falso.</li>
  </ul>
<p>Dados: id, nome do visitante, tipo de visitante, status, data, motivo, status de aprovação, propriedade vinculada.</p>


<h4> CDU007 – Criação de Gráficos </h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade que permita visualizar gráficos com informações sobre os dados no sistema.</p>
<p><b>Gráficos disponíveis:</b></p>
  <ul>
    <li><b>Ocorrências por categoria:</b> gráfico de barras, demonstrando a relação entre a quantidade de ocorrências registradas por categoria. As categorias serão previamente definidas no sistema, como doença, queda de produção, problema alimentar e mortalidade. Os dados serão obtidos a partir da tabela “ocorrencia”, utilizando o campo “categoria” para agrupar os registros e calcular a quantidade de ocorrências em cada categoria.</li>
    <li><b>Ocorrências por período:</b> gráfico de linha, demonstrando a evolução da quantidade de ocorrências registradas ao longo do tempo. O sistema irá agrupar as ocorrências por período (dia, mês ou ano) utilizando o campo “data” da tabela “ocorrencia”, permitindo visualizar tendências e identificar períodos com maior incidência de problemas sanitários ou operacionais.</li>
    <li><b>Acessos por tipo de visitante:</b> gráfico de barras, demonstrando a quantidade de acessos registrados por tipo de visitante na propriedade. Os dados serão obtidos a partir da tabela “acesso”, utilizando o campo “tipo-visitante” para agrupar os registros e contabilizar quantos acessos foram realizados por cada tipo cadastrado no sistema.</li>
    <li><b>Distribuição por sexo:</b> gráfico de pizza, demonstrando a distribuição percentual de animais por sexo dentro da propriedade. Os dados serão obtidos a partir da tabela “animal”, utilizando o campo “sexo” para separar os registros entre machos e fêmeas e calcular a proporção de cada grupo no rebanho.</li>
    <li><b>Capacidade VS ocupação dos lotes:</b> gráfico de barras comparativas, demonstrando a relação entre a capacidade máxima de cada lote e a quantidade atual de animais alocados nele. A capacidade será obtida da tabela “lote”, através do campo “capacidade”, enquanto a ocupação será calculada com base na quantidade de registros da tabela “animal” associados ao respectivo lote.</li>
    <li><b>Visitantes por período:</b> gráfico de linha, demonstrando a quantidade de visitantes registrados na propriedade ao longo do tempo. Os dados serão obtidos a partir da tabela “acesso”, utilizando o campo “data” para agrupar os registros por período e contabilizar a quantidade de acessos realizados.</li>
  </ul>

<h3>Tecnologias Utilizadas</h3>
<ul>
  <li>HTML, CSS, JavaScript, jQuery</li>
  <li>Progress OpenEdge (WebSpeed)</li>
  <li>Banco de Dados Progress</li>
</ul>

<h3>Descrição dos Arquivos</h3>
<h4>wragP001.p — Módulo principal</h4>
<p> Arquivo central do sistema, responsável pelo controle geral da aplicação. </p>
<ul>
  <li>Carregamento e renderização do template HTML</li>
  <li>Processamento das requisições do frontend</li>
  <li>Execução de consultas com filtros dinâmicos</li>
  <li>Manipulação de dados (inclusão, alteração e exclusão)</li>
  <li>Validação de integridade antes de exclusões</li>
  <li>Estruturação dos dados em dataset para envio ao frontend</li>
</ul>

<h4>wragP001g.p — Módulo de gráficos</h4>
<p>Responsável pela geração dos dados utilizados nos gráficos do sistema.</p>
<ul>
  <li>Processamento de dados analíticos</li>
  <li>Agrupamentos e contagens</li>
  <li>Filtros por propriedade e período</li>
</ul>

<h4>wragP001d.p — Entrada de parâmetros para o relatório</h4>
<p>Tela responsável pela coleta de parâmetros para geração de relatórios.</p>
<ul>
  <li>Seleção de propriedade</li>
  <li>Definição de intervalo de datas</li>
  <li>Validação de dados informados</li>
  <li>Disparo de processamento em lote</li>
</ul>

<h4>wragP001r.p — Relatório de ocorrências</h4>
<p>Responsável pela geração do relatório de ocorrências.</p>
<ul>
  <li>Listagem de ocorrências por período</li>
  <li>Agrupamento por categoria</li>
  <li>Cálculo de subtotais</li>
  <li>Formatação para visualização e impressão</li>
</ul>
