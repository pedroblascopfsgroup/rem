package es.capgemini.devon.console.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.ConfigurableWebApplicationContext;

/**
 * @author Nicolás Cornaglia
 */
@Controller
public class RefreshController {

    @Autowired
    private ApplicationContext applicationContext;

    @RequestMapping("refresh.htm")
    public String refresh(Map<String, Object> model) {
        ((ConfigurableWebApplicationContext) getApplicationContext()).refresh();
        return "fwkContextRefreshed";
    }

    /**
     * @return the applicationContext
     */
    public ApplicationContext getApplicationContext() {
        return applicationContext;
    }

    /**
     * @param applicationContext the applicationContext to set
     */
    public void setApplicationContext(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

}
