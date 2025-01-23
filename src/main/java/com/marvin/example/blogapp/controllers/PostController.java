package com.marvin.example.blogapp.controllers;

import com.marvin.example.blogapp.models.Post;
import com.marvin.example.blogapp.models.Topic;
import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.services.PostService;
import com.marvin.example.blogapp.services.TopicService;
import com.marvin.example.blogapp.services.UserService;
import jakarta.validation.Valid;
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
@RequestMapping("/posts")
public class PostController {
    private final PostService postService;
    private final UserService userService;
    private final TopicService topicService;

    public PostController(PostService postService, UserService userService, TopicService topicService) {
        this.postService = postService;
        this.userService = userService;
        this.topicService = topicService;
    }

    @GetMapping("/new")
    public String newPost(@ModelAttribute("blogPost") Post post, Model model, Principal principal) {
        model.addAttribute("currentUser", userService.findByEmail(principal.getName()));
        model.addAttribute("allTopics", topicService.getAllTopics());
        return "createPost";
    }

    @PostMapping("/new")
    public String createPost(@Valid @ModelAttribute("blogPost") Post post, BindingResult bindingResult, Model model, Principal principal,
                             @RequestParam(value = "postImageFile", required = false) MultipartFile multipartFile)throws IOException {

        User currentUser = userService.findByEmail(principal.getName());
        model.addAttribute("currentUser",currentUser);
        if (bindingResult.hasErrors()) {
            model.addAttribute("allTopics", topicService.getAllTopics());
            return "createPost";
        }

        if(multipartFile != null && !multipartFile.isEmpty()) {
            String fileName = StringUtils.cleanPath(multipartFile.getOriginalFilename());
            if (fileName != null) {
                String fileExtension = StringUtils.getFilenameExtension(fileName);
                String uniqueFileName = UUID.randomUUID().toString() + "." + fileExtension;

                String imageURL = "/uploads/posts/" + uniqueFileName;
                post.setImageUrl(imageURL);

                String uploadDir = "./uploads/posts/";
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

        Topic topic = topicService.findTopicByName(post.getTopic().getName());
        post.setTopic(topic);
        post.setCreator(currentUser);
        postService.addPost(post);
        return "redirect:/user/home/1";
    }

}
