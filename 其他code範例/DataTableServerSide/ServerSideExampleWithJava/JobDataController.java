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
 * @create 2023/1/5 下午 02:51
 */

@WebServlet("/job_data")
public class JobDataController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // set up the charset
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        // get the parameter from client
        Integer start = Integer.parseInt(req.getParameter("start"));
        Integer length = Integer.parseInt(req.getParameter("length"));
        Integer draw = Integer.parseInt(req.getParameter("draw"));

        // get the job list
        JobSchduleServices jobSchduleServices = new JobSchduleServicesImp();
        List<JobSchedule> subJobs = jobSchduleServices.findJobsFromStart(start, length);
        List<JobSchedule> allJobs = jobSchduleServices.findAllJobs();

        // response to client --> send the json
        PrintWriter out = resp.getWriter();
        GsonBuilder builder = new GsonBuilder();
        builder.serializeNulls();
        Gson gson = builder.setPrettyPrinting().create();

        String json = gson.toJson(subJobs);
        json = "{\n" +
                "  \"draw\":" + draw + ",\n" +
                "  \"recordsTotal\":" + allJobs.size() + ",\n" +
                "  \"recordsFiltered\":" + allJobs.size() + ",\n" +
                "  \"data\":" +
                json +
                "\n}";
        out.print(json);
    }
}
