package es.capgemini.devon.scripting;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

@Component
public class ScriptingUtils {

	private static ScriptEvaluator evaluator;

	@Resource
	public void setEvaluator(ScriptEvaluator evaluator) {
		ScriptingUtils.evaluator = evaluator;
	}

	public static ScriptEvaluator getEvaluator() {
		return evaluator;
	}

	public static Object evaluate(String script, Map<String, Object> context){
		return evaluator.evaluate(script, context);
	}






}
