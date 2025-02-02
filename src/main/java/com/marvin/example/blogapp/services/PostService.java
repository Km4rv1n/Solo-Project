package com.marvin.example.blogapp.services;

import com.marvin.example.blogapp.exceptions.PostNotFoundException;
import com.marvin.example.blogapp.models.Comment;
import com.marvin.example.blogapp.models.Post;
import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.repositories.PostRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PostService {
    private final PostRepository postRepository;
    private final UserService userService;

    public PostService(PostRepository postRepository, UserService userService) {
        this.postRepository = postRepository;
        this.userService = userService;
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
        PageRequest pageRequest = PageRequest.of(pageNumber, 3, Sort.Direction.DESC, "createdAt");
        return postRepository.findAllByCreator(user, pageRequest);
    }

    /**
     *
     * @param id
     * @return the post object associated with the given id
     */
    public Post findPostById(Integer id) {
        return postRepository.findById(id).orElseThrow(() -> new PostNotFoundException("Could not find the post you were looking for."));
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

    /**
     * @param posts
     * @param currentUser
     * @return a map containing the number of likes for each post after applying filtering according to the list of users that
     * are in a blocking relationship with the current user, or users that are banned
     */
    public Map<Integer, Integer> getFilteredLikesCount(List<Post> posts, User currentUser) {
        Map<Integer, Integer> filteredLikesCount = new HashMap<>();
        for (Post post : posts) {
            int count = userService.filterNotBlockedUsersIncludingSelf(post.getLikedBy().stream().toList(), currentUser).size();
            filteredLikesCount.put(post.getId(),count);
        }
        return filteredLikesCount;
    }

    /**
     *
     * @param posts
     * @param currentUser
     * @return a map containing the number of comments for each post after applying filtering according to the list of users that
     * are in a blocking relationship with the current user, or users that are banned
     */
    public Map<Integer,Integer> getFilteredCommentsCount(List<Post> posts, User currentUser) {
        Map<Integer, Integer> filteredCommentsCount = new HashMap<>();

        for (Post post : posts) {
            List<User> authors = post.getComments().stream().map(Comment::getAuthor).toList();
            List<User> filteredAuthors = userService.filterNotBlockedUsersIncludingSelf(authors, currentUser);

            int count = (int) post.getComments().stream().filter(comment -> filteredAuthors.contains(comment.getAuthor())).count();
            filteredCommentsCount.put(post.getId(), count);
        }
        return filteredCommentsCount;
    }
}
