# Tech Challenge 

Solution of stone tech challenge.

---

# O Desafio

O Sistema Financeiro precisa representar valores monetários. A ideia básica é ter uma estrutura de dados que permita realizar operações financeiras com dinheiro dentro de uma mesma moeda. _Isso é pelo motivo de pontos flutuantes terem problemas de aritmética_, logo encodificamos valores decimais/fracionais/reais como uma estrutura de dados com campos em inteiros, além de mapeamos operações aritméticas sobre tal estrutura. No fim, a implementação acaba sendo uma Estrutura de Dados Abstrata.

Essas operações financeiras precisam ser seguras e devem interromper a execução do programa em caso de erros críticos.

Sobre as operações financeiras que serão realizadas no sistema, é correto afirmar que os valores monetários devem suportar as seguintes operaçoes:

* O sistema realizará split de transações financeiras, então deve ser possível realizar a operação de rateio de valores monetários entre diferentes indivíduos.

* O sistema permite realizar câmbio então os valores monetários possuem uma operação para conversão de moeda.

* O sistema precisa estar em _compliance_ com as organizações internacionais, então é desejável estar em conformidade com a [ISO 4217]

---


In order to run the application, use the following commands:

`iex -S mix` to run in interactive mode
`mix test` to test the application