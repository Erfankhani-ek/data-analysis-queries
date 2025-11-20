Daily Watch Statistics - Subscription & Content Analysis

This query is designed to provide valuable insights into user behavior and content engagement by aggregating daily statistics for different content types and user subscription statuses. The goal is to enable data-driven decision-making for content strategy, subscription management, and personalized user experiences.

Why Use This Query?

The purpose of this query is to analyze how different types of content are consumed by users with varying subscription statuses. By combining detailed user and content data, we can uncover key patterns that inform business decisions in the following ways:

1. Content Engagement Analysis:

Identify which types of content (e.g., CinemaOnline, Kids, Free) drive the most engagement, in terms of views, unique users, and total watch time.

Understand the popularity of free versus premium content to make better decisions about content promotion, licensing, or future investments in specific genres or content categories.

Recognize emerging trends, such as shifts in demand for certain content types, enabling timely adjustments in content offerings.

2. Subscription Impact Analysis:

Track the behavior of users with and without subscriptions at the time of watching content.

Measure the impact of subscription on content consumption patterns — are subscribed users more likely to watch premium content or free content?

Assess whether certain types of content (like CinemaOnline or Kids content) perform better with certain user segments, helping to optimize pricing, targeting, and retention strategies for subscriptions.

3. Audience Segmentation for Targeted Actions:

Segmentation is key. This query helps to segment users into groups like “HasSubscription” and “NoSubscription” based on their viewing patterns. By doing so, we can better understand how users from these different segments interact with content, paving the way for more effective personalized content recommendations, marketing campaigns, and retention strategies.

For instance, users who frequently watch CinemaOnline content could be targeted with exclusive offers or bundles, while users who predominantly watch free content might be incentivized to upgrade to a paid subscription.

4. Engagement over Time:

By aggregating this data daily, the query helps to track how user engagement with different content types evolves over time, offering actionable insights into trends and seasonal patterns.

This insight is critical for understanding the long-term value of both free and premium content, as well as the retention and churn rates of subscribers.

Query Breakdown:

Content Types:

CinemaOnline: Content related to CinemaOnline, identified by a specific CategoryId.

Kids Content: Content intended for kids, identified by both CategoryId and TagId.

Free Content: Content that is available for free, identified by a specific flag (Flag).

User Types:

HasSubscription: Users who had an active subscription at the time of watching.

NoSubscription: Users who did not have an active subscription at the time of watching.

Data Sources:

This query aggregates watch logs from two different sources (current database and an older server) using UNION ALL.

Performance Metrics:

TotalWatch: Merges user watch logs from both data sources.

WatchWithDimensions: Enriches watch data by adding user subscription status and content type flags.

Final Output: For each day, the query calculates the total views, unique users, and total watch time (in minutes), while tagging each entry with the user's subscription status and the content type.

How the Query Works:

CinemaOnline: Identifies content related to CinemaOnline based on a specific CategoryId.

IsKids: Identifies kids' content by checking both CategoryId and TagId.

FreeContents: Identifies free content using a specific bit in the Flag.

TotalWatch: Combines user watch logs from both sources based on a date boundary (2024-03-20).

WatchWithDimensions: Combines the watch logs with subscription and content type data.

GROUP BY: Groups the data by date, subscription status, and content type.

Final Output: The query returns the number of views, unique users, and total watched minutes for each day, alongside information about the content type and user subscription status.

Query Output:

The final output of the query includes the following metrics:

Date: The date of the watch event.

ViewCount: Total number of views for the day.

UserCount: Total number of unique users for the day.

WatchedMinutes: Total time watched (in minutes) for the day.

SubscriptionStatus: Whether the user had an active subscription at the time of watching (HasSubscription or NoSubscription).

IsCinemaOnline: Whether the content is from CinemaOnline (Yes or No).

IsKids: Whether the content is categorized as kids' content (Yes or No).

IsFreeContent: Whether the content is free (Yes or No).

Use Cases:

Content Strategy: This query helps identify which types of content are driving the most engagement. This data can inform decisions on content acquisition, content creation, and content promotion strategies.

Subscription Management: By tracking user behavior with and without subscriptions, businesses can better understand what content drives users to convert to paid subscriptions or which types of content lead to churn.

Audience Targeting: Knowing which content appeals to which user segments helps in personalizing content recommendations and targeted marketing efforts.

Performance Tracking: Track the performance of content over time, and analyze how different content types perform on a daily or seasonal basis, enabling smarter marketing and content placement.
