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
    /**
     * persist or update the given post in the database
     * @param post
     */
    public void addPost(Post post) {
        postRepository.save(post);
    }


    /**
     *
     * @param pageNumber
     * @param currentUser
     * @return a page object containing all posts available to the user (not including those posts whose creator is
     *         in a blocking relationship with the logged user)
     */
    public Page<Post> postsPerPage(int pageNumber, User currentUser) {
        PageRequest pageRequest = PageRequest.of(pageNumber, 2, Sort.Direction.DESC, "createdAt");
        return postRepository.findAllNotBlocked(pageRequest, currentUser);
    }

    /**
     *
     * @param pageNumber
     * @param user
     * @return a page object containing all posts created by the given user
     */
    public Page<Post> postsPerPageByCreator(int pageNumber,User user) {
        PageRequest pageRequest = PageRequest.of(pageNumber, 4, Sort.Direction.DESC, "createdAt");
        return postRepository.findAllByCreator(user, pageRequest);
    }

    /**
     *
     * @param id
     * @return the post object associated with the given id
     */
    public Post findPostById(Integer id) {
        return postRepository.findById(id).orElseThrow(() -> new RuntimeException("Post not found"));
    }

    /**
     * deletes the post object associated with the given id
     * @param id
     */
    public void deletePostById(Integer id) {
        postRepository.deleteById(id);
    }

    public Page<Post> findByQuery(int pageNumber, String query, User currentUser) {
        PageRequest pageRequest = PageRequest.of(pageNumber, 2, Sort.Direction.DESC, "createdAt");
        return postRepository.findByQuery(pageRequest,currentUser, query);
    }

    /**
     * adds the given user object to the post's list of users that have liked it
     * @param post
     * @param user
     */
    public void likePost(Post post, User user) {
        post.getLikedBy().add(user);
        postRepository.save(post);
    }

    /**
     * removes the given user object from the post's list of users that have liked it
     * @param post
     * @param user
     */
    public void unlikePost(Post post, User user) {
        post.getLikedBy().remove(user);
        postRepository.save(post);
    }
}
