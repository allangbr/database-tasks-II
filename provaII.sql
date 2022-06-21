#Questão 01
Index,  é um recurso que tem como objetivo ordenar dados em uma determinada sequência, afim de tornar os mecanismos de busca mais eficientes. 
Eu criaria indices para os atributos 
Projeto(descricao): Pela busca para listagem de nomes do projeto,
Projeto(depto): Pela busca e filtragem de projetos por depto,
Projeto(responsavel): Pela busca de projetos que estão vinculados a um responsavel,
Projeto(dataInicio e dataFim): Pela busca dos projetos que estão em determinado espaço de tempo,
Projeto(situação): Pela busca por processos que estão em aberto ou finalizados,
Projeto(equipe): Pela busca para analisar quais funcionais pertencem a equipe de quais projetos.

Atividade(descricao): Pela busca para listagem de nomes da atividade,
Atividade(dataInicio e dataFim): Pela busca das atividades que estão em determinado espaço de tempo,
Atividade(situação): Pela busca por atividades que estão em aberto ou finalizadas.

#Questão 02
Alguns exemplos de indices presentes no PostgreSQL são os B-tree, hash e o GIN. 
O índice padrão utilizado no PostgreSQL é o B-tree, sendo este o que se encaixa melhor nas situações mais cotidianas. 
Os índices hash estes são úteis apenas para comparações de igualdade, porém, devido a sua falta de segurança nas transações, é melhor que eles sejam evitados. 
Já os índices GIN são bastante úteis no momento em que um índice deve mapear vários valores para uma linha, o que difere dos índices B-Tree que são otimizados para quando uma linha possui um único valor de chave.

#Questão 03
CREATE INDEX data_fim ON atividade (dataFim);

#Questão 04
CREATE OR REPLACE FUNCTION quantAtividadesProjeto (codigoProjeto INTEGER) 
    RETURNS TABLE (
        qtdAtividades BIGINT
) 
AS $$
BEGIN
   RETURN QUERY 
   SELECT COUNT(atividade.codigo)
   FROM atividade_projeto AS ap, atividade
   WHERE codigoProjeto = ap.codprojeto AND ap.codatividade = atividade.codigo;
END; $$ 

LANGUAGE 'plpgsql';

SELECT * FROM quantAtividadesProjeto(1);

#Questão 05
CREATE OR REPLACE FUNCTION relatorio() 
    RETURNS TABLE (
        codProjeto INTEGER,
        descricao varchar(45),
		nomeResponsavel varchar(15),
		quantAtividades BIGINT
) 
AS $$
BEGIN
   RETURN QUERY 
   SELECT pj.codigo, pj.descricao, f.nome, COUNT(atividade.codigo)
   FROM projeto AS pj 
   INNER JOIN funcionario AS f
   ON pj.responsavel = f.codigo 
   INNER JOIN atividade_projeto AS ap
   ON pj.codigo = ap.codprojeto
   INNER JOIN atividade 
   ON ap.codatividade = atividade.codigo
   GROUP BY pj.codigo, f.nome;
END; $$ 

LANGUAGE 'plpgsql';

SELECT * FROM relatorio();

#Questão 06
CREATE ROLE gerente_geral WITH PASSWORD 'senha' 
GRANT EXECUTE ON PROCEDURE proc_relatorio_gestao TO gerente_geral

#Questão 07
ALTER TABLE funcionario ADD num_sorte int DEFAULT nextval('seq_sorte');

#Questão 08
insert into funcionario VALUES ('Ana', 'F', '1988-05-07', 2500.00, null, 1, nextval('seq_sorte'));

#Questão 09
CREATE SEQUENCE seq_sorte
start with 1
increment by 1
minvalue 1
maxvalue 100
cycle;
