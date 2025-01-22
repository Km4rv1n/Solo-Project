package com.marvin.example.blogapp.controllers;

import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.services.UserService;
import com.marvin.example.blogapp.validators.UserValidator;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.Objects;

@Controller
public class AuthController {
    private final UserService userService;
    private final UserValidator userValidator;

    public AuthController(UserService userService, UserValidator userValidator) {
        this.userService = userService;
        this.userValidator = userValidator;
    }

    @GetMapping("/register")
    public String registerForm(@ModelAttribute("user") User user) {
        return "registration";
    }

    @PostMapping("/register")
    public String registration(@Valid @ModelAttribute("user") User user, BindingResult result, Model model, HttpSession session) {
        userValidator.validate(user, result);
        if (result.hasErrors()) {
            return "registration";
        }
        userService.addUser(user);
        return "redirect:/login?success=true";
    }

    @GetMapping("/login")
    public String login(@RequestParam(value="error", required=false) String error, @RequestParam(value="logout", required=false) String logout,@RequestParam(value = "success", required = false) String success, Model model) {
        if(Objects.nonNull(error)) {
            model.addAttribute("errorMessage", "Invalid Credentials, Please try again.");
        }
        if(Objects.nonNull(logout)) {
            model.addAttribute("logoutMessage", "Logout Successful!");
        }
        if(Objects.nonNull(success)) {
            model.addAttribute("successMessage", "Successful registration. Log in with your new credentials.");
        }
        return "login";
    }
}
