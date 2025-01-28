package com.marvin.example.blogapp.services;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;

@Service
public class TranslationService {

    private final RestTemplate restTemplate = new RestTemplate();

    public String translateText(String text, String targetLanguage) {
        String url = "https://clients5.google.com/translate_a/t?client=dict-chrome-ex&sl=auto&tl=" + targetLanguage + "&q=" + text;
        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type", "application/json");
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);

        return extractTranslation(response.getBody());
    }

    private String extractTranslation(String responseBody) {
        return responseBody.split("\"")[1];
    }
}

