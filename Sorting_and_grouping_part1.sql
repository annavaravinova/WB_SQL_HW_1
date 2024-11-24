--ДЗ по SQL: Sorting and grouping
--часть 1. 1
select 
    u.city, u.age, 
    count(u.age) as num_buyers
from public.users u
group by u.city, u.age
order by num_buyers desc;
--для каждого города есть только уникальные возрастные группы, таким образом получается, что строк 100, как и в изначальном датасете

select 
    u.city,  
    case  
        when u.age between 0 and 20 then 'young'
        when u.age between 21 and 49 then 'adult'
        when u.age >= 50 then 'old'
    end as age_category,
    count(*) as num_buyers
from public.users u
group by u.city, age_category
order by num_buyers desc;
--при группировке на более расширенные группы, строк все равно оказалось 99
--для проверки можно посмотреть, сколько уникальных городов вообще есть в датасете
--select count(distinct city) from users;
--их 99, поэтому только для города Spokane в категории оказалось два человека
---------------------------------------------------------------------------------
--часть 1. 2

select 
    round(avg(p.price), 2) as avg_price, p.category
from public.products p 
where lower(p.name) like '%hair%' or lower(p.name) like '%home%'
group by p.category;
--отфильтруем датасет и оставим только товары, в которых присутствуют слова «hair» или «home»
--сгруппируем по категориям, и для категории найдем среднее, округляем при помощи round