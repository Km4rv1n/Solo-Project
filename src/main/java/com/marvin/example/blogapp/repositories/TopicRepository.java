package com.marvin.example.blogapp.repositories;

import com.marvin.example.blogapp.models.Topic;
import com.marvin.example.blogapp.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TopicRepository extends JpaRepository<Topic, Integer> {

    @Query("""
            SELECT t
            FROM Topic t
            JOIN Post p ON p.topic.id = t.id
            AND (p.creator = :currentUser OR (
                p.creator NOT IN (
                    SELECT blockedUser
                    FROM User currentUser
                    JOIN currentUser.blockedUsers blockedUser
                    WHERE currentUser = :currentUser
                )
                AND p.creator NOT IN (
                    SELECT blockedUser
                    FROM User currentUser
                    JOIN currentUser.blockedUsers blockedUser
                    WHERE blockedUser = :currentUser
                )
                AND p.creator.isBanned = false
            ))
            GROUP BY t.id
            HAVING COUNT(p.id) > 0
            ORDER BY COUNT(p.id) DESC, t.name ASC
            LIMIT 10
            """)
    List<Topic> findTop10ByPostCount(@Param("currentUser") User currentUser);

    Optional<Topic> findTopicByName(String name);
}
