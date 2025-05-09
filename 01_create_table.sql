SELECT
  trx.transaction_id,
  trx.date,
  trx.branch_id,
  cab.branch_name,
  cab.kota,
  cab.provinsi,
  cab.rating AS rating_cabang,
  trx.customer_name,
  trx.product_id,
  prod.product_name,
  trx.price AS actual_price,
  trx.discount_percentage,
  
  -- Persentase Gross Laba
  CASE
    WHEN trx.price <= 50000 THEN 0.10
    WHEN trx.price <= 100000 THEN 0.15
    WHEN trx.price <= 300000 THEN 0.20
    WHEN trx.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- Perhitungan Nett Sales
  trx.price * (1 - trx.discount_percentage) AS nett_sales,

  -- Perhitungan Nett Profit
  (trx.price * (1 - trx.discount_percentage)) * 
  CASE
    WHEN trx.price <= 50000 THEN 0.10
    WHEN trx.price <= 100000 THEN 0.15
    WHEN trx.price <= 300000 THEN 0.20
    WHEN trx.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

  trx.rating AS rating_transaksi

FROM
  `rakamin-kf-analytics-458711.kimia_farma.kf_final_transaction` trx

JOIN
  `rakamin-kf-analytics-458711.kimia_farma.kf_kantor_cabang` cab
  ON trx.branch_id = cab.branch_id

JOIN
  `rakamin-kf-analytics-458711.kimia_farma.kf_product` prod
  ON trx.product_id = prod.product_id;
