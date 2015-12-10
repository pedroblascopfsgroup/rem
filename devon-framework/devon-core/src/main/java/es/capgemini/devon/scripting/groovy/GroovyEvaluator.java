package es.capgemini.devon.scripting.groovy;

import es.capgemini.devon.scripting.ScriptEvaluator;
import groovy.lang.Binding;
import groovy.lang.GroovyShell;
import groovy.lang.Script;

import java.util.HashMap;
import java.util.Map;

import org.codehaus.groovy.control.CompilerConfiguration;
import org.springframework.stereotype.Component;

/**
 * @author Nicolás Cornaglia
 */
@Component
public class GroovyEvaluator implements ScriptEvaluator{

    private Map<Integer, Script> cache = new HashMap<Integer, Script>();

    /**
     * Evalúa una expresión groovy luego de cachear el script compilado
     *
     * @param expression
     * @param context
     * @return
     */
    public Object evaluate(String expression, Map<String, Object> context) {
        Script script = getScript(expression);
        Binding binding = new Binding(context);
        script.setBinding(binding);
        Object value = script.run();
        return value;
    }

    /**
     * Cachea una script Groovy.
     * La implementación del cache es mediante un {@link HashMap}, cuya key en ek hash del script.
     *
     * @param expression
     * @return
     */
    private Script getScript(String expression) {
        Integer hash = new Integer(expression.hashCode());
        Script script = cache.get(hash);

        if (script == null) {
            CompilerConfiguration compilerConfiguration = new CompilerConfiguration();
            compilerConfiguration.setClasspath("tools.jar");
            GroovyShell shell = new GroovyShell(compilerConfiguration);
            script = shell.parse(expression);
            cache.put(hash, script);
        }

        return script;

    }
}
