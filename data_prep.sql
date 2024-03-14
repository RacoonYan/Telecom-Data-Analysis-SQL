WILDWEST_MYCOPY.PROCESSED.ADIASSIGNCREATE
OR REPLACE VIEW domestic_states (STATE_CODE) AS
SELECT
    STATE_CODE
FROM
    ST_CTRY_NEW
WHERE
    ST_CNTRY_DESC IN (
        'ALASKA',
        'HAWAII',
        'OREGON',
        'WASHINGTON',
        'ARIZONA',
        'CALIFORNIA',
        'NEW MEXICO',
        'UTAH',
        'COLORADO',
        'IDAHO',
        'MONTANA',
        'WYOMING'
    );

CREATE
OR REPLACE VIEW business_cus_domestic_state_revenue (
    BILL_AREA_CODE,
    BILL_EXCHANGE,
    BILL_LINE,
    REV_AMT,
    REV_MIN,
    STATE
) AS
SELECT
    BILL_AREA_CODE,
    BILL_EXCHANGE,
    BILL_LINE,
    REV_AMT,
    REV_MIN,
    STATE
FROM
    BMSG9901
    LEFT JOIN BUSCUST ON BILL_AREA_CODE = AREA_CODE
    AND BILL_EXCHANGE = EXCHANGE
    AND BILL_LINE = LINE
WHERE
    STATE IN (
        SELECT
            STATE_CODE
        FROM
            domestic_states
    );

---Business cus domestic revenue 99-01
CREATE
OR REPLACE VIEW business_cus_domestic_state_revenue_9902 (
    BILL_AREA_CODE,
    BILL_EXCHANGE,
    BILL_LINE,
    REV_AMT,
    REV_MIN,
    STATE
) AS
SELECT
    BILL_AREA_CODE,
    BILL_EXCHANGE,
    BILL_LINE,
    REV_AMT,
    REV_MIN,
    STATE
FROM
    BMSG9902
    LEFT JOIN BUSCUST ON BILL_AREA_CODE = AREA_CODE
    AND BILL_EXCHANGE = EXCHANGE
    AND BILL_LINE = LINE
WHERE
    STATE IN (
        SELECT
            STATE_CODE
        FROM
            domestic_states
    );

---Business cus domestic revenue 99-02
CREATE VIEW
    business_cus_domestic_state_revenue_9903 (
        BILL_AREA_CODE,
        BILL_EXCHANGE,
        BILL_LINE,
        REV_AMT,
        REV_MIN,
        STATE
    ) AS
SELECT
    BILL_AREA_CODE,
    BILL_EXCHANGE,
    BILL_LINE,
    REV_AMT,
    REV_MIN,
    STATE
FROM
    BMSG9903
    LEFT JOIN BUSCUST ON BILL_AREA_CODE = AREA_CODE
    AND BILL_EXCHANGE = EXCHANGE
    AND BILL_LINE = LINE
WHERE
    STATE IN (
        SELECT
            STATE_CODE
        FROM
            domestic_states
    )
    ---Business cus domestic revenue 99-03
CREATE VIEW
    sales_domestic_business_month_revenue_9902 (
        SALES_REP_NO,
        REP_FIRST_NAME,
        REP_LAST_NAME,
        REP_OFFICE,
        REP_REGION,
        month_revenue
    ) AS
WITH
    sales_domestic_month_revenue AS (
        SELECT
            SALES_REP_NO as REP_NO,
            COALESCE(SUM(REV_AMT), 0) as month_revenue
        FROM
            BUSINESS_CUS_DOMESTIC_STATE_REVENUE_9902
            RIGHT JOIN REPASSGN ON BILL_AREA_CODE = AREA_CODE
            AND BILL_EXCHANGE = EXCHANGE
            AND BILL_LINE = LINE
        GROUP BY
            SALES_REP_NO
    )
SELECT
    SALES_REP_NO,
    REP_FIRST_NAME,
    REP_LAST_NAME,
    REP_OFFICE,
    REP_REGION,
    month_revenue
FROM
    SALESREP
    LEFT JOIN sales_domestic_month_revenue ON SALES_REP_NO = REP_NO
    ----sales_domestic_business_month_revenue_9902
