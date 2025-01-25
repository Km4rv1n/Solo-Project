package com.marvin.example.blogapp.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.servlet.util.matcher.MvcRequestMatcher;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.handler.HandlerMappingIntrospector;

@Configuration
public class WebSecurityConfig {

    private final HandlerMappingIntrospector introspector;
    private final UserDetailsService userDetailsService;
    public WebSecurityConfig(HandlerMappingIntrospector introspector, UserDetailsService userDetailsService) {
        this.introspector = introspector;
        this.userDetailsService = userDetailsService;
    }

    @Bean
    protected SecurityFilterChain filterChain(HttpSecurity http, LastSeenFilter lastSeenFilter) throws Exception {
        http
                .authorizeHttpRequests(
                        auth -> auth
                                .requestMatchers(
                                        new MvcRequestMatcher(introspector, "/user/home/1")
                                )
                                .authenticated()
                                .anyRequest()
                                .permitAll()
                )
                .formLogin(
                        form ->
                                form.loginPage("/login")
                                        .defaultSuccessUrl("/user/home/1")
                                        .permitAll()
                )
                .logout(
                        logout -> logout.permitAll()
                )
                .addFilterAfter(lastSeenFilter, org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * Configure Spring Security to use our custom implementation of UserDetailsService with BCrypt encoder
     *
     * @param auth authentication manager builder
     * @throws Exception if an error occurs when adding UserDetailsService
     */
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(bCryptPasswordEncoder());
    }

}