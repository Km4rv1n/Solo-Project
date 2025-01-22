package com.marvin.example.blogapp.controllers;

import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.services.TopicService;
import com.marvin.example.blogapp.services.UserService;
import com.marvin.example.blogapp.validators.UserValidator;
import jakarta.validation.Valid;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.Principal;
import java.util.UUID;

@Controller
@RequestMapping("/user")
public class UserController {
    private final UserService userService;
    private final UserValidator userValidator;
    private final UserDetailsService userDetailsService;
    private final TopicService topicService;

    public UserController(UserService userService, UserValidator userValidator, UserDetailsService userDetailsService, TopicService topicService) {
        this.userService = userService;
        this.userValidator = userValidator;
        this.userDetailsService = userDetailsService;
        this.topicService = topicService;
    }

    @GetMapping("/home")
    public String home(Principal principal, Model model) {
        model.addAttribute("currentUser", userService.findByEmail(principal.getName()));
        model.addAttribute("popularTopics", topicService.getTop10Topics());
        return "home";
    }

    @GetMapping("/personal-profile")
    public String showPersonalProfile(Principal principal, Model model) {
        model.addAttribute("user", userService.findByEmail(principal.getName()));
        model.addAttribute("currentUser", userService.findByEmail(principal.getName())); //for navbar
        return "personalProfile";
    }

    @PutMapping("/personal-profile")
    public String updatePersonalProfile(@Valid @ModelAttribute(name = "user") User user, BindingResult bindingResult,
                                        Principal principal, Model model,
                                        @RequestParam(value = "profilePictureFile", required = false) MultipartFile multipartFile) throws IOException {

        model.addAttribute("currentUser", userService.findByEmail(principal.getName())); //for navbar

        User existingUser = userService.findByEmail(principal.getName());

        user.setId(existingUser.getId());
        user.setRole(existingUser.getRole());
        user.setPassword(existingUser.getPassword());
        user.setCreatedAt(existingUser.getCreatedAt());

        if(multipartFile != null && !multipartFile.isEmpty()) {
            String fileName = StringUtils.cleanPath(multipartFile.getOriginalFilename());
            if (fileName != null) {
                String fileExtension = StringUtils.getFilenameExtension(fileName);
                String uniqueFileName = UUID.randomUUID().toString() + "." + fileExtension;

                String imageURL = "/uploads/profilePictures/" + uniqueFileName;
                user.setProfilePictureUrl(imageURL);

                String uploadDir = "./uploads/profilePictures/";
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                try (InputStream inputStream = multipartFile.getInputStream()) {
                    // construct file path
                    Path filePath = uploadPath.resolve(uniqueFileName);
                    Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
                } catch (IOException e) {
                    throw new IOException("Could not save uploaded file: " + fileName);
                }
            }
        }
        else {
        // Retain the existing profile picture URL if no new picture is uploaded
            user.setProfilePictureUrl(existingUser.getProfilePictureUrl());
        }

            userValidator.validate(user, bindingResult);

        if (bindingResult.hasErrors()) {
            return "personalProfile";
        }

        userService.saveUser(user);

        UserDetails updatedUser = userDetailsService.loadUserByUsername(user.getEmail());
        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                updatedUser,
                updatedUser.getPassword(),
                updatedUser.getAuthorities()
        );
        SecurityContextHolder.getContext().setAuthentication(authentication);

        return "redirect:/user/personal-profile";
    }
}
