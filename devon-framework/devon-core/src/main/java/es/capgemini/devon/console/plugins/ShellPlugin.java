package es.capgemini.devon.console.plugins;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.ObjectUtils;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import es.capgemini.devon.console.ConsolePlugin;
import es.capgemini.devon.exception.ExceptionUtils;
import es.capgemini.devon.scripting.ScriptEvaluator;

//@Component
//@ManagedResource("type=Shell")
public class ShellPlugin implements ConsolePlugin, ApplicationContextAware {

    private ApplicationContext applicationContext;

    @Autowired
    private ScriptEvaluator evaluator;

    @Override
    public String getAction() {
        return "console/shell";
    }

    @Override
    public String getName() {
        return "Shell";
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;

    }

    //@ManagedOperation(description = "Refresh the Spring application context")
    public String eval(String script) {
        // ScriptEngineManager sem = new ScriptEngineManager();
        //ScriptEngine se = sem.getEngineByName("JavaScript");
        //se.put("ctx", applicationContext);
        try {
            Map<String, Object> context = new HashMap<String, Object>();
            context.put("ctx", applicationContext);
            //  return ObjectUtils.toString(se.eval(script), "(null)");
            return ObjectUtils.toString(evaluator.evaluate(script, context), "NULL");
        } catch (Exception e) {
            // TODO Auto-generated catch block
            return ExceptionUtils.getStackTraceAsString(e);
        }
    }

}
