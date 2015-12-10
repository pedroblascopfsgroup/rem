package es.capgemini.devon.hibernate.console.web;

import java.util.Map;

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
public class HibernateController implements ConsolePlugin {

    @Autowired
    Executor executor;

    /**
     * @see es.capgemini.devon.console.ConsolePlugin#getName()
     */
    @Override
    public String getName() {
        return "Hibernate";
    }

    /**
     * @see es.capgemini.devon.console.ConsolePlugin#getAction()
     */
    @Override
    public String getAction() {
        return "hibernate/hibernate";
    }

    @RequestMapping("hibernate.htm")
    public String hibernate(Map<String, Object> model) {
        model.put("statistics", executor.execute(FwkBusinessOperations.HIBERNATE_GET_STATISTICS1));
        return "fwkConsole/hibernate";
    }

    @RequestMapping("data.htm")
    public String data(Map<String, Object> model) {
        model.put("masterStatistics", executor.execute(FwkBusinessOperations.HIBERNATE_GET_STATISTICS1));
        model.put("entityStatistics", executor.execute(FwkBusinessOperations.HIBERNATE_GET_STATISTICS2));
        return "fwkConsole/hibernateJSON";
    }

    @RequestMapping("changeStatisticsMode1.htm")
    public String changeStatisticsMode1(Map<String, Object> model) {
        executor.execute(FwkBusinessOperations.HIBERNATE_CHANGE_STATISTICS_MODE1);
        return "default";
    }

    @RequestMapping("changeStatisticsMode2.htm")
    public String changeStatisticsMode2(Map<String, Object> model) {
        executor.execute(FwkBusinessOperations.HIBERNATE_CHANGE_STATISTICS_MODE2);
        return "default";
    }

    @RequestMapping("clearSession1.htm")
    public String clearSession1(Map<String, Object> model) {
        executor.execute(FwkBusinessOperations.HIBERNATE_CLEAR_SESSION1);
        return "default";
    }

    @RequestMapping("clearSession2.htm")
    public String clearSession2(Map<String, Object> model) {
        executor.execute(FwkBusinessOperations.HIBERNATE_CLEAR_SESSION2);
        return "default";
    }

    public void setExecutor(Executor executor) {
        this.executor = executor;
    }

}
