package es.capgemini.devon.console.web;

import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.FwkBusinessOperations;
import es.capgemini.devon.console.ConsolePlugin;

/**
 * @author Nicolás Cornaglia
 */
@Controller
public class ProfilerController implements ConsolePlugin {

    @Autowired(required = false)
    ServletContext servletContext;

    @Autowired
    Executor executor;

    /**
     * @see es.capgemini.devon.console.ConsolePlugin#getName()
     */
    @Override
    public String getName() {
        return "Profiler";
    }

    /**
     * @see es.capgemini.devon.console.ConsolePlugin#getAction()
     */
    @Override
    public String getAction() {
        return "profiler/profiler";
    }

    @RequestMapping("profiler.htm")
    public String profiler(Map<String, Object> model) {
        return "fwkConsole/profiler";
    }

    @RequestMapping("profilerData.htm")
    public String profilerData(Map<String, Object> model) {
        model.put("statistics", executor.execute(FwkBusinessOperations.PROFILER_GET_STATISTICS, "AllMonitors"));
        return "fwkConsole/profilerJSON";
    }

    @RequestMapping("changeStatisticsMode")
    public String changeStatisticsMode(Map<String, Object> model) {
        executor.execute(FwkBusinessOperations.PROFILER_CHANGE_STATISTICS_MODE);
        return "default";
    }

    @RequestMapping("reset")
    public String reset(Map<String, Object> model) {
        executor.execute(FwkBusinessOperations.PROFILER_RESET);
        return "default";
    }

    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    public void setExecutor(Executor executor) {
        this.executor = executor;
    }

}
