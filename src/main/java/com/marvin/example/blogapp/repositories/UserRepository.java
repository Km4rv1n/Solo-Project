package com.marvin.example.blogapp.repositories;

import com.marvin.example.blogapp.models.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends PagingAndSortingRepository<User, Integer> {

    Optional<User> findByEmail(String email);

    @Query("""
                SELECT u
                FROM User u
                WHERE u IN :users
                AND u NOT IN (
                    SELECT b
                    FROM User user JOIN user.blockedUsers b
                    WHERE user = :currentUser
                )
                AND u NOT IN (
                    SELECT user
                    FROM User user JOIN user.blockedUsers b
                    WHERE b = :currentUser
                )
                AND u.isBanned = false
            """)
    List<User> findAllNotBlockedIncludingSelf(@Param("users") List<User> users, @Param("currentUser") User currentUser);

    @Query("""
                SELECT u
                FROM User u
                WHERE u NOT IN (
                    SELECT b
                    FROM User user JOIN user.blockedUsers b
                    WHERE user = :currentUser
                )
                AND u NOT IN (
                    SELECT user
                    FROM User user JOIN user.blockedUsers b
                    WHERE b = :currentUser
                )
                AND u.isBanned = false
            """)
    Page<User> findAllNotBlockedIncludingSelf(Pageable pageable, @Param("currentUser") User currentUser);

    @Query("""
                SELECT u
                FROM User u
                WHERE u NOT IN (
                    SELECT b
                    FROM User user JOIN user.blockedUsers b
                    WHERE user = :currentUser
                )
                AND u NOT IN (
                    SELECT user
                    FROM User user JOIN user.blockedUsers b
                    WHERE b = :currentUser
                )
                AND u != :currentUser
                AND u.isBanned = false
            """)
    List<User> findAllNotBlockedExcludingSelf(@Param("users") List<User> users, @Param("currentUser") User currentUser);


    @Query("""
                SELECT u
                FROM User u
                WHERE u NOT IN (
                    SELECT b
                    FROM User user JOIN user.blockedUsers b
                    WHERE user = :currentUser
                )
                AND u NOT IN (
                    SELECT user
                    FROM User user JOIN user.blockedUsers b
                    WHERE b = :currentUser
                )
                AND u != :currentUser
            """)
    Page<User> findAllNotBlockedExcludingSelfIncludingBanned(Pageable pageable, @Param("currentUser") User currentUser);

    void save(User user);

    List<User> findAll();

    Optional<User> findById(Integer id);
}
