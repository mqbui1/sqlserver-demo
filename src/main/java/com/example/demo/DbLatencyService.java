package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

@Service
public class DbLatencyService {

    private final DataSource dataSource;

    /**
     * Default delay if none is provided
     */
    @Value("${app.db-latency-seconds:5}")
    private int defaultDelaySeconds;

    public DbLatencyService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public String getGreeting(Integer delaySeconds) {
        int delay = (delaySeconds != null) ? delaySeconds : defaultDelaySeconds;

        try (Connection conn = dataSource.getConnection();
             CallableStatement stmt =
                     conn.prepareCall("{ call dbo.slow_greeting(?) }")) {

            stmt.setInt(1, delay);

            boolean hasResultSet = stmt.execute();

            if (hasResultSet) {
                try (ResultSet rs = stmt.getResultSet()) {
                    if (rs.next()) {
                        return rs.getString(1);
                    }
                }
            }

            return "No greeting returned";

        } catch (Exception e) {
            throw new RuntimeException("Failed to call dbo.slow_greeting", e);
        }
    }
}
