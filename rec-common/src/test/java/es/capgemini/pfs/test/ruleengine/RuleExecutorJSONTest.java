package es.capgemini.pfs.test.ruleengine;

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
import es.capgemini.pfs.ruleengine.RuleExecutor;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;
import es.capgemini.pfs.ruleengine.RuleResult;
import es.capgemini.pfs.ruleengine.filter.RuleFilter;
import es.capgemini.pfs.ruleengine.filter.imp.PersonaRuleFilter;
import es.capgemini.pfs.test.CommonTestAbstract;
import es.capgemini.pfs.test.ruleengine.bean.json.ArquetipoFechaMayor;
import es.capgemini.pfs.test.ruleengine.bean.json.ArquetipoFechaMenor;
import es.capgemini.pfs.test.ruleengine.bean.json.ArquetipoSexoHombre;
import es.capgemini.pfs.test.ruleengine.bean.json.ArquetipoSexoMujer;
import es.capgemini.pfs.test.ruleengine.bean.json.ArquetipoTest2;
import es.capgemini.pfs.test.ruleengine.bean.json.ArquetipoTest3;

/**
 * @author lgiavedo
 *
 */
public class RuleExecutorJSONTest extends CommonTestAbstract {

    @Resource(name = "arquetiposRuleExecutor")
    private RuleExecutor rExecutor;

    /*@Resource(name="arquetiposRuleExecutorConf")
    private RuleExecutorConfig reConfig;*/

    @Autowired
    private ArquetipoManager arquetipoManager;

    @javax.annotation.Resource
    private EntityDataSource entityDataSource;

    private static boolean resteBD = true;

    private final Log logger = LogFactory.getLog(getClass());

    @Before
    public void setUp() throws Exception {
        //Reiniciamos los Arquetipos
        if (resteBD) {
            //resetBD();
            resteBD = false;
        }
        rExecutor.getConfig().setRuleDefinitionType(RuleExecutorConfig.RULE_DEFINITION_TYPE_JSON);
    }

    @Test
    public void testArquetipoMujer() throws Exception {
        assertTrue(rExecutor.execRule(new ArquetipoSexoMujer()).isFinishedOK());
    }

    @Test
    public void testArquetipo2() throws Exception {
        assertTrue(rExecutor.execRule(new ArquetipoTest2()).isFinishedOK());
    }

    @Test
    public void testArquetipo3() throws Exception {
        assertTrue(rExecutor.execRule(new ArquetipoTest3()).isFinishedOK());
    }

    @Test
    public void testArquetipoFechaMenor() throws Exception {
        RuleResult rr = rExecutor.execRule(new ArquetipoFechaMenor());
        assertTrue(rr.isFinishedOK());
        assertTrue(rr.getRowsModified() == 0);
    }

    @Test
    public void testArquetipoFechaMayor() throws Exception {
        RuleResult rr = rExecutor.execRule(new ArquetipoFechaMayor());
        assertTrue(rr.isFinishedOK());
        assertTrue(rr.getRowsModified() > 0);
    }

    @Test
    public void testArquetipoBD1() throws Exception {
        assertTrue(rExecutor.execRule(arquetipoManager.get(1L)).isFinishedOK());
    }

    @Test
    public void testArquetipoBD2() throws Exception {
        assertTrue(rExecutor.execRule(arquetipoManager.get(2L)).isFinishedOK());
    }

    @Test
    @SuppressWarnings("unchecked")
    public void testAllArquetipoFromBD() throws Exception {
        List<RuleResult> l = rExecutor.execRules(arquetipoManager.getList());
        for (Iterator<RuleResult> iterator = l.iterator(); iterator.hasNext();) {
            assertTrue(iterator.next().isFinishedOK(true));
        }

    }

    @Test
    public void testRuleFilter() throws Exception {
        //Reseteamos la persona
        clearNuevoArquetipo(1L);

        PersonaRuleFilter prf = new PersonaRuleFilter(1L);
        List<RuleFilter> l = new ArrayList<RuleFilter>();
        l.add(prf);

        RuleResult rr = rExecutor.execRule(new ArquetipoSexoHombre(), l);
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
