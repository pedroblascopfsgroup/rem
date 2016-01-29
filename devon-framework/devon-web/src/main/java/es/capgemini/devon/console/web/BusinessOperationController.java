package es.capgemini.devon.console.web;

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
public class BusinessOperationController implements ConsolePlugin {

    @Autowired
    Executor executor;

    /**
     * @see es.capgemini.devon.console.ConsolePlugin#getName()
     */
    @Override
    public String getName() {
        return "BusinessOperation";
    }

    /**
     * @see es.capgemini.devon.console.ConsolePlugin#getAction()
     */
    @Override
    public String getAction() {
        return "businessoperation/operationsList";
    }

    @RequestMapping("operationsList.htm")
    public String operationsList(Map<String, Object> model) {
        model.put("boList", executor.execute(FwkBusinessOperations.BO_OPERATIONS_LIST));
        return "fwkConsole/businessOperations";
    }

    public void setExecutor(Executor executor) {
        this.executor = executor;
    }

}
