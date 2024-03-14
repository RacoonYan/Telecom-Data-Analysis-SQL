# Telecom-Data-Analysis-SQL



## Question 1 

Wild West wants to know the monthly domestic message revenue by sales region, sales office and sales person. They want this information for business customers and need to see the total number of messages, minutes, and revenue for each salesperson assigned to the customer and totals for each sales office.

<details>
  <summary>Click to expand answer!</summary>

  ##### Answer
```sql
WITH
    rev_sale_rep AS (
        SELECT
            SALES_REP_NO,
            ROUND(SUM(COALESCE(REV_AMT, 0)), 2) as month_rev,
            ROUND(SUM(REV_MIN + ROUND(REV_SEC / 60, 2)), 2) as month_min,
            COUNT(*) as num_message
        FROM
            REPASSGN
            LEFT JOIN BMSG9901 ON (
                BILL_AREA_CODE = AREA_CODE
                AND BILL_EXCHANGE = EXCHANGE
                AND BILL_LINE = LINE
            )
        WHERE
            TERM_ST NOT IN (
                SELECT
                    state_code
                FROM
                    domestic_states
            )
            AND TRIM(TERM_ST) <> ''
        GROUP BY
            SALES_REP_NO
    ),
    month_rev_rep AS (
        SELECT
            REP_FIRST_NAME,
            REP_LAST_NAME,
            REP_OFFICE,
            REP_REGION,
            COALESCE(month_rev, 0) as monthly_rev,
            month_min,
            num_message
        FROM
            SALESREP
            LEFT JOIN rev_sale_rep USING (SALES_REP_NO)
    )
SELECT
    REP_OFFICE,
    SUM(monthly_rev) as office_rev
FROM
    month_rev_rep
GROUP BY
    REP_OFFICE
ORDER BY
    office_rev desc
```

</details>
</p>

<details>
  <summary>Click to expand expected results!</summary>

  ##### Expected Results:

 | REP_OFFICE     | OFFICE_REV |
 | -------------- | ---------- |
 | Casper         | 11793.08   |
 | Portland       | 10202.11   |
 | San Francisco  | 9333.58    |
 | Honolulu       | 9294.64    |
 | Phoenix        | 8727.30    |
 | Laramie        | 8607.97    |
 | Santa Barbara  | 8392.10    |
 | Denver         | 8160.93    |
 | Flagstaff      | 7541.14    |
 | Los Angeles    | 7326.12    |
 | Seattle        | 7232.06    |
 | Salt Lake City | 6708.09    |
 | Palm Springs   | 6360.74    |
 | Helena         | 6044.99    |
 | San Diego      | 5372.07    |
 | Sacramento     | 5164.36    |
 | Nome           | 5094.68    |
 | Rock Springs   | 5038.50    |
 | Albuquerque    | 4962.74    |
 | Fairbanks      | 4910.11    |
 | Eugene         | 4813.94    |
 | Tucson         | 4285.98    |
 | Butte          | 3477.09    |
 | Santa Fe       | 2700.16    |
 | Spokane        | 2374.88    |

 </details>
</p>