package com.marvin.example.blogapp.config;

import com.marvin.example.blogapp.exceptions.BannedUserException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler {
    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception)
            throws IOException, ServletException {
        if (exception.getCause() instanceof BannedUserException) {
            response.sendRedirect("/login?banned=true");
        }
        else {
            response.sendRedirect("/login?error=true");
        }
    }
}