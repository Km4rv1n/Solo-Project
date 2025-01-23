package com.marvin.example.blogapp.services;

import com.marvin.example.blogapp.models.Post;
import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.repositories.PostRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PostService {
    private final PostRepository postRepository;
    public PostService(PostRepository postRepository) {
        this.postRepository = postRepository;
    }
    private static final int PAGE_SIZE = 2;
    /**
     * persist or update the given post in the database
     * @param post
     */
    public void addPost(Post post) {
        postRepository.save(post);
    }


    public Page<Post> postsPerPage(int pageNumber, User currentUser) {
        PageRequest pageRequest = PageRequest.of(pageNumber, PAGE_SIZE, Sort.Direction.DESC, "createdAt");
        return postRepository.findAllNotBlocked(pageRequest, currentUser);
    }

    public Page<Post> postsPerPageByCreator(int pageNumber,User currentUser) {
        PageRequest pageRequest = PageRequest.of(pageNumber, PAGE_SIZE, Sort.Direction.DESC, "createdAt");
        return postRepository.findAllByCreator(currentUser, pageRequest);
    }
}
