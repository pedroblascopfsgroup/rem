package es.capgemini.pfs.test.prepoliticas;

import static org.junit.Assert.assertNotNull;

import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.politica.dao.DDTipoPoliticaDao;
import es.capgemini.pfs.ruleengine.executor.imp.PrepoliticaRuleExecutor;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleManager;
import es.capgemini.pfs.test.CommonTestAbstract;

/**
 * @author lgiavedo
 *
 */
public class PrepoliticasRuleExecutorTest extends CommonTestAbstract {

    @Autowired
    private PrepoliticaRuleExecutor rExecutor;

    @Autowired
    private DDRuleManager rManager;

    @Autowired
    private DDTipoPoliticaDao dao;

    @Test
    @SuppressWarnings("unchecked")
    public void testExecRules() throws Exception {
        rManager.regenerateData(rExecutor.getConfig());
        assertNotNull(rExecutor.execRules((List) dao.getList()));
    }

}
