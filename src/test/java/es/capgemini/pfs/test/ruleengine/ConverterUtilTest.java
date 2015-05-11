package es.capgemini.pfs.test.ruleengine;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.ruleengine.RuleConverterUtil;
import es.capgemini.pfs.ruleengine.rule.Rule;
import es.capgemini.pfs.ruleengine.rule.conjunction.imp.AndRules;
import es.capgemini.pfs.ruleengine.rule.type.RuleEqual;
import es.capgemini.pfs.test.CommonTestAbstract;
import es.capgemini.pfs.test.ruleengine.bean.ArquetipoExecutorConfig;
import es.capgemini.pfs.test.ruleengine.bean.json.ArquetipoTest3;
import es.capgemini.pfs.test.ruleengine.bean.xml.ArquetipoSexoMujerXML;

/**
 * @author lgiavedo
 *
 */
public class ConverterUtilTest extends CommonTestAbstract{
    
    @Autowired
    private RuleConverterUtil rConverterUtil;
    
    @Test
    public void testJSONToRule() throws ValidationException {
      Rule rule = rConverterUtil.JSONToRule(new ArquetipoTest3().getDefinitionRule(), new ArquetipoExecutorConfig());
      assertNotNull(rule);
      assertTrue(rule instanceof AndRules);
      assertTrue(((AndRules)rule).getRules().size()==3);
      rule.generateSQL();
    }
    
    @Test
    public void testXMLToRule() throws ValidationException {
      Rule rule = rConverterUtil.XMLToRule(new ArquetipoSexoMujerXML().getDefinitionRule(), new ArquetipoExecutorConfig());
      assertNotNull(rule);
      assertTrue(rule instanceof RuleEqual);
      assertTrue(rule.getValues().size()==1);
      assertTrue(rule.getValues().get(0).equals("1"));
      //assertTrue(((AndRules)rule).getRules().size()==3);
      rule.generateSQL();
    }
}
