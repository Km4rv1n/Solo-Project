package com.marvin.example.blogapp.services;

import com.marvin.example.blogapp.enums.ReportStatus;
import com.marvin.example.blogapp.models.Report;
import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.repositories.ReportRepository;
import com.marvin.example.blogapp.repositories.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
@Transactional
public class ReportService {
    private final ReportRepository reportRepository;
    private final UserRepository userRepository;

    public ReportService(ReportRepository reportRepository, UserRepository userRepository) {
        this.reportRepository = reportRepository;
        this.userRepository = userRepository;
    }

    /**
     *
     * @param id
     * @return the report object associated with the given id
     */
    public Report findById(Integer id) {
        return reportRepository.findById(id).orElseThrow( () -> new RuntimeException("Report not found"));
    }

    /**
     * sets details of the report such as the status, reporter and reported user
     * and persists the report in the database
     *
     * @param reporter
     * @param reported
     * @param report
     */
    public void createReport(User reporter, User reported, Report report) {
        report.setStatus(ReportStatus.STATUS_PENDING);
        report.setReporter(reporter);
        report.setReportedUser(reported);
        reporter.getReportsAsReporter().add(report);
        reported.getReportsAsReported().add(report);
        userRepository.save(reporter);
        userRepository.save(reported);
        reportRepository.save(report);
    }

    /**
     * @param pageNumber
     * @param currentUser
     * @return a page object with reports that the given user (currentUser) has created
     */
    public Page<Report> getUserReports(int pageNumber, User currentUser) {
        PageRequest pageRequest = PageRequest.of(pageNumber, 10, Sort.Direction.DESC, "reportDate");
        return reportRepository.findByReporter(pageRequest, currentUser);
    }


    /**
     * @param pageNumber
     * @param currentUser
     * @return a page object of all reports, excluding those reports whose reporter/reported user is banned by the current user (admin)
     * or those reports whose reporter(creator) has been banned
     */
    public Page<Report> getAllReports(int pageNumber, User currentUser) {
        PageRequest pageRequest = PageRequest.of(pageNumber, 10, Sort.Direction.DESC, "reportDate");
        return reportRepository.findAllReports(pageRequest, currentUser);
    }

    /**
     * set the status of the given report to rejected
     * @param report
     */
    public void rejectReport(Report report) {
        report.setStatus(ReportStatus.STATUS_REJECTED);
        reportRepository.save(report);
    }

    /**
     * ban the reported user and set the status of the given report and accepted
     * @param report
     */
    public void acceptReport(Report report) {
        User reportedUser = report.getReportedUser();
        reportedUser.setBanned(true);
        report.setStatus(ReportStatus.STATUS_ACCEPTED);
        userRepository.save(reportedUser);
        reportRepository.save(report);
    }
}
