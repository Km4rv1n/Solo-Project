package com.marvin.example.blogapp.services;

import com.marvin.example.blogapp.models.Topic;
import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.repositories.TopicRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class TopicService {
    private final TopicRepository topicRepository;
    public TopicService(TopicRepository topicRepository) {
        this.topicRepository = topicRepository;
    }

    /**
     *
     * @return a list containing the top 10 topics with the highest number of posts
     */
    public List<Topic> getTop10Topics(User currentUser) {
        return topicRepository.findTop10ByPostCount(currentUser);
    }

    /**
     *
     * @return a list containing all topics
     */
    public List<Topic> getAllTopics() {
        return topicRepository.findAll();
    }

    /**
     *
     * @param name
     * @return topic with the corresponding name. if it is not found, a new topic is created
     */
    public Topic findTopicByName(String name) {
        Optional<Topic> topic = topicRepository.findTopicByName(name);
        if (topic.isPresent()) {
            return topic.get();
        }
        else{
            Topic newTopic = new Topic();
            newTopic.setName(name);
            topicRepository.save(newTopic);
            return newTopic;
        }
    }
}
