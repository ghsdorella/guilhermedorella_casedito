/*PROBLEMA 1*/
/*Neste primeiro caso, como temos uma única tabela, é necessário criar uma tabela apenas com os dados de 'track' 
para cruzar com uma tabela com os dados de 'identify' no mesmo 'id'*/

/*Aqui é necessário apenas o ID du usuário e a soma de todas as compras feitas por ele, 
visto que a ID de eventido 'track' é o mesmo de eventos 'identify'.*/
/*Para não gerar um dataset muito grande sem necessidade, a consulta foi limitada para retornar apenas os 5 primeiros registros*/
/*Neste SELECT estão apenas o 'id' e a soma das receitas, pois são as únicas informações necessárias*/
WITH purchase AS
  (SELECT
    id as purchase_id,
    sum(properties.revenue) as purchase_rev
   FROM `dito-data-scientist-challenge.tracking.dito`
   WHERE type = 'track'
   GROUP BY id
   ORDER BY sum(properties.revenue) DESC
   LIMIT 5)
/*Nesta segunda parte, são buscados os dados do usuário junto com o valor das comprar feitas por ele*/
SELECT
  d1.traits.name,
  d1.traits.email,
  d1.traits.phone,
  d1.timestamp,
  purchase_rev 
FROM `dito-data-scientist-challenge.tracking.dito` d1
INNER JOIN purchase
ON d1.id = purchase_id
WHERE type = 'identify'
/*Aqui foi necessário realizar uma subquery para buscar apenas o último registro criado pelo usuário 
onde o email e o telefone não eram nulos*/
AND d1.timestamp = (SELECT MAX(d2.timestamp) 
                 FROM `dito-data-scientist-challenge.tracking.dito` d2 
                 WHERE d1.traits.name = d2.traits.name
                 AND d2.traits.email IS NOT NULL
                 AND d2.traits.phone IS NOT NULL)
ORDER BY purchase_rev DESC
