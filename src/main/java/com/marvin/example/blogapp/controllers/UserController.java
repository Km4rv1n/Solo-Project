package com.marvin.example.blogapp.controllers;

import com.marvin.example.blogapp.exceptions.UserNotFoundException;
import com.marvin.example.blogapp.models.Post;
import com.marvin.example.blogapp.models.Report;
import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.services.PostService;
import com.marvin.example.blogapp.services.ReportService;
import com.marvin.example.blogapp.services.TopicService;
import com.marvin.example.blogapp.services.UserService;
import com.marvin.example.blogapp.validators.UserValidator;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
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
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/user")
public class UserController {
    private final UserService userService;
    private final UserValidator userValidator;
    private final UserDetailsService userDetailsService;
    private final TopicService topicService;
    private final PostService postService;
    private final ReportService reportService;

    public UserController(UserService userService, UserValidator userValidator, UserDetailsService userDetailsService, TopicService topicService, PostService postService, ReportService reportService) {
        this.userService = userService;
        this.userValidator = userValidator;
        this.userDetailsService = userDetailsService;
        this.topicService = topicService;
        this.postService = postService;
        this.reportService = reportService;
    }

    @GetMapping("/home/{pageNumber}")
    public String home(Principal principal, Model model, @PathVariable("pageNumber") int pageNumber) {
        User currentUser = userService.findByEmail(principal.getName());
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("popularTopics", topicService.getTop10Topics(currentUser));

        Page<Post> posts = postService.postsPerPage(pageNumber-1, currentUser);
        int totalPages = posts.getTotalPages();
        Map<Integer, Integer> filteredLikesCount = postService.getFilteredLikesCount(posts.stream().toList(), currentUser);
        Map<Integer, Integer> filteredCommentsCount = postService.getFilteredCommentsCount(posts.stream().toList(), currentUser);
        model.addAttribute("filteredLikesCount", filteredLikesCount);
        model.addAttribute("filteredCommentsCount", filteredCommentsCount);
        model.addAttribute("posts", posts);
        model.addAttribute("totalPages", totalPages);
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
                    Path filePath = uploadPath.resolve(uniqueFileName);
                    Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
                } catch (IOException e) {
                    throw new IOException("Could not save uploaded file: " + fileName);
                }
            }
        }
        else {
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

    @GetMapping("/{id}")
    public String viewUserProfile(Principal principal, Model model, @PathVariable Integer id) {
        User currentUser = userService.findByEmail(principal.getName());
        User user = userService.findById(id);

        if (currentUser.getBlockedUsers().contains(user) || user.getBlockedUsers().contains(currentUser) || user.isBanned()) {
            throw new UserNotFoundException("User Not Found!");
        }

        if(currentUser.equals(user)){
            return "redirect:/user/personal-profile";
        }

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("user", user);
        return "userProfile";
    }

    @PostMapping("/block/{id}")
    public String blockUser(Principal principal, Model model,@PathVariable Integer id) {
        User currentUser = userService.findByEmail(principal.getName());
        User user = userService.findById(id);
        userService.blockUser(currentUser,user);
        return "redirect:/user/home/1";
    }

    @GetMapping("/blocked")
    public String showBlockedUsers(Principal principal, Model model) {
        User currentUser = userService.findByEmail(principal.getName());
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("blockedUsers",currentUser.getBlockedUsers());
        return "blockedUsers";
    }

    @DeleteMapping("/unblock/{id}")
    public String unblockUser(Principal principal, Model model, @PathVariable Integer id) {
        User currentUser = userService.findByEmail(principal.getName());
        User user = userService.findById(id);
        userService.unblockUser(currentUser,user);
        return "redirect:/user/blocked";
    }

    @GetMapping("/report/{userId}")
    public String showReportUserForm(@ModelAttribute("report") Report report, Principal principal, Model model, @PathVariable("userId") Integer id) {
        User currentUser = userService.findByEmail(principal.getName());
        User reportedUser = userService.findById(id);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("reportedUser", reportedUser);
        return "reportUser";
    }

    @PostMapping("/report/{userId}")
    public String reportUser(@Valid @ModelAttribute("report") Report report, BindingResult bindingResult, Principal principal, Model model,@PathVariable("userId") Integer id) {

        if(bindingResult.hasErrors()) {
            model.addAttribute("currentUser",  userService.findByEmail(principal.getName()));
            model.addAttribute("reportedUser", userService.findById(id));
            return "reportUser";
        }
        User currentUser = userService.findByEmail(principal.getName());
        User reportedUser = userService.findById(id);
        reportService.createReport(currentUser,reportedUser,report);
        return "redirect:/user/home/1";
    }

    @GetMapping("/my-reports/{pageNumber}")
    public String showMyReports(Principal principal, Model model, @PathVariable("pageNumber") int pageNumber) {
        User currentUser = userService.findByEmail(principal.getName());
        Page<Report> userReports = reportService.getUserReports(pageNumber-1,currentUser);
        int totalPages = userReports.getTotalPages();
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("userReports", userReports);
        model.addAttribute("totalPages", totalPages);
        return "myReports";
    }
}
