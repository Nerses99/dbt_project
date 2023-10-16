WITH call_stages AS (
    SELECT
        id,
        MIN(CASE WHEN event_type = 'call queued' THEN start_time ELSE NULL END) AS queue_start,
        MIN(CASE WHEN event_type = 'call started' THEN start_time ELSE NULL END) AS call_start,
        MIN(CASE WHEN event_type LIKE 'call ended%' THEN start_time ELSE NULL END) AS call_end,
        MAX(CASE WHEN event_type LIKE 'call ended%' THEN event_type ELSE NULL END) AS call_end_status
    FROM 
        {{ ref('data') }}
    GROUP BY 
        id
),

call_durations AS (
    SELECT
        id,
        call_end_status,
        COALESCE(call_start, call_end) - queue_start AS queue_duration,
        call_end - COALESCE(call_start, queue_start) AS call_duration,
        call_end - queue_start AS total_duration
    FROM 
        call_stages
    WHERE
        call_end IS NOT NULL AND queue_start IS NOT NULL
)

SELECT
    *,
    RANK() OVER (ORDER BY total_duration DESC) as rank_by_total_duration,
    RANK() OVER (ORDER BY queue_duration DESC) as rank_by_queue_duration,
    RANK() OVER (ORDER BY call_duration DESC) as rank_by_call_duration
FROM
    call_durations