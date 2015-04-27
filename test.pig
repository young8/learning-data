register file:/usr/local/Cellar/pig/0.14.0/libexec/lib/piggybank.jar;

RAW_LOGS = LOAD 'data/access.log' USING TextLoader as (line:chararray);

LOGS_BASE = FOREACH RAW_LOGS GENERATE
    FLATTEN(
      REGEX_EXTRACT_ALL(line, '(\\S+) - - \\[([^\\[]+)\\]\\s+"([^"]+)"\\s+(\\d+)\\s+(\\d+)\\s+"([^"]+)"\\s+"([^"]+)"\\s+"([^"]+)"\\s+(\\S+)')
    )
    AS (
        ip: chararray,
        timestamp: chararray,
        url: chararray,
        status: chararray,
        bytes: chararray,
        referrer: chararray,
        useragent: chararray,
        xfwd: chararray,
        reqtime: chararray
    );

A = FOREACH LOGS_BASE GENERATE timestamp;
--B = GROUP A BY (timestamp);
--C = FOREACH B GENERATE FLATTEN(group) as (timestamp), COUNT(A) as count;
--D = ORDER C BY timestamp,count desc;
STORE A into 'analytics.log';