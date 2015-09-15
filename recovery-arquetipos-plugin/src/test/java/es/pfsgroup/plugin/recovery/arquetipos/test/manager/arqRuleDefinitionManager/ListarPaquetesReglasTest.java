package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqRuleDefinitionManager;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.*;

import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;

public class ListarPaquetesReglasTest extends AbstractARQRuleDefinitionManagerTest{
	
	/**
	 * Prueba del caso normal
	 */
	@Test
	public void testListarReglas() throws Exception{
		//devolvemos lo mismo que nos da el dao
		List<RuleDefinition> expected = new ArrayList<RuleDefinition>();
		when(ruleDao.getList()).thenReturn(expected);
		
		List<RuleDefinition> result = ruleManager.listaRule();
		
		assertEquals(expected, result);
		
		verify(ruleDao,times(1)).getList();
		
	}

}
