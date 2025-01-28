package com.marvin.example.blogapp.controllers;

import com.marvin.example.blogapp.services.TranslationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class TranslationController {

    private final TranslationService translationService;

    public TranslationController(TranslationService translationService) {
        this.translationService = translationService;
    }

    @GetMapping("/translate")
    public ResponseEntity<?> translate(@RequestParam String text, @RequestParam String language) {
        String translatedText = translationService.translateText(text, language);
        Map<String, String> response = Map.of("translatedText", translatedText);
        return ResponseEntity.ok(response);
    }
}
