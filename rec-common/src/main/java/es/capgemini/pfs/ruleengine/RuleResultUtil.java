package es.capgemini.pfs.ruleengine;

import java.util.List;

public class RuleResultUtil {
	
	public static boolean allResultsOK(List<RuleResult> results){
		for (RuleResult ruleResult : results) {
			if(!ruleResult.isFinishedOK())
				return false;
		}
		return true;
	}

}
