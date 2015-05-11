package es.capgemini.pfs.test.ruleengine;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.ruleengine.rule.dd.DDRule;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleManager;
import es.capgemini.pfs.test.CommonTestAbstract;

/**
 * 
 * @author lgiavedo
 */
public class DDRuleManagerTest extends CommonTestAbstract {

    @Autowired
    private DDRuleManager rdManager;

   
    /**
     * Test RuleDefinitionManager.getList
     */
    @Test
    public void testGetList() {
        // Obtenemos la lista de RD
        List<DDRule> rlist = rdManager.getList();
        //Confirmamos que no sea nula
        assertNotNull(rlist);
        //Confirmamos que contenga datos
        assertTrue(rlist.size() > 0);
    }

   

}
