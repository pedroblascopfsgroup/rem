package es.capgemini.pfs.test.ruleengine;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.ruleengine.HelperRule;
import es.capgemini.pfs.ruleengine.RuleConverterUtil;
import es.capgemini.pfs.ruleengine.rule.Rule;
import es.capgemini.pfs.ruleengine.rule.conjunction.Rules;
import es.capgemini.pfs.ruleengine.rule.conjunction.imp.AndRules;
import es.capgemini.pfs.ruleengine.rule.conjunction.imp.OrRules;
import es.capgemini.pfs.ruleengine.rule.type.RuleBetween;
import es.capgemini.pfs.ruleengine.rule.type.RuleEqual;
import es.capgemini.pfs.ruleengine.rule.type.RuleGreaterThan;
import es.capgemini.pfs.test.CommonTestAbstract;
import es.capgemini.pfs.test.ruleengine.bean.ArquetipoExecutorConfig;

public class JSONTest extends CommonTestAbstract {
    
    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private RuleConverterUtil rConverterUtil;
    
    private static String json1 = "{type:'and', rules :[" //
                            + "        {type:'compare1', title:'mayor de edad', ruleId:4, operator: 'greaterThan', values: ['50']}"// 
                            + "        ,{type:'or', rules :[" //
                            + "            {type:'compare2', title:'edad entre', ruleId:19, values : ['25','50']}" //
                            + "            ,{type:'compare1', title:'saldo vencido > 5000', operator:'greaterThan', ruleId:18, values : ['5000']}" //
                            + "        ]}" //
                            + "]}";
    
    private static String jsonLink = "{type:'or', rules :[" //
                            + "        {type:'compare1', title:'mayor de edad', ruleId:4, operator: 'greaterThan', values: ['50']}"// 
                            + "        ,{type:'link', ruleId:2}"//
                            + "        ]}" //
                            + "]}";
    
    private static String json2Values = "{type:'compare2', title:'falta valor', ruleId:19, values: ['1']}";//
    private static String json1Values = "{type:'compare1', title:'mayor de edad', ruleId:4, operator: 'greaterThan', values: ['1','2','3']}";//
    
    private static String jsonFormat = "{type:'compare1', title:'mayor de edad', ruleId:4, operator: 'greaterThan', values: ['1,2a']}";//
    
    @Test
    public void testJSONConversion() {

       HelperRule rule = rConverterUtil.JSONToHelperRule(json1);
        
        assertEquals(rule.getType(),"and");
        assertEquals(rule.getRules().size(), 2);
        assertEquals(rule.getRules().get(0).getRuleId(),4); 

    }
    
    @Test
    public void testJSONRuleConversion() throws ValidationException {

        HelperRule jrule = rConverterUtil.JSONToHelperRule(json1);
        Rule rule = rConverterUtil.HelperRuleToRule(jrule, new ArquetipoExecutorConfig());  
        assertTrue(rule instanceof AndRules);
        assertEquals(((AndRules)rule).getRules().size(),2);
        assertTrue(((AndRules)rule).getRules().get(0) instanceof RuleGreaterThan);
        assertEquals(((AndRules)rule).getRules().get(0).getValue(),"50");
        assertTrue(((AndRules)rule).getRules().get(1) instanceof OrRules);
        
        Rule r_2_1=(((OrRules)((AndRules)rule).getRules().get(1)).getRules()).get(0);
        
        assertTrue(r_2_1 instanceof RuleBetween);
        assertTrue("25".equals(r_2_1.getValue()));
        assertTrue("50".equals(((RuleBetween)r_2_1).getValue2()));
        
        
        Rule r_2_2=(((OrRules)((AndRules)rule).getRules().get(1)).getRules()).get(1);
        assertTrue(r_2_2 instanceof RuleGreaterThan);
        assertTrue("5000".equals(r_2_2.getValue()));
        
        
        logger.debug(rule.generateSQL());

    }
    
    @Test
    public void testJSONLinkRuleConversion() throws ValidationException {
        Rule rule=rConverterUtil.JSONToRule(jsonLink, new ArquetipoExecutorConfig());
        assertTrue(rule!=null);
        assertTrue(((Rules)rule).getRules().get(1) instanceof RuleEqual);
        
        logger.debug(rule.generateSQL());
    }
    
    @Test
    public void testJSONCheckValues() throws ValidationException {
        try{
        Rule rule=rConverterUtil.JSONToRule(json2Values, new ArquetipoExecutorConfig());
        assertTrue(rule==null);
        }catch(es.capgemini.devon.validation.ValidationException ve){
            //OK. Se esperaba una excepcion
        }
        
    }
    
    @Test
    public void testJSONCheckValues2() throws ValidationException {
        try{
        Rule rule=rConverterUtil.JSONToRule(json1Values, new ArquetipoExecutorConfig());
        assertTrue(rule==null);
        }catch(es.capgemini.devon.validation.ValidationException ve){
            //OK. Se esperaba una excepcion
        }
    }
    
    @Test
    public void testJSONCheckFromat() throws ValidationException {
        try{
        Rule rule=rConverterUtil.JSONToRule(jsonFormat, new ArquetipoExecutorConfig());
        assertTrue(rule==null);
        }catch(es.capgemini.devon.validation.ValidationException ve){
            //OK. Se esperaba una excepcion
        }
    }
    
    
}
