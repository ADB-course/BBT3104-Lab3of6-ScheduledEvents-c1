-- CREATE EVN_average_customer_waiting_time_every_1_hour
CREATE TABLE `customer_service_kpi` (
`customer_service_KPI_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
`customer_service_KPI_average_waiting_time_minutes` INT NOT NULL,
PRIMARY KEY (`customer_service_KPI_timestamp`));
mysql> DELIMITER $$
mysql>
mysql> CREATE EVENT EVN_average_customer_waiting_time_every_1_hour
    -> ON SCHEDULE EVERY 1 HOUR
    -> STARTS CURRENT_TIMESTAMP
    -> ON COMPLETION PRESERVE
    -> DO
    -> BEGIN
    ->     -- Insert a new record into the customer_service_kpi table
    ->     INSERT INTO customer_service_kpi (
    ->         customer_service_kpi_time,
    ->         average_waiting_time_minutes
    ->     )
    ->     SELECT
    ->         CURRENT_TIMESTAMP,  -- Timestamp of KPI computation
    ->         AVG(
    ->             TIMESTAMPDIFF(MINUTE, customer_service_ticket_raise_time, 
    ->             COALESCE(customer_service_ticket_resolved_time, CURRENT_TIMESTAMP))
    ->         ) AS avg_wait_time  -- Calculating average waiting time
    ->     FROM
    ->         customer_service_ticket
    ->     WHERE
    ->         customer_service_ticket_raise_time >= NOW() - INTERVAL 1 HOUR;
    -> END$$