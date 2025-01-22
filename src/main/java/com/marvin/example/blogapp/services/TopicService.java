package com.marvin.example.blogapp.services;

import com.marvin.example.blogapp.models.Topic;
import com.marvin.example.blogapp.repositories.TopicRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TopicService {
    private final TopicRepository topicRepository;
    public TopicService(TopicRepository topicRepository) {
        this.topicRepository = topicRepository;
    }

    public List<Topic> getTop10Topics() {
        return topicRepository.findTop10ByPostCount();
    }
}
