package com.marvin.example.blogapp.repositories;

import com.marvin.example.blogapp.models.Post;
import com.marvin.example.blogapp.models.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PostRepository extends PagingAndSortingRepository<Post, Integer> {
    void save(Post post);

    @Query("""
    SELECT p
    FROM Post p
    WHERE p.creator.id NOT IN (
        SELECT b.id 
        FROM User u JOIN u.blockedUsers b 
        WHERE u = :currentUser
    ) 
    AND p.creator.id NOT IN (
        SELECT u.id 
        FROM User u JOIN u.blockedUsers b 
        WHERE b = :currentUser
    )
""")
    Page<Post> findAllNotBlocked(Pageable pageable, User currentUser);

    Page<Post> findAllByCreator(User user, Pageable pageable);
}
