package es.capgemini.devon.scripting;

import java.util.Map;

public interface ScriptEvaluator {
	public Object evaluate(String expression, Map<String, Object> context);
}
