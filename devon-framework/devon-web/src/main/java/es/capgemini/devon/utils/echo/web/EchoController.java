package es.capgemini.devon.utils.echo.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.FwkBusinessOperations;

/**
 * @author Nicolás Cornaglia
 */
@Controller
public class EchoController {

    @Autowired
    private Executor executor;

    @RequestMapping("echo.htm")
    public String echo(Map<String, Object> model, @RequestParam String echo) {
        model.put("echo", executor.execute(FwkBusinessOperations.ECHO, echo));
        return "fwkEchoJSON";
    }

    @RequestMapping("transactionalEcho.htm")
    public String transactionalEcho(Map<String, Object> model, @RequestParam String echo) {
        model.put("echo", executor.execute(FwkBusinessOperations.TRANSACTIONAL_ECHO, echo));
        return "fwkEchoJSON";
    }

}
