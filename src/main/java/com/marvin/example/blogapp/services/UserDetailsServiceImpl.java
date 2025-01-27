package com.marvin.example.blogapp.services;

import com.marvin.example.blogapp.exceptions.BannedUserException;
import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.repositories.UserRepository;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UserRepository userRepository;
    public UserDetailsServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Load user details by email for authentication
     *
     * @param email the username to search for
     * @return UserDetails containing the user's credentials and authorities
     * @throws UsernameNotFoundException if the user is not found
     */
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email).orElseThrow(() -> new UsernameNotFoundException(email));

        if (Objects.isNull(user)) {
            throw new UsernameNotFoundException("User not found");
        }

        if (user.isBanned()) {
            throw new BannedUserException("This account has been banned");
        }

        return new org.springframework.security.core.userdetails.User(user.getEmail(), user.getPassword(), getAuthorities(user));    }

    /**
     * Generate a list of granted authorities for the given user based on role that he has
     *
     * @param user the User whose authorities are to be retrieved
     * @return a list of GrantedAuthority objects representing the user's permissions
     */
    private List<GrantedAuthority> getAuthorities(User user) {
        List<GrantedAuthority> authorities = new ArrayList<>();
        GrantedAuthority grantedAuthority = new SimpleGrantedAuthority(user.getRole().name());
        authorities.add(grantedAuthority);
        return authorities;
    }
}
