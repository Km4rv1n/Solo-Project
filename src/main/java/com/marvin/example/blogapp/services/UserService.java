package com.marvin.example.blogapp.services;

import com.marvin.example.blogapp.enums.Role;
import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.repositories.UserRepository;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;


@Service
public class UserService {

    private UserRepository userRepository;
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    public UserService(UserRepository userRepository, BCryptPasswordEncoder bCryptPasswordEncoder) {
        this.userRepository = userRepository;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
    }

    /**
     * Add a new user in the system
     * @param user
     */
    public void addUser(User user) {
        user.setPassword(bCryptPasswordEncoder.encode(user.getPassword()));
        System.out.println(user.getPassword().length());
        //the role of the first user that is registered in the system will be Admin
        user.setRole(userRepository.findAll().isEmpty() ? Role.ROLE_ADMIN : Role.ROLE_USER);
        userRepository.save(user);
    }

    /**
     * Saves the details of a user in the database
     * @param user
     */
    public void saveUser(User user) {
        userRepository.save(user);
    }

    /**
     * Retrieve a user based on its username
     *
     * @param email the username of the user to retrieve
     * @return the User entity associated with the given username, or null if no user with the specified username exists
     */
    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElseThrow(() -> new UsernameNotFoundException(email));
    }


}
