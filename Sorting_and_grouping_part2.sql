--ДЗ по SQL: Sorting and grouping
--часть 2. 1
select * from (
	select
	    s.seller_id,
	    count(s.category) as total_categ,  
	    avg(s.rating) as avg_rating,                
	    sum(s.revenue) as total_revenue,            
	    case 
	        when sum(s.revenue) > 50000 and count(s.category) > 1 then 'rich'   
	        when sum(s.revenue) < 50000 and count(s.category) > 1 then 'poor'                        
	    end as seller_type
	from public.sellers s
	where s.category != 'Bedding'
	group by s.seller_id
	order by s.seller_id)
where seller_type notnull;
--использование подзапроса обусловлено тем, что по заданию необходимо вывести seller_type, а для некоторых продавцов у нас нет типа
--чтобы не выводить null, подзапрос в дальнейшем фильтруется

------------------------------------------------------------------------------------------------------------------
--часть 2. 2
with poor_sellers as (
select
    s.seller_id,
	min(to_date(s.date_reg, 'DD/MM/YYYY')) as min_date_reg,
	max(s.delivery_days) as max_delivery,
    min(s.delivery_days) as min_delivery
from public.sellers s
where s.category != 'Bedding'  
group by s.seller_id
having sum(s.revenue) < 50000 and count(s.category) > 1)
select
    ps.seller_id,
    (current_date - ps.min_date_reg)/30 as month_from_registration,
    (select max(max_delivery)-min(min_delivery) from poor_sellers ps ) as max_delivery_difference
from poor_sellers ps
order by ps.seller_id;
-- В качестве даты регистрации была взята минимальная дата регистрации товара из всех категорий 
-- одного seller_id, потому что в предыдущем задании 
-- в том числе от количества продаваемых категорий зависел seller_type
------------------------------------------------------------------------------------------------------------------
--часть 2. 3
--если рассматривать только тех продавцов, которые были зарегистрированы в 2022 году (то есть минимальная дата регистрации по всем категориям)
--тогда ни один и продавцов не подходит под условие
--основываясь на ответе ментора от 20.11.2024 в 19:41, было решено рассматривать пары продавец-категория, которые были зарегистрированы в 2022
--то есть, условно, у продавца есть несколько дат регистрации, нам нужны такие продавцы, у которых из всех регистраций ровно две произошли в 2022
with seller_category_pair as (
    select
        seller_id,
        string_agg(distinct category, ' - ' order by category) as category_pair,  
        sum(revenue) as total_revenue,
        count(category) as category_count
    from public.sellers
    where extract(year from to_date(date_reg, 'DD/MM/YYYY')) = 2022
    group by seller_id
)
select
    seller_id,
    category_pair
from seller_category_pair
where category_count = 2
    and total_revenue > 75000  
order by seller_id;
