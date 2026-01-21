package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class DbLatencyService {

    private final JdbcTemplate jdbcTemplate;

    /**
     * Database latency in seconds (default: 20).
     */
    @Value("${app.db-latency-seconds:20}")
    private int dbLatencySeconds;

    public DbLatencyService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    /**
     * Executes a real database query with artificial latency added
     * using SQL Server WAITFOR DELAY.
     *
     * The delay occurs inside the same JDBC call so the span
     * duration reflects true database time.
     */
    public String fetchGreetingWithLatency() {

        String sql = String.format("""
            WAITFOR DELAY '00:00:%02d';
            SELECT message FROM greetings WHERE id = 1;
            """, dbLatencySeconds);

        return jdbcTemplate.queryForObject(sql, String.class);
    }
}
