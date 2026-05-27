package com.example.store.controller;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.HashMap;
import java.util.Map;

@Controller
public class ErrorHandlerController implements ErrorController {

    @GetMapping("/error")
    public Map<String, String> handleError(HttpServletRequest request) {
        Map<String, String> error = new HashMap<>();
        error.put("timestamp", String.valueOf(System.currentTimeMillis()));
        error.put("status", String.valueOf(request.getAttribute("javax.servlet.error.status_code")));
        error.put("error", (String) request.getAttribute("javax.servlet.error.message"));
        error.put("path", request.getRequestURI());
        return error;
    }
}
