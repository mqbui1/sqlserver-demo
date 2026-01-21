package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class DbLatencyService {

    private final JdbcTemplate jdbcTemplate;

    /**
     * Configurable DB latency (seconds).
     * Default = 20 seconds if not set.
     *
     * Controlled via:
     *   app.db-latency-seconds
     *   or APP_DB_LATENCY_SECONDS
     */
    @Value("${app.db-latency-seconds:20}")
    private int dbLatencySeconds;

    /**
     * Safety cap to avoid accidental extreme delays
     */
    private static final int MAX_LATENCY_SECONDS = 60;

    public DbLatencyService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    /**
     * Adds artificial latency directly at the database layer
     * using SQL Server WAITFOR DELAY.
     */
    public void addDatabaseLatency() {
        int effectiveLatency = Math.min(dbLatencySeconds, MAX_LATENCY_SECONDS);

        if (effectiveLatency <= 0) {
            return; // latency disabled
        }

        String delay =
            "WAITFOR DELAY '00:00:" + String.format("%02d", effectiveLatency) + "'";

        jdbcTemplate.execute(delay);
    }

    /**
     * Example query method that includes latency.
     * Keeps latency logic centralized.
     */
    public String fetchGreeting() {
        addDatabaseLatency();

        return jdbcTemplate.queryForObject(
            "SELECT message FROM greetings WHERE id = 1",
            String.class
        );
    }
}
