package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    private final DbLatencyService dbLatencyService;

    public HelloController(DbLatencyService dbLatencyService) {
        this.dbLatencyService = dbLatencyService;
    }

    /**
     * Simple endpoint to demonstrate:
     * - HTTP server span
     * - JDBC client span
     * - Artificial DB latency
     *
     * Visible automatically in Splunk APM.
     */
    @GetMapping("/hello")
    public String hello() {
        return dbLatencyService.fetchGreeting();
    }
}
