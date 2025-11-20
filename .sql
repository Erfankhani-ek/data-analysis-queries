WITH CinemaOnline AS (
    SELECT vc.Id
    FROM [Filmnet-Scrat].[dbo].[VideoContents] vc
    WHERE vc.Flag <> 256
      AND EXISTS (
          SELECT 1
          FROM [Filmnet-Scrat].[dbo].[VideoContentCategories] vcc
          WHERE vcc.ContentId = vc.Id
            AND vcc.CategoryId = '9ed5a382-6393-433a-8284-248c5dbce87d'   -- CinemaOnline category
      )
),
IsKids AS (
    SELECT vc.Id
    FROM [Filmnet-Scrat].[dbo].[VideoContents] vc
    WHERE vc.Id IN (
        SELECT vcc.ContentId
        FROM [Filmnet-Scrat].[dbo].[VideoContentCategories] vcc
        WHERE vcc.CategoryId IN (
            '9f36b765-9219-41cc-9d6b-fa56b22cd9be',
            '3ca473d2-05d0-442c-93ee-02b29e7174bd',
            '7227c12f-5e3e-4b1b-8677-fc3ee0185b03',
            '2948b784-ae81-495c-91dc-5a1733e51a16'
        )
    )
    AND vc.Id IN (
        SELECT vct.ContentId
        FROM [Filmnet-Scrat].[dbo].[VideoContentTags] vct
        WHERE vct.TagId IN (
            '9ca9c84c-d83a-46ac-9f4a-1fffa33c0345',
            '28dade47-65fd-48c3-931f-8f305d7fdab2'
        )
    )
),
FreeContents AS (
    SELECT vc.Id
    FROM [Filmnet-Scrat].[dbo].[VideoContents] vc
    WHERE (vc.Flag & 16) <> 0       -- free-flag bit
),

-- Merge old and new watch logs by date boundary
TotalWatch AS (
    SELECT *
    FROM dbo.UserWatchProfileStatistic WITH (NOLOCK)
    WHERE CAST(ActionTime AS date) >= '2024-03-20'

    UNION ALL

    SELECT *
    FROM [10.101.6.31].Watchstat.dbo.UserWatchProfileStatistic WITH (NOLOCK)
    WHERE CAST(ActionTime AS date) < '2024-03-20'
),

-- Enrich watch events with dimensions (subscription + content flags)
WatchWithDimensions AS (
    SELECT
        tw.ActionTime,
        tw.msisdn,
        tw.ContentId,
        tw.TotalWatchedTime,

        -- Subscription status at the time of watching
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM [Neptune_Subscription].[dbo].[Subscriptions] s
                WHERE s.msisdn = tw.msisdn
                  AND tw.ActionTime BETWEEN s.ActiveFrom AND s.ActiveTo
            ) THEN 'HasSubscription'
            ELSE 'NoSubscription'
        END AS SubscriptionStatus,

        -- Content type flags
        CASE
            WHEN co.Id IS NOT NULL THEN 'Yes' ELSE 'No'
        END AS IsCinemaOnline,

        CASE
            WHEN ik.Id IS NOT NULL THEN 'Yes' ELSE 'No'
        END AS IsKids,

        CASE
            WHEN fc.Id IS NOT NULL THEN 'Yes' ELSE 'No'
        END AS IsFreeContent
    FROM TotalWatch tw
    LEFT JOIN CinemaOnline co
        ON co.Id = tw.ContentId
    LEFT JOIN IsKids ik
        ON ik.Id = tw.ContentId
    LEFT JOIN FreeContents fc
        ON fc.Id = tw.ContentId
)

SELECT
    CAST(w.ActionTime AS date)              AS [Date],
    COUNT(*)                                AS [ViewCount],
    COUNT(DISTINCT w.msisdn)                AS [UserCount],
    SUM(w.TotalWatchedTime) / 60            AS [WatchedMinutes],
    w.SubscriptionStatus,
    w.IsCinemaOnline,
    w.IsKids,
    w.IsFreeContent
FROM WatchWithDimensions w
GROUP BY
    CAST(w.ActionTime AS date),
    w.SubscriptionStatus,
    w.IsCinemaOnline,
    w.IsKids,
    w.IsFreeContent
ORDER BY
    [Date],
    w.SubscriptionStatus,
    w.IsCinemaOnline,
    w.IsKids,
    w.IsFreeContent;
