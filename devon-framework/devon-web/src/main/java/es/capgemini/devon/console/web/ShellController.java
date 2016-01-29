package es.capgemini.devon.console.web;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.console.ConsolePlugin;
import es.capgemini.devon.exception.ExceptionUtils;
import es.capgemini.devon.scripting.ScriptEvaluator;

/**
 * @author Nicolás Cornaglia
 */
@Controller
public class ShellController implements ConsolePlugin {

    @Autowired
    private ApplicationContext applicationContext;

    @Autowired
    private ScriptEvaluator evaluator;

    /**
     * @see es.capgemini.devon.console.ConsolePlugin#getName()
     */
    @Override
    public String getName() {
        return "Shell";
    }

    /**
     * @see es.capgemini.devon.console.ConsolePlugin#getAction()
     */
    @Override
    public String getAction() {
        return "shell/shell";
    }

    @RequestMapping("shell.htm")
    public String shell(Map<String, Object> model) {
        return "fwkConsole/shell";
    }

    @RequestMapping("eval.htm")
    public String eval(Map<String, Object> model) {
        String s = (String) model.get("s");
        String result = eval(s);
        model.put("result", result);
        model.put("script", s);
        return "fwkConsole/shellJSON";
    }

    public String eval(String script) {
        try {
            Map<String, Object> context = new HashMap<String, Object>();
            context.put("ctx", applicationContext);
            return ObjectUtils.toString(evaluator.evaluate(script, context), "NULL");
        } catch (Exception e) {
            return ExceptionUtils.getStackTraceAsString(e);
        }
    }

    public void setApplicationContext(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

    public void setEvaluator(ScriptEvaluator evaluator) {
        this.evaluator = evaluator;
    }

}
