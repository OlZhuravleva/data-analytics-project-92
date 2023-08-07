-- Запрос к таблице покупателей для подсчета числа покупателей
select
	count(c.customer_id) as customers_count
from
	customers c;
	

-- Запрос для определения топ-10 продавцов с наибольшей выручкой
select
	concat(e.first_name, ' ', e.last_name) as name, -- имя продавца в формате "Имя Фамилия"
	count(s.sales_person_id) as operations,			-- количество проведенных сделок
	floor(sum(s.quantity * p.price)) as income		-- суммарная выручка (округление до целого в меньшую сторону)
from
	employees e 
inner join sales s on e.employee_id = s.sales_person_id 	-- условие объединения таблиц - id продавца
inner join products p on s.product_id = p.product_id 		-- условие объединения таблиц - id продукта
group by
	e.employee_id 									-- группируем данные по id продавца
order by
	income desc										-- упорядочиваем по сумме выручки по убыванию
limit 10;											-- выводим первые 10 значение (топ-10)


