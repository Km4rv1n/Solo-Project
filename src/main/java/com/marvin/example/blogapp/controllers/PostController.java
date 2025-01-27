package com.marvin.example.blogapp.controllers;

import com.marvin.example.blogapp.models.Comment;
import com.marvin.example.blogapp.models.Post;
import com.marvin.example.blogapp.models.Topic;
import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.services.CommentService;
import com.marvin.example.blogapp.services.PostService;
import com.marvin.example.blogapp.services.TopicService;
import com.marvin.example.blogapp.services.UserService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
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
    private final CommentService commentService;

    public PostController(PostService postService, UserService userService, TopicService topicService, CommentService commentService) {
        this.postService = postService;
        this.userService = userService;
        this.topicService = topicService;
        this.commentService = commentService;
    }

    @GetMapping("/new")
    public String newPost(@ModelAttribute("blogPost") Post post, Model model, Principal principal) {
        model.addAttribute("currentUser", userService.findByEmail(principal.getName()));
        model.addAttribute("allTopics", topicService.getAllTopics());
        return "createPost";
    }

    @PostMapping("/new")
    public String createPost(@Valid @ModelAttribute("blogPost") Post post, BindingResult bindingResult, Model model, Principal principal,
                             @RequestParam(value = "postImageFile", required = false) MultipartFile multipartFile) throws IOException {

        User currentUser = userService.findByEmail(principal.getName());
        model.addAttribute("currentUser", currentUser);
        if (bindingResult.hasErrors()) {
            model.addAttribute("allTopics", topicService.getAllTopics());
            return "createPost";
        }

        if (multipartFile != null && !multipartFile.isEmpty()) {
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

    @GetMapping("/logged-user/{pageNumber}")
    public String getPostsOfLoggedUser(Principal principal, Model model, @PathVariable("pageNumber") int pageNumber) {
        User currentUser = userService.findByEmail(principal.getName());
        Page<Post> postsOfCurrentUser = postService.postsPerPageByCreator(pageNumber - 1, currentUser);
        int totalPages = postsOfCurrentUser.getTotalPages();
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("userPosts", postsOfCurrentUser);
        model.addAttribute("totalPages", totalPages);
        return "myPosts";
    }

    @DeleteMapping("/delete/{id}")
    public String deletePost(@PathVariable("id") Integer id) {
        postService.deletePostById(id);
        return "redirect:/posts/logged-user/1";
    }

    @GetMapping("/edit/{id}")
    public String showEditPostForm(@PathVariable("id") Integer id, Model model, Principal principal) {
        Post post = postService.findPostById(id);
        model.addAttribute("currentUser", userService.findByEmail(principal.getName()));
        model.addAttribute("post", post);
        model.addAttribute("allTopics", topicService.getAllTopics());
        return "editPost";
    }

    @PutMapping("/edit/{id}")
    public String updatePost(@Valid @ModelAttribute("post") Post post, BindingResult bindingResult, Model model, Principal principal,
                             @RequestParam(value = "postImageFile", required = false) MultipartFile multipartFile) throws IOException {
        User currentUser = userService.findByEmail(principal.getName());
        model.addAttribute("currentUser", currentUser); //for navbar

        Post existingPost = postService.findPostById(post.getId());

        if(bindingResult.hasErrors()) {
            model.addAttribute("allTopics", topicService.getAllTopics());
            return "editPost";
        }

        if (multipartFile != null && !multipartFile.isEmpty()) {
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
        else{
            if(post.getImageUrl() != null) {
                post.setImageUrl(existingPost.getImageUrl());
            }
        }
        Topic topic = topicService.findTopicByName(post.getTopic().getName());
        post.setTopic(topic);
        post.setCreator(currentUser);
        postService.addPost(post);
        return "redirect:/posts/logged-user/1";
    }

    @GetMapping("/search/{pageNumber}")
    public String searchPosts(Model model, Principal principal, @RequestParam(value = "searchQuery") String searchQuery, @PathVariable("pageNumber") int pageNumber) {
        User currentUser = userService.findByEmail(principal.getName());
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("popularTopics", topicService.getTop10Topics());

        Page<Post> posts = postService.findByQuery(pageNumber-1,searchQuery,currentUser);
        model.addAttribute("searchQuery", searchQuery);
        model.addAttribute("posts", posts);
        model.addAttribute("totalPages", posts.getTotalPages());
        return "searchPosts";
    }

    @GetMapping("/view/{id}")
    public String viewPost(@PathVariable("id") Integer id, Model model, Principal principal) {
        User currentUser = userService.findByEmail(principal.getName());
        Post post = postService.findPostById(id);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("post", post);
        model.addAttribute("comment", new Comment());
        return "viewPost";
    }

    @PostMapping("/like/{id}")
    public String likePost(@PathVariable("id") Integer id, Model model, Principal principal) {
        User currentUser = userService.findByEmail(principal.getName());
        Post post = postService.findPostById(id);
        postService.likePost(post, currentUser);
        return "redirect:/posts/view/{id}";
    }

    @DeleteMapping("/unlike/{id}")
    public String unlikePost(@PathVariable("id") Integer id, Model model, Principal principal) {
        User currentUser = userService.findByEmail(principal.getName());
        Post post = postService.findPostById(id);
        postService.unlikePost(post, currentUser);
        return "redirect:/posts/view/{id}";
    }

    @PostMapping("/comment/{postId}")
    public String addComment(@PathVariable("postId") Integer postId, Model model, Principal principal, @Valid @ModelAttribute("comment") Comment comment, BindingResult bindingResult) {
        if(bindingResult.hasErrors()) {
            model.addAttribute("currentUser", userService.findByEmail(principal.getName()));
            Post post = postService.findPostById(postId);
            model.addAttribute("post", post);
            return("viewPost");
        }
        model.addAttribute("currentUser", userService.findByEmail(principal.getName()));
        Post post = postService.findPostById(postId);
        comment.setAuthor(userService.findByEmail(principal.getName()));
        post.getComments().add(comment);
        comment.setPost(post);
        commentService.saveComment(comment);
        return "redirect:/posts/view/" + postId;
    }
}


