package com.marvin.example.blogapp.repositories;

import com.marvin.example.blogapp.models.Topic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TopicRepository extends JpaRepository<Topic, Integer> {
    @Query("SELECT t " +
            "FROM Topic t " +
            "JOIN Post p ON p.topic.id = t.id " +
            "GROUP BY t.id " +
            "ORDER BY COUNT(p.id) DESC,t.name ASC LIMIT 10")
    List<Topic> findTop10ByPostCount();

    Optional<Topic> findTopicByName(String name);
}
