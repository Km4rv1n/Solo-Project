package com.marvin.example.blogapp.services;

import com.marvin.example.blogapp.models.Comment;
import com.marvin.example.blogapp.repositories.CommentRepository;
import org.springframework.stereotype.Service;

@Service
public class CommentService {

    private final CommentRepository commentRepository;
    public CommentService(CommentRepository commentRepository) {
        this.commentRepository = commentRepository;
    }

   public void saveComment(Comment comment) {
        commentRepository.save(comment);
   }
}
