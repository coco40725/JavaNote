package web.job.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import web.job.entities.JobSchedule;
import web.job.services.JobSchduleServices;
import web.job.services.imp.JobSchduleServicesImp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * @author Yu-Jing
 * @create 2023/1/4 上午 10:34
 */

@WebServlet({"/jobs_calendar","/jobs_list"})
public class JobController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/jobs_calendar".equals(path)) {
            req.getRequestDispatcher("templates/backstage/salon/salon_schedule_calendar.jsp").forward(req, resp);
        }else if ("/jobs_list".equals(path)){
            JobSchduleServices jobSchduleServices = new JobSchduleServicesImp();
            List<JobSchedule> allJobs = jobSchduleServices.findAllJobs();
            req.setAttribute("allJob", allJobs);
            req.getRequestDispatcher("templates/backstage/salon/salon_schedule_list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
