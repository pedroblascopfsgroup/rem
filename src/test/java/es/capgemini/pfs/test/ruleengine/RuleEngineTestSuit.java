package es.capgemini.pfs.test.ruleengine;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

/**
 * Clase para ejecutar de forma conjunta los Junits de Rule Engine.
 *
 * @author lgiavedo
 *
 */
@RunWith(Suite.class)
@Suite.SuiteClasses({
    ConverterUtilTest.class,
    DDRuleManagerTest.class,
    JSONTest.class,
    RuleDefinitionManagerTest.class,
    RuleExecutorJSONTest.class
    })
public class RuleEngineTestSuit {

}