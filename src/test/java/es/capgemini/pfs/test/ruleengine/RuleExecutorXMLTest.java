package es.capgemini.pfs.test.ruleengine;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.arquetipo.ArquetipoManager;
import es.capgemini.pfs.dsm.EntityDataSource;
import es.capgemini.pfs.ruleengine.RuleConverterUtil;
import es.capgemini.pfs.ruleengine.RuleExecutor;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;
import es.capgemini.pfs.ruleengine.RuleResult;
import es.capgemini.pfs.ruleengine.filter.RuleFilter;
import es.capgemini.pfs.ruleengine.filter.imp.PersonaRuleFilter;
import es.capgemini.pfs.test.CommonTestAbstract;
import es.capgemini.pfs.test.ruleengine.bean.ArquetipoExecutorConfig;
import es.capgemini.pfs.test.ruleengine.bean.xml.ArquetipoFechaMayorXML;
import es.capgemini.pfs.test.ruleengine.bean.xml.ArquetipoFechaMenorXML;
import es.capgemini.pfs.test.ruleengine.bean.xml.ArquetipoSexoHombreXML;
import es.capgemini.pfs.test.ruleengine.bean.xml.ArquetipoSexoMujerXML;

/**
 * @author lgiavedo
 *
 */
public class RuleExecutorXMLTest extends CommonTestAbstract {

    @Resource(name = "arquetiposRuleExecutor")
    private RuleExecutor rExecutor;

    /*@Resource(name="arquetiposRuleExecutorConf")
    private RuleExecutorConfig reConfig;*/

    @Autowired
    private ArquetipoManager arquetipoManager;

    @javax.annotation.Resource
    private EntityDataSource entityDataSource;

    @Autowired
    private RuleConverterUtil rcUtil;

    private static boolean resteBD = true;

    private final Log logger = LogFactory.getLog(getClass());

    @Before
    public void setUp() throws Exception {
        //Reiniciamos los Arquetipos
        if (resteBD) {
            //resetBD();
            resteBD = false;
        }
        rExecutor.getConfig().setRuleDefinitionType(RuleExecutorConfig.RULE_DEFINITION_TYPE_XML);
    }

    @Test
    public void testWellFormedXML() throws Exception {
        assertNotNull(rcUtil.XMLToRule(new ArquetipoSexoMujerXML().getDefinitionRule(), new ArquetipoExecutorConfig()));
        assertNotNull(rcUtil.XMLToRule(new ArquetipoFechaMenorXML().getDefinitionRule(), new ArquetipoExecutorConfig()));
    }

    @Test
    public void testArquetipoMujerXML() throws Exception {
        assertTrue(rExecutor.execRule(new ArquetipoSexoMujerXML()).isFinishedOK());
    }

    //    @Test
    //    public void testArquetipo2() throws Exception {
    //        assertTrue(rExecutor.execRule(new ArquetipoTest2()).isFinishedOK());
    //    }
    //
    //    @Test
    //    public void testArquetipo3() throws Exception {
    //        assertTrue(rExecutor.execRule(new ArquetipoTest3()).isFinishedOK());
    //    }

    @Test
    public void testArquetipoFechaMenor() throws Exception {
        RuleResult rr = rExecutor.execRule(new ArquetipoFechaMenorXML());
        assertTrue(rr.isFinishedOK());
        assertTrue(rr.getRowsModified() == 0);
    }

    @Test
    public void testArquetipoFechaMayor() throws Exception {
        RuleResult rr = rExecutor.execRule(new ArquetipoFechaMayorXML());
        assertTrue(rr.isFinishedOK());
        assertTrue(rr.getRowsModified() > 0);
    }

    //
    //    @Test
    //    public void testArquetipoBD1() throws Exception {
    //        assertTrue(rExecutor.execRule(arquetipoManager.get(1L)).isFinishedOK());
    //    }
    //
    //    @Test
    //    public void testArquetipoBD2() throws Exception {
    //        assertTrue(rExecutor.execRule(arquetipoManager.get(2L)).isFinishedOK());
    //    }

    @Test
    @SuppressWarnings("unchecked")
    public void testAllArquetipoFromBD() throws Exception {
        List<RuleResult> l = rExecutor.execRules(arquetipoManager.getList());
        for (Iterator<RuleResult> iterator = l.iterator(); iterator.hasNext();) {
            assertTrue(((RuleResult) iterator.next()).isFinishedOK(true));
        }

    }

    @Test
    public void testRuleFilter() throws Exception {
        //Reseteamos la persona
        clearNuevoArquetipo(1L);

        PersonaRuleFilter prf = new PersonaRuleFilter(1L);
        List<RuleFilter> l = new ArrayList<RuleFilter>();
        l.add(prf);

        RuleResult rr = rExecutor.execRule(new ArquetipoSexoHombreXML(), l);
        assertTrue(rr.isFinishedOK());
        assertTrue(rr.getRowsModified() == 1);
    }

    private void clearNuevoArquetipo(long personId) {
        try {
            logger.info("Reiniciando arquetipo de la persona[" + personId + "]");
            Connection c = entityDataSource.getConnection();
            c.prepareStatement("update per_personas set ARQ_ID_CALCULADO = null where per_id=" + personId).executeUpdate();
            c.commit();
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

}
