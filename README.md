<h1 align = 'center'> Projeto de Conclusão de Estágio</h1>

<h2 align = 'center'> Sistema de Gestão de Propriedade Rural</h2>

<h3>Escopo</h3> 
<p>&emsp;&emsp;A proposta consiste em realizar o desenvolvimento de um sistema web para gestão de propriedades rurais com foco na digitalização das informações da propriedade, permitindo maior organização dos dados, melhor controle das atividades e geração de indicadores estratégicos por meio de gráficos analíticos. </p>
<p>O documento consiste em sete itens para desenvolvimento, sendo eles:</p>

<h4> CDU001 – Manutenção da Propriedade </h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade que permita o cadastro, visualização e gestão das informações estruturais da propriedade.</p>
<p><b>Ações disponíveis:</b></p>
<ul><li>Incluir Nova Propriedade: permite cadastrar uma nova propriedade com todas as associações necessárias.</li></ul>
<ul><li>Editar Propriedade Existente: permite alterar nome, tipo de criação, lotes, capacidade e infraestrutura.</li></ul>
Dados: id, nome, tipo de criação.

<br><br>

<h4> CDU002 – Manutenção de Lotes </h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade para permitir o cadastro, visualização e gestão dos lotes da propriedade.</p>
<p><b>Ações Disponíveis:</b></p>
<ul><li>Incluir novos lotes.</li></ul>
<ul><li>Editar dados dos lotes.</li></ul>
Dados: id, capacidade, nome, propriedade vinculada.

<br><br>

<h4>CDU003 – Manutenção de Funcionários</h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade para permitir o cadastro, visualização e gestão dos funcionários da propriedade. </p>
<p><b>Ações Disponíveis:</b></p>
<ul><li>Incluir novos funcionários.</li></ul>
<ul><li>Editar dados dos funcionários.</li></ul>
Dados: nome, CPF, cargo, telefone, e-mail, propriedade vinculada, lote vinculado.

<br><br>

<h4>CDU004 – Manutenção de Animais</h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade que permita o cadastro, visualização e gestão dos animais da propriedade.</p>
<p><b>Ações Disponíveis:</b></p>
<ul><li>Incluir novos animais.</li></ul>
<ul><li>Editar dados dos animais.</li></ul>
<ul><li>Dados gerais: id, nome, sexo, quantidade.</li></ul>
Dados específicos: id, nome, data de nascimento, peso, sexo, status, propriedade vinculada, lote vinculado.

<br><br>

<h4> CDU005 – Manutenção de Ocorrências </h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade que permita o cadastro, visualização e gestão das ocorrências na propriedade.</p>
<p><b>Ações Disponíveis:</b></p>
<ul><li>Incluir novas ocorrências.</li></ul>
<ul><li>Editar status da ocorrência.</li></ul>
Dados: id, categoria, descrição, status, data, animal vinculado, funcionário vinculado, lote vinculado, propriedade vinculada.

<br><br>

<h4> CDU006 – Manutenção de Acessos </h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade que permita o cadastro, visualização e gestão dos acessos de visitantes na propriedade.</p>
<p><b>Ações Disponíveis:</b></p>
  <ul><li>Incluir novos acessos.</li></ul>
  <ul><li>Editar dados do acesso enquanto o status da aprovação estiver falso.</li></ul>
<p>Dados: id, nome do visitante, tipo de visitante, status, data, motivo, status de aprovação, propriedade vinculada.</p>

<br><br>

<h4> CDU007 – Criação de Gráficos </h4>
<p>&emsp;&emsp;Desenvolver uma funcionalidade que permita visualizar gráficos com informações sobre os dados no sistema.</p>
<p><b>Gráficos disponíveis:</b></p>
  <ul><li><b>Ocorrências por categoria:</b> gráfico de barras, demonstrando a relação entre a quantidade de ocorrências registradas por categoria. As categorias serão previamente definidas no sistema, como doença, queda de produção, problema alimentar e mortalidade. Os dados serão obtidos a partir da tabela “ocorrencia”, utilizando o campo “categoria” para agrupar os registros e calcular a quantidade de ocorrências em cada categoria.</li></ul>
  <ul><li><b>Ocorrências por período:</b> gráfico de linha, demonstrando a evolução da quantidade de ocorrências registradas ao longo do tempo. O sistema irá agrupar as ocorrências por período (dia, mês ou ano) utilizando o campo “data” da tabela “ocorrencia”, permitindo visualizar tendências e identificar períodos com maior incidência de problemas sanitários ou operacionais.</li></ul>
  <ul><li><b>Acessos por tipo de visitante:</b> gráfico de barras, demonstrando a quantidade de acessos registrados por tipo de visitante na propriedade. Os dados serão obtidos a partir da tabela “acesso”, utilizando o campo “tipo-visitante” para agrupar os registros e contabilizar quantos acessos foram realizados por cada tipo cadastrado no sistema.</li></ul>
  <ul><li><b>Distribuição por sexo:</b> gráfico de pizza, demonstrando a distribuição percentual de animais por sexo dentro da propriedade. Os dados serão obtidos a partir da tabela “animal”, utilizando o campo “sexo” para separar os registros entre machos e fêmeas e calcular a proporção de cada grupo no rebanho.</li></ul>
  <ul><li><b>Capacidade VS ocupação dos lotes:</b> gráfico de barras comparativas, demonstrando a relação entre a capacidade máxima de cada lote e a quantidade atual de animais alocados nele. A capacidade será obtida da tabela “lote”, através do campo “capacidade”, enquanto a ocupação será calculada com base na quantidade de registros da tabela “animal” associados ao respectivo lote.</li></ul>
  <ul><li><b>Visitantes por período:</b> gráfico de linha, demonstrando a quantidade de visitantes registrados na propriedade ao longo do tempo. Os dados serão obtidos a partir da tabela “acesso”, utilizando o campo “data” para agrupar os registros por período e contabilizar a quantidade de acessos realizados.</li></ul>
