package com.marvin.example.blogapp.exceptions;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler
    public String handleUserNotFoundException(Exception e, Model model) {

        if (e instanceof UserNotFoundException || e instanceof PostNotFoundException) {
            model.addAttribute("message", e.getMessage());
        }

        else{
            model.addAttribute("message", "Oops, something went wrong.");
        }

        return "error";
    }


}
