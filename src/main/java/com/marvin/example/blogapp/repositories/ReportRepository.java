package com.marvin.example.blogapp.repositories;

import com.marvin.example.blogapp.models.Report;
import com.marvin.example.blogapp.models.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ReportRepository extends PagingAndSortingRepository<Report, Integer> {
    void save(Report report);

    @Query("""
    SELECT r
    FROM Report r
    WHERE r.reportedUser NOT IN (
        SELECT b
        FROM User u JOIN u.blockedUsers b
        WHERE u = :currentUser
    ) AND r.reporter = :currentUser
        """)
    Page<Report> findByReporter(Pageable pageable,@Param("currentUser") User currentUser);


    @Query("""
    SELECT r
    FROM Report r
    WHERE r.reportedUser NOT IN (
        SELECT b
        FROM User u JOIN u.blockedUsers b
        WHERE u = :currentUser
    )AND r.reporter NOT IN(
        SELECT b
        FROM User u JOIN u.blockedUsers b
        WHERE u = :currentUser
    )AND r.reporter NOT IN(
        SELECT u
        FROM User u JOIN u.blockedUsers b
        WHERE b = :currentUser
    )AND r.reportedUser NOT IN(
        SELECT u
        FROM User u JOIN u.blockedUsers b
        WHERE b = :currentUser
    )AND r.reporter.isBanned = false
     AND r.reportedUser.isBanned = false
    """)
    Page<Report> findAllReports(Pageable pageable, @Param("currentUser") User currentUser);

    Optional<Report> findById(Integer id);
}

