package com.marvin.example.blogapp.controllers;

import com.marvin.example.blogapp.models.Report;
import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.services.ReportService;
import com.marvin.example.blogapp.services.UserService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UserService userService;
    private final ReportService reportService;

    public AdminController(UserService userService, ReportService reportService) {
        this.userService = userService;
        this.reportService = reportService;
    }

    @GetMapping("/dashboard/{pageNumber}")
    public String showAdminDashboard(Principal principal, @PathVariable("pageNumber") int pageNumber, Model model) {
        User currentUser = userService.findByEmail(principal.getName());
        Page<User> users = userService.getNotBlockedUsersPageIncludingBanned(pageNumber-1,currentUser);
        int totalPages = users.getTotalPages();
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("users", users);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("currentPage", pageNumber);
        return "adminDashboard";
    }

    @PutMapping("/promote/{id}")
    public String promoteUser(@PathVariable("id") Integer id, Principal principal, Model model,@RequestParam("currentPage") int currentPage) {
        User user = userService.findById(id);
        model.addAttribute("currentUser",  userService.findByEmail(principal.getName()));
        userService.promoteToAdmin(user);
        return "redirect:/admin/dashboard/"+currentPage;
    }

    @PutMapping("/ban/{id}")
    public String banUser(@PathVariable("id") Integer id, Principal principal, Model model, @RequestParam("currentPage") int currentPage) {
        User user = userService.findById(id);
        model.addAttribute("currentUser",  userService.findByEmail(principal.getName()));
        userService.banUser(user);
        return "redirect:/admin/dashboard/" + currentPage;
    }

    @PutMapping("/unban/{id}")
    public String unbanUser(@PathVariable("id") Integer id, Principal principal, Model model,@RequestParam("currentPage") int currentPage) {
        User user = userService.findById(id);
        model.addAttribute("currentUser",  userService.findByEmail(principal.getName()));
        userService.unbanUser(user);
        return "redirect:/admin/dashboard/"+currentPage;
    }

    @GetMapping("/reports/{pageNumber}")
    public String showReports(Principal principal, Model model, @PathVariable("pageNumber") int pageNumber) {
        User currentUser = userService.findByEmail(principal.getName());
        Page<Report> reports = reportService.getAllReports(pageNumber-1,currentUser);
        int totalPages = reports.getTotalPages();
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("reports", reports);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("currentPage", pageNumber);
        return "allReports";
    }

    @PutMapping("/reports/reject/{id}")
    public String rejectReport(@PathVariable("id") Integer id, Principal principal, Model model, @RequestParam("currentPage") int currentPage) {
        model.addAttribute("currentUser",  userService.findByEmail(principal.getName()));
        Report report = reportService.findById(id);
        reportService.rejectReport(report);
        return "redirect:/admin/reports/"+currentPage;
    }

    @PutMapping("/reports/accept/{id}")
    public String acceptReport(@PathVariable("id") Integer id, Principal principal, Model model, @RequestParam("currentPage") int currentPage) {
        model.addAttribute("currentUser",  userService.findByEmail(principal.getName()));
        Report report = reportService.findById(id);
        reportService.acceptReport(report);
        return "redirect:/admin/reports/"+currentPage;
    }
}
