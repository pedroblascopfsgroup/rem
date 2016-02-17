package es.capgemini.pfs.plugin.arquetipado.editor.web;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.arquetipo.factory.ReglasFactory;
import es.capgemini.pfs.ruleengine.RuleEngineBusinessOperations;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.pfsgroup.commons.utils.Checks;

/**
 * @author lgiavedo
 */
@Controller
public class EditorController {

    @Autowired
    private Executor executor;
    
    @Autowired(required=false)
    private List<ReglasFactory> reglasFactory;
    
    private Boolean editable = false;
    private static final String UNICODE_FORMAT = "UTF8";
    private final Log logger = LogFactory.getLog(getClass());
    
    @RequestMapping("editor2.htm")
    @Secured("ROLE_ADMIN")
    public String main(Map<String, Object> model) {
        model.put("data", executor.execute(RuleEngineBusinessOperations.BO_DDRULE_GET_LIST));
        return "plugin/editor/editor";
    }
    
    @RequestMapping("editor3.htm")
    @Secured("ROLE_ADMIN")
    public String mainCargaRegla(Long id, Map<String, Object> model) {
        model.put("data", executor.execute(RuleEngineBusinessOperations.BO_DDRULE_GET_LIST));
        model.put("id", id);
        return "plugin/editor/editor";
    }

    @RequestMapping("loadRule.htm")
    @Secured("ROLE_ADMIN")
    public String loadRule(Long id, Map<String, Object> model) {
    	editable = true;
    	if (!Checks.estaVacio(reglasFactory)) {
	    	for (ReglasFactory reglaFactory : reglasFactory) {
	    		if (!reglaFactory.isReglaEditable(id)) {
	    			editable = false;
	    			break;
	    		}
	    	}
    	}
    	if (!editable) {
            model.put("editable",false);
        } else {
        	model.put("editable",true);
        }
    	model.put("rule", executor.execute(RuleEngineBusinessOperations.BO_RULE_DEFINITION_GET_RULE_BY_ID, Long.valueOf(id)));
        return "plugin/editor/json/loadRule";
    }

    @RequestMapping("loadRules.htm")
    @Secured("ROLE_ADMIN")
    public String loadRules(Long id, Map<String, Object> model) {
        model.put("rulesList", executor.execute(RuleEngineBusinessOperations.BO_RULE_DEFINITION_GET_LIST));
        return "plugin/editor/json/loadRules";
    }

    @RequestMapping("saveRule.htm")
    @Secured("ROLE_ADMIN")
    public String saveRule(Long id, String name, String nameLong, String ruleDefinition, Map<String, Object> model) {
        RuleDefinition rd = new RuleDefinition();
        Base64 base = new Base64();
        
		try {
			byte[] decodedValue = base.decode(ruleDefinition.getBytes(UNICODE_FORMAT));		
			String ruleDecode = bytes2String(decodedValue);
			
	        rd.setId(id);
	        rd.setName(name);
	        rd.setNameLong(nameLong);        
	        rd.setRuleDefinition(HtmlUtils.htmlUnescape(ruleDecode));
	        model.put("id", executor.execute(RuleEngineBusinessOperations.BO_RULE_DEFINITION_SAVE_RULE, rd));
	        
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage());
		}
        return "plugin/editor/json/savedRule";
    }
    
    private static String bytes2String(byte[] bytes) {
		StringBuffer stringBuffer = new StringBuffer();
		for (int i = 0; i < bytes.length; i++) {
			if (bytes[i] != 13 && bytes[i] != 10 ) {
				stringBuffer.append((char) bytes[i]);
			}
		}
		return stringBuffer.toString();
	}

    @RequestMapping("deleteRule.htm")
    @Secured("ROLE_ADMIN")
    public String deleteRule(Long id) {
        executor.execute(RuleEngineBusinessOperations.BO_RULE_DEFINITION_DELETE_RULE, id);
        return "default";
    }

    @RequestMapping("updateRule.htm")
    @Secured("ROLE_ADMIN")
    public String updateRule(Long id, String ruleDefinition, Map<String, Object> model) {

        RuleDefinition rd = (RuleDefinition) executor.execute(RuleEngineBusinessOperations.BO_RULE_DEFINITION_GET_RULE_BY_ID, id);
        rd.setRuleDefinition(ruleDefinition);
        executor.execute(RuleEngineBusinessOperations.BO_RULE_DEFINITION_UPDATE_RULE, rd);
        return "default";
    }

    @RequestMapping("checkRule.htm")
    @Secured("ROLE_ADMIN")
    public String checkRule(String ruleDefinition, Map<String, Object> model) {
    	  Base64 base = new Base64();
          
  		try {
  			byte[] decodedValue = base.decode(ruleDefinition.getBytes(UNICODE_FORMAT));		
  			String ruleDecode = bytes2String(decodedValue);
  			
  			model.put("r", executor.execute("arquetiposRuleExecutor.checkRule",ruleDecode, new ArrayList<String>()));
  			
  		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage());
		}
  		
  		return "ruleengine/ruleExecuteJSON";
    }
    /*
    @RequestMapping("listadoData.htm")
    public String listadoDataJSON(Map<String, Object> model) {
        //model.put("data", executor.execute(SalaBusinessOperations.GET_SALAS));
        return "salas/listadoDataJSON";
    }
    */

}
