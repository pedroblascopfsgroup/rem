package es.capgemini.devon.console.web;

import java.util.ArrayList;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.console.ConsolePlugin;
import es.capgemini.devon.security.SecurityUserInfo;

/**
 * @author Nicolás Cornaglia
 */
@Controller
public class ActiveUsersController implements ConsolePlugin {

    @Autowired(required = false)
    ServletContext servletContext;

    /**
     * @see es.capgemini.devon.console.ConsolePlugin#getName()
     */
    @Override
    public String getName() {
        return "ActiveUsers";
    }

    /**
     * @see es.capgemini.devon.console.ConsolePlugin#getAction()
     */
    @Override
    public String getAction() {
        return "activeusers/activeUsers";
    }

    @RequestMapping("activeUsers.htm")
    public String activeUsers(Map<String, Object> model) {
        return "fwkConsole/activeUsers";
    }

    @SuppressWarnings("unchecked")
    @RequestMapping("data.htm")
    public String data(Map<String, Object> model) {
        Map<String, SecurityUserInfo> users = (Map<String, SecurityUserInfo>) servletContext.getAttribute(UserCounterListener.USERS_KEY);
        if (users != null) {
            model.put("data", new ArrayList<SecurityUserInfo>(users.values()));
        } else {
            model.put("data", new ArrayList<SecurityUserInfo>());
        }
        return "fwkConsole/activeUsersJSON";
    }

    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

}
