--FRIST-HOMEWORK

use BikeStores
-- 1)  Numero de Clientes que viven en California, New jersey, y New york.
-- => California
SELECT COUNT(*) as num_customers, state, city
FROM sales.customers
WHERE state = 'CA'
GROUP BY state, city;

SELECT COUNT(*) as num_customers, state
FROM sales.customers
WHERE state = 'CA'
GROUP BY state;

-- => New York
SELECT COUNT(*) as num_customers, state, city
FROM sales.customers
WHERE state = 'NY'
GROUP BY state, city;

SELECT COUNT(*) as num_customers, state
FROM sales.customers
WHERE state = 'NY'
GROUP BY state;

-- => New Jersey; En la tabla customers no hay new jersey 
SELECT COUNT(*) as num_customers, state, city
FROM sales.customers
WHERE state = 'NJ'
GROUP BY state, city;

SELECT COUNT(*) as num_customers, state
FROM sales.customers
WHERE state = 'NJ'
GROUP BY state;
go

/*
--  2)  ¿Cuanto fue el ingreso entre Abril y Junio 2016 para la Sucursal 1?
*/
Use BikeStores
SELECT st.store_id, store_name,
       YEAR(shipped_date) AS [Año],
       MONTH(shipped_date) AS [Mes],
       SUM(quantity) AS [Cantidad de Productos],
       SUM(list_price) AS [Subtotal de Precios],
       SUM(discount) AS [Subtotal de Descuento],
       SUM(quantity * list_price * discount) AS [Total de la orden]
FROM sales.stores st
JOIN sales.orders so ON st.store_id = so.store_id
JOIN sales.order_items soi ON so.order_id = soi.order_id
WHERE st.store_id = 1
AND shipped_date IS NOT NULL
AND YEAR(shipped_date) = 2016
AND MONTH(shipped_date) >= 4 
and MONTH(shipped_date) <= 6
GROUP BY st.store_id, store_name, YEAR(shipped_date), MONTH(shipped_date)
WITH ROLLUP;
go

/*
-- 3)  Ingresos por mes y año para la sucursal 1 con subtotales por año y un gran total.
*/
Use BikeStores
SELECT st.store_id, store_name,
       YEAR(shipped_date) AS [Año],
       MONTH(shipped_date) AS [Mes],
       SUM(quantity) AS [Cantidad de Productos],
       SUM(list_price) AS [Subtotal de Precios],
       SUM(discount) AS [Subtotal de Descuento],
       SUM(quantity * list_price * discount) AS [Total de la orden]
FROM sales.stores st
JOIN sales.orders so ON st.store_id = so.store_id
JOIN sales.order_items soi ON so.order_id = soi.order_id
WHERE st.store_id = 1
AND shipped_date IS NOT NULL
GROUP BY st.store_id, store_name, YEAR(shipped_date), MONTH(shipped_date)
WITH ROLLUP;
go

/*
-- 4)  Lo mismo que #3 pero mostrando es info para todas las sucursales.
*/
Use BikeStores
SELECT st.store_id, store_name,
       YEAR(shipped_date) AS [Año],
       MONTH(shipped_date) AS [Mes],
       SUM(quantity) AS [Cantidad de Productos],
       SUM(list_price) AS [Subtotal de Precios],
       SUM(discount) AS [Subtotal de Descuento],
       SUM(quantity * list_price * discount) AS [Total de la orden]
FROM sales.stores st
JOIN sales.orders so ON st.store_id = so.store_id
JOIN sales.order_items soi ON so.order_id = soi.order_id
WHERE st.store_id = 1
AND shipped_date IS NOT NULL
GROUP BY st.store_id, store_name, YEAR(shipped_date), MONTH(shipped_date)
WITH ROLLUP;
go

--5-.El producto más vendido por cada categoría y cuánto $ represento
--   en cada sucursal
     SELECT p.category_id, p.product_name, so.store_id, SUM(p.list_price * s.quantity) AS Total_Sales
	 FROM production.products p join sales.order_items s ON p.product_id = s.product_id
	 join sales.orders so ON s.order_id = so.order_id 
	 GROUP BY p.category_id, p.product_id, so.store_id, p.product_name
	 ORDER BY SUM(p.list_price) DESC 

--6-. Ingresos de la sucursual 1, desglosados por año, trimestre y mes

		SELECT 
		YEAR (so.order_date) AS _YEAR,
		DATEPART(QUARTER,so.order_date) AS Trist,
		MONTH(so.order_date) AS MES,
		SUM(p.list_price * s.quantity) AS Total_Sales
		FROM production.products p JOIN sales.order_items s ON p.product_id = s.product_id
			JOIN sales.orders so ON s.order_id = so.order_id WHERE so.store_id = 1
			GROUP BY
			YEAR(so.order_date),
			DATEPART(QUARTER,so.order_date),
			MONTH(so.order_date)

--7-. Igual pero para todas las sucursales
SELECT 
		YEAR (so.order_date) AS _YEAR,
		DATEPART(QUARTER,so.order_date) AS Trist,
		MONTH(so.order_date) AS MES,
		so.store_id,
		SUM(p.list_price * s.quantity) AS Total_Sales
		FROM production.products p JOIN sales.order_items s ON p.product_id = s.product_id
			JOIN sales.orders so ON s.order_id = so.order_id
			GROUP BY
			so.store_id,
			YEAR(so.order_date),
			DATEPART(QUARTER,so.order_date),
			MONTH(so.order_date)
			ORDER BY
			so.store_id,
			_YEAR,
			Trist,
			MES


-- 8. Listar todas las ordenes de compras procesadas (finalizadas) 
--    y su importe para a aquellas de Abril 2016.
Select * From sales.orders;
Select * From sales.order_items;

Select so.order_id, order_status, shipped_date, 
		item_id, product_id, quantity, list_price, discount,
		quantity * list_price * discount as [Total de la orden]
From sales.orders so INNER JOIN sales.order_items soi ON so.order_id = soi.order_id 
Where order_status = 4;

-- 9. La información del Cliente de la orden 1150.
Select * From sales.orders;
Select * From sales.customers;

Select sc.customer_id, first_name, last_name, phone, email, street, city, state, zip_code,
		order_id, order_status
From sales.orders so INNER JOIN sales.customers sc ON so.customer_id = sc.customer_id
Where order_id = 1150;