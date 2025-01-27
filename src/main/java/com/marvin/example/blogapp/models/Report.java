package com.marvin.example.blogapp.models;

import com.marvin.example.blogapp.enums.ReportStatus;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "reports")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @NotBlank
    @Size(min = 3, max = 255)
    private String reason;

    @Enumerated(EnumType.STRING)
    private ReportStatus status;

    @Column(updatable = false)
    private LocalDateTime reportDate;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "reporter")
    private User reporter;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "reported_user")
    private User reportedUser;

    @PrePersist
    public void onCreate(){
        this.reportDate = LocalDateTime.now();
    }

    public String getFormattedReportDate() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return reportDate.format(formatter);
    }

}
