package es.capgemini.pfs.batch.revisar.arquetipos.test;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.batch.repeat.ExitStatus;

import es.capgemini.pfs.batch.revisar.arquetipos.RepositorioArquetipos;
import es.capgemini.pfs.batch.revisar.arquetipos.RevisionGenericaArquetiposTasklet;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.ExtendedRuleExecutorException;
import es.capgemini.pfs.ruleengine.RuleExecutor;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;
import es.capgemini.pfs.ruleengine.state.RuleEndState;

@RunWith(MockitoJUnitRunner.class)
public class RevisionGenericaArquetiposTaskletTest {

	@InjectMocks
	private RevisionGenericaArquetiposTasklet tasklet;

	@Mock
	private RuleExecutor mockRuleExecutor;


	@Mock
	private RepositorioArquetipos mockRepositorioArquetipos;

	private RuleExecutorConfig myRuleExecutorConfig;
	private List<RuleEndState> myRuleList;

	@Before
	public void before() {
		myRuleExecutorConfig = new RuleExecutorConfig();
		myRuleList = new ArrayList<RuleEndState>();

		when(mockRuleExecutor.getConfig()).thenReturn(myRuleExecutorConfig);
		when(mockRepositorioArquetipos.getList()).thenReturn(myRuleList);
	}

	@After
	public void after() {
		reset(mockRuleExecutor);
		reset(mockRepositorioArquetipos);

		myRuleExecutorConfig = null;
		myRuleList = null;
	}

	@Test
	public void testArquetipacion() {
		final ExitStatus status = tasklet.execute();

		verify(mockRuleExecutor).execRules(myRuleList);

		assertEquals("El estado de salida no es el esperado",
				ExitStatus.FINISHED, status);
	}

	/**
	 * Probamos qué es lo que debe pasar si el RuleExecutor falla.
	 */
	@Test
	public void testExceptionRuleExecutor() {
		when(mockRuleExecutor.execRules(myRuleList)).thenThrow(
				new ExtendedRuleExecutorException());
		final ExitStatus status = tasklet.execute();
		assertEquals("El estado de salida no es el esperado",
				ExitStatus.FAILED, status);
	}

}
