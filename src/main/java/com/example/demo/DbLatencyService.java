package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class DbLatencyService {

    private final JdbcTemplate jdbcTemplate;

    /**
     * How many seconds to delay the DB query.
     * Defaults to 20 if not provided.
     */
    @Value("${app.db-latency-seconds:20}")
    private int dbLatencySeconds;

    public DbLatencyService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    /**
     * Calls a SQL Server scalar UDF that performs the delay internally
     * and returns the greeting message.
     *
     * This produces a SINGLE JDBC span with ~dbLatencySeconds duration.
     */
    public String getGreetingWithDbLatency() {
        String sql = "SELECT dbo.slow_greeting(?)";

        return jdbcTemplate.queryForObject(
                sql,
                String.class,
                dbLatencySeconds
        );
    }
}
