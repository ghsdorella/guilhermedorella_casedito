/*PROBLEMA 2*/

/*Nesta consulta a primeira parte consiste em criar uma tabela com uma nova coluna chamada 'prev_timestamp'*/
/*Para criar a coluna 'prev_timestamp' foi utilizada a função LAG que retorna o valor da linha anterior da coluna 'timestamp'*/
/*Com essa coluna é possivel obter a diferença de dias entre uma compra e a compra anterior a ela com a função DATE_DIFF*/
/*Por fim, para obter a mediana, foi utilizado PERCENTILE_CONT que retorna o percentil de uma coluna*/
/*Neste caso, foi utilizado o percentil 0.5 que retorna o valor do meio, ou seja, a mediana*/
/*Foi utilizada a função DISTINCT para retornar a mediana para cada um dos cliente de acordo com seu 'id'*/

SELECT
      DISTINCT(id),
      PERCENTILE_CONT((date_diff(DATE(timestamp), DATE(prev_timestamp), DAY)),0.5) OVER (PARTITION BY id) AS median
FROM (
    SELECT
      id,
      timestamp,
      LAG(timestamp) OVER(PARTITION BY id ORDER BY timestamp) AS prev_timestamp
    FROM `dito-data-scientist-challenge.tracking.dito`
    WHERE type = 'track')
WHERE DATE_DIFF(DATE(timestamp), DATE(prev_timestamp), DAY) != 0   
GROUP BY id, timestamp, prev_timestamp