package com.example.demo;

import com.example.demo.DbLatencyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    private static final Logger log = LoggerFactory.getLogger(HelloController.class);

    private final DbLatencyService dbLatencyService;

    public HelloController(DbLatencyService dbLatencyService) {
        this.dbLatencyService = dbLatencyService;
    }

    @GetMapping("/hello")
    public String hello() {
        log.info("Received /hello request — executing DB query with latency");

        String greeting = dbLatencyService.fetchGreetingWithLatency();

        log.info("DB query completed");

        return greeting;
    }
}
