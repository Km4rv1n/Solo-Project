package com.marvin.example.blogapp.services;

import com.marvin.example.blogapp.enums.Role;
import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.repositories.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;


@Service
@Transactional
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
     * Retrieve a user based on its email
     *
     * @param email the username of the user to retrieve
     * @return the User entity associated with the given username, or null if no user with the specified username exists
     */
    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElseThrow(() -> new UsernameNotFoundException(email));
    }

    /**
     *
     * @param id
     * @return the user object with the given id, or throw an exception if the object is not found
     */
    public User findById(Integer id) {
        return userRepository.findById(id).orElseThrow(() -> new UsernameNotFoundException(id.toString()));
    }

    /**
     * add the user object to the currentUser's list of blocked users
     * @param currentUser
     * @param user
     */
    public void blockUser(User currentUser, User user){
            currentUser.getBlockedUsers().add(user);
            userRepository.save(currentUser);
    }

    /**
     * remove the user object from the currentUser's list of blocked users
     * @param currentUser
     * @param user
     */
    public void unblockUser(User currentUser, User user){
        currentUser.getBlockedUsers().remove(user);
        userRepository.save(currentUser);
    }

    /**
     * updates the lastSeen field of the user entity with the given email, with a new timestamp
     * @param email
     */
    public void updateLastSeen(String email) {
        User user = userRepository.findByEmail(email).orElseThrow(() -> new UsernameNotFoundException(email));
        user.setLastSeen(LocalDateTime.now());
        userRepository.save(user);
    }

    /**
     * @param pageNumber
     * @param currentUser
     * @return page of users who are not in a blocking relationship with the current user, and are not the current user themselves
     */
    public Page<User> getNotBlockedUsersPage(int pageNumber, User currentUser) {
        PageRequest pageRequest = PageRequest.of(pageNumber, 2, Sort.Direction.DESC, "createdAt");
        return userRepository.findAllNotBlocked(pageRequest,currentUser);
    }

    /**
     * sets the role of the user to Admin
     * @param user
     */
    public void promoteToAdmin(User user) {
        user.setRole(Role.ROLE_ADMIN);
        userRepository.save(user);
    }

    /**
     * sets the banned status of the user to true
     * @param user
     */
    public void banUser(User user) {
        user.setBanned(true);
        userRepository.save(user);
    }

    /**
     * sets the banned status of the user to false
     * @param user
     */
    public void unbanUser(User user) {
        user.setBanned(false);
        userRepository.save(user);
    }
}