CREATE VIEW
    sales_domestic_business_month_revenue_9903 (
        SALES_REP_NO,
        REP_FIRST_NAME,
        REP_LAST_NAME,
        REP_OFFICE,
        REP_REGION,
        month_revenue
    ) AS
WITH
    sales_domestic_month_revenue AS (
        SELECT
            SALES_REP_NO as REP_NO,
            COALESCE(SUM(REV_AMT), 0) as month_revenue
        FROM
            BUSINESS_CUS_DOMESTIC_STATE_REVENUE_9903
            RIGHT JOIN REPASSGN ON BILL_AREA_CODE = AREA_CODE
            AND BILL_EXCHANGE = EXCHANGE
            AND BILL_LINE = LINE
        GROUP BY
            SALES_REP_NO
    )
SELECT
    SALES_REP_NO,
    REP_FIRST_NAME,
    REP_LAST_NAME,
    REP_OFFICE,
    REP_REGION,
    month_revenue
FROM
    SALESREP
    LEFT JOIN sales_domestic_month_revenue ON SALES_REP_NO = REP_NO
    ----sales_domestic_business_month_revenue_9903
SELECT
CREATE VIEW
    residential_cus_domestic_state_revenue (
        BILL_AREA_CODE,
        BILL_EXCHANGE,
        BILL_LINE,
        REV_AMT,
        REV_MIN,
        STATE
    ) AS
SELECT
    BILL_AREA_CODE,
    BILL_EXCHANGE,
    BILL_LINE,
    REV_AMT,
    REV_MIN,
    STATE
FROM
    RMSG9906
    LEFT JOIN RESCUST ON BILL_AREA_CODE = AREA_CODE
    AND BILL_EXCHANGE = EXCHANGE
    AND BILL_LINE = LINE
WHERE
    STATE IN (
        SELECT
            STATE_CODE
        FROM
            domestic_states
    )
CREATE VIEW
    sales_domestic_residential_month_revenue (
        SALES_REP_NO,
        REP_FIRST_NAME,
        REP_LAST_NAME,
        REP_OFFICE,
        REP_REGION,
        month_revenue
    ) AS
WITH
    sales_domestic_month_revenue AS (
        SELECT
            SALES_REP_NO as REP_NO,
            COALESCE(SUM(REV_AMT), 0) as month_revenue
        FROM
            RESIDENTIAL_CUS_DOMESTIC_STATE_REVENUE
            RIGHT JOIN REPASSGN ON BILL_AREA_CODE = AREA_CODE
            AND BILL_EXCHANGE = EXCHANGE
            AND BILL_LINE = LINE
        GROUP BY
            SALES_REP_NO
    )
SELECT
    SALES_REP_NO,
    REP_FIRST_NAME,
    REP_LAST_NAME,
    REP_OFFICE,
    REP_REGION,
    month_revenue
FROM
    SALESREP
    LEFT JOIN sales_domestic_month_revenue ON SALES_REP_NO = REP_NO
CREATE VIEW
    sales_domestic_business_month_revenue (
        SALES_REP_NO,
        REP_FIRST_NAME,
        REP_LAST_NAME,
        REP_OFFICE,
        REP_REGION,
        month_revenue,
        month_rev_minutes,
        month_rev_message
    ) AS
WITH
    sales_domestic_month_revenue AS (
        SELECT
            SALES_REP_NO as REP_NO,
            COALESCE(SUM(REV_AMT), 0) as month_revenue,
            COALESCE(SUM(REV_MIN), 0) as month_rev_minutes,
            COUNT(REV_AMT) as month_rev_message
        FROM
            BUSINESS_CUS_DOMESTIC_STATE_REVENUE
            RIGHT JOIN REPASSGN ON BILL_AREA_CODE = AREA_CODE
            AND BILL_EXCHANGE = EXCHANGE
            AND BILL_LINE = LINE
        GROUP BY
            SALES_REP_NO
    )
SELECT
    SALES_REP_NO,
    REP_FIRST_NAME,
    REP_LAST_NAME,
    REP_OFFICE,
    REP_REGION,
    month_revenue,
    month_rev_minutes,
    month_rev_message
FROM
    SALESREP
    LEFT JOIN sales_domestic_month_revenue ON SALES_REP_NO = REP_NO