-- Запрос для подсчета числа покупателей
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


-- Запрос для формирования отчета с продавцами, чья средняя выручка за сделку ниже средней выручки за сделку всех продавцов
select
	concat(e.first_name,' ',e.last_name) as name,	-- имя продавца в формате "Имя Фамилия"
	floor(avg(s.quantity * p.price)) as average_income 		-- средняя выручка продавца за сделку с округлением до целого
from
	employees e 
inner join sales s on e.employee_id = s.sales_person_id 	-- условие объединения таблиц - id продавца
inner join products p on s.product_id = p.product_id 		-- условие объединения таблиц - id продукта
group by
	e.employee_id
HAVING avg(s.quantity) < 							-- фильтр данных по условию "средняя выручка за сделку продавца меньше средней выручки за сделку всех продавцов"
	   (select avg(s2.quantity) from sales s2)		-- подзапрос для определения средней выручки за сделку всех продавцов
order by average_income;							-- упорядочиваем по средней выручке за сделку по возрастанию


-- Запрос для формирования отчета по выручке по каждому продавцу и дню недели
select													-- запрос из вспомогательной таблицы t
	t.name,												-- имя продавца в формате "Имя Фамилия"			
	t.weekday,											-- день недели в текстовом формате
	floor(sum(t.income)) as income						-- суммарная выручка (округление в меньшую сторону)
from 
	(select												-- подзапрос, формирующий вспомогательную таблицу, содержащую:
		e.employee_id as employee_id,					-- id продавца
		concat(e.first_name,' ',e.last_name) as name,	-- имя продавца в формате "Имя Фамилия"
		to_char(s.sale_date, 'Day') as weekday,			-- день недели в текстовом формате
		case extract(DOW from s.sale_date)				-- получаем номер дня недели
	   		when 0 then 7								-- если воскресенье (=0), то заменяем на 7 для нумерации с пн по вс от 1 до 7
	   		else extract(DOW from s.sale_date)			-- если не воскресенье, то ничем не заменяем
		end as day_of_week,
		(s.quantity * p.price) as income 				-- выручка с одной продажи
	from
		employees e
	inner join sales s on e.employee_id = s.sales_person_id		-- условие объединения таблиц - id продавца
	inner join products p on p.product_id = s.product_id 		-- условие объединения таблиц - id продукта
	) as t											
group by
	t.employee_id, t.name, t.weekday, t.day_of_week		
order by												-- упорядочиваем по возрастанию (по умолчанию) по дню недели и имени продавца
	t.day_of_week,
	t.name;