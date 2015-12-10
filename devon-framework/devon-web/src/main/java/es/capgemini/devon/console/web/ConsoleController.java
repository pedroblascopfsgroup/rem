package es.capgemini.devon.console.web;

import java.util.Arrays;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.console.ConsolePlugin;

@Controller
public class ConsoleController {

    @Autowired(required = false)
    private ConsolePlugin[] plugins;

    @Autowired(required = false)
    ServletContext servletContext;

    @RequestMapping("openConsole.htm")
    public String activeUsers(Map<String, Object> model) {
        return "fwkConsole/openConsole";
    }

    @BusinessOperation
    @RequestMapping("consoleItems.htm")
    public String listConsoleItems(Map<String, Object> model) {
        model.put("consoleItems", Arrays.asList(plugins));
        return "fwkConsole/fwkConsoleJSON";
    }

    @RequestMapping("consolePanel.htm")
    public String consolePanel(Map<String, Object> model) {
        return "fwkConsole/fwkConsole";
    }

    @RequestMapping("overview.htm")
    public String overview(Map<String, Object> model) {
        return "fwkConsole/fwkOverview";
    }

}
