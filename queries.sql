-- Запрос к таблице покупателей для подсчета числа покупателей
SELECT
	COUNT(c.customer_id) AS customers_count
FROM
	customers c;
