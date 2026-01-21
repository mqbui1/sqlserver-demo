package com.example.demo;

import com.example.demo.DbLatencyService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    private final DbLatencyService dbLatencyService;

    public HelloController(DbLatencyService dbLatencyService) {
        this.dbLatencyService = dbLatencyService;
    }

    @GetMapping("/hello")
    public String hello() {
        return dbLatencyService.getGreetingWithDbLatency();
    }
}
