# Frequently Asked Questions (FAQ)

## General

### What is Seymour MiningCore?

Seymour MiningCore is a modern, self-hosted command center that works
alongside MiningCore to provide real-time monitoring, analytics, and
visualization for solo cryptocurrency mining.

------------------------------------------------------------------------

### Does Seymour MiningCore replace MiningCore?

No. MiningCore performs the mining pool functions. Seymour MiningCore
consumes MiningCore's REST API and presents the information in an
interactive dashboard.

------------------------------------------------------------------------

### Is Seymour MiningCore free?

The project is intended to be open source. Refer to the project license
for current licensing information.

------------------------------------------------------------------------

## Mining

### Why is my Expected Solo Time so long?

Expected Solo Time is a statistical average based on your hashrate
compared to the total network hashrate. It is not a prediction and can
vary significantly.

------------------------------------------------------------------------

### Why does my hashrate change?

MiningCore estimates hashrate from submitted shares. Short-term
fluctuations are normal.

------------------------------------------------------------------------

### Why don't I see my miner?

Check:

-   Wallet address
-   Worker name
-   Stratum connection
-   MiningCore status
-   API connectivity

------------------------------------------------------------------------

### Why is my worker marked offline?

Possible causes include:

-   Miner powered off
-   Network interruption
-   Incorrect pool configuration
-   MiningCore unavailable

------------------------------------------------------------------------

### What does Shares per Second mean?

Shares per Second indicates how frequently your miner is submitting
valid shares to the pool. It is one indicator of miner activity.

------------------------------------------------------------------------

## Dashboard

### Why are charts empty?

Verify:

-   MiningCore API is running.
-   Historical performance data exists.
-   Browser access to the API is working.

------------------------------------------------------------------------

### What is Fleet Health?

Fleet Health summarizes the overall operational condition of your mining
fleet based on worker status and live metrics.

------------------------------------------------------------------------

### What is the Block Race Meter?

The Block Race Meter is a visualization that helps miners understand
progress through the current network block interval. It is educational
and should not be interpreted as a predictor of when the next block will
be found.

------------------------------------------------------------------------

### What is TV Mode?

TV Mode is a full-screen dashboard designed for continuous display on
monitors in mining rooms or operations centers.

------------------------------------------------------------------------

## Installation

### Does this work on Raspberry Pi?

Yes. ARM64 support is a primary development target.

------------------------------------------------------------------------

### Does this support Docker?

Yes.

------------------------------------------------------------------------

### Can I run multiple coins?

The architecture is designed for multi-coin support. Bitcoin Cash is
currently supported, with additional coins planned.

------------------------------------------------------------------------

## Future

### Will remote monitoring be supported?

Yes. Remote monitoring is planned for a future release.

### Will mobile devices be supported?

Responsive layouts already exist, with additional mobile enhancements
planned.

------------------------------------------------------------------------

# Related Documentation

-   installation.md
-   configuration.md
-   dashboard.md
-   roadmap.md

------------------------------------------------------------------------

Built for the Seymour MiningCore project.
