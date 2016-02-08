package es.pfgroup.batch.test.shell.Launcher;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.util.Date;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.AdditionalMatchers;
import org.mockito.ArgumentCaptor;
import org.mockito.InOrder;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.mockito.runners.MockitoJUnitRunner;
import org.mockito.stubbing.OngoingStubbing;

import es.pfgroup.batch.shell.JMXClientFacade;
import es.pfgroup.batch.shell.JMXConnectionInfo;
import es.pfgroup.batch.shell.Launcher;
import es.pfgroup.batch.shell.LauncherExitStatus;
import es.pfgroup.batch.shell.SynchronizedCheckStatus;
import es.pfgroup.monioring.bach.load.BatchExecutionData;
import es.pfgroup.monioring.bach.load.CheckStatusApp;
import es.pfgroup.monioring.bach.load.CheckStatusResult;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRecoverableException;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusWrongArgumentsException;
import es.pfgroup.monioring.bach.load.logic.CheckStatusLogic;
import es.pfgroup.monioring.bach.load.persistence.CheckStatusPersitenceService;

@RunWith(MockitoJUnitRunner.class)
public class LaunchViaJMXTests {

	@Mock
	private JMXClientFacade jmxClient;

	@Mock
	private CheckStatusLogic bmock = null;

	@Mock
	private CheckStatusPersitenceService pmock;

	@Spy
	private CheckStatusApp checkStatus = new CheckStatusApp(bmock, pmock);

	@InjectMocks
	private Launcher launcher;

	private String auth;

	private String url;

	private String mbean;

	private String jobName;

	private String entidad;

	@Before
	public void before() {

		auth = RandomStringUtils.randomAlphabetic(100);
		url = RandomStringUtils.randomAlphabetic(100);
		mbean = RandomStringUtils.randomAlphabetic(100);
		// jobName = RandomStringUtils.randomAlphabetic(100);
		jobName = "ABCDE";
		entidad = RandomStringUtils.randomNumeric(4);

		MockitoAnnotations.initMocks(this);

		doReturn(pmock).when(checkStatus).getPersistenceService();
		doReturn(bmock).when(checkStatus).getBusinessLogic();

		SynchronizedCheckStatus.setInterval(100);

	}

	@After
	public void after() {
		auth = null;
		url = null;
		mbean = null;
		jobName = null;
		entidad = null;
	}

	/**
	 * Invoca un job que previamente está parado y finaliza correctamente.
	 */
	@Test
	public void test_Launch_Success() {
		try {
			Integer iEntidad = Integer.parseInt(entidad);

			simulateSuccessExecution(iEntidad);
			// OK

			final LauncherExitStatus status = launcher.launch(auth, url, mbean, jobName + "=" + entidad, jobName);

			ArgumentCaptor<JMXConnectionInfo> captor = ArgumentCaptor.forClass(JMXConnectionInfo.class);

			verifyCorrectLaunch(captor);

			assertEquals("El código de error no es el esperado", LauncherExitStatus.OK, status);
		} catch (CheckStatusWrongArgumentsException e) {
			// Aqui no se producirán excepciones
		}

	}

	/**
	 * Invoca un job que previamente está parado y finaliza correctamente. En
	 * este caso se monitorizan varios jobs
	 */
	@Test
	public void test_Launch_Success_NJobMonitoring() {
		try {
			Integer iEntidad = Integer.parseInt(entidad);

			final String job1 = "myjob1";
			final String job2 = "myjob2";
			final String job3 = "myjob3";
			final String job4 = "myjob4";

			final String jobsList = new StringBuilder().append(job1).append(",").append(job2).append(",").append(job3)
					.append(",").append(job4).toString();

			simulaCheckStatus(new RunJobInfo(iEntidad, job1),
					new BatchExecutionData[] { new BatchExecutionData(true, false, true, false) });
			simulaCheckStatus(new RunJobInfo(iEntidad, job2),
					new BatchExecutionData[] { new BatchExecutionData(true, false, true, false) });
			simulaCheckStatus(new RunJobInfo(iEntidad, job3),
					new BatchExecutionData[] { new BatchExecutionData(true, false, true, false) });
			simulaCheckStatus(new RunJobInfo(iEntidad, job4),
					new BatchExecutionData[] { new BatchExecutionData(true, false, true, false) });

			final LauncherExitStatus status = launcher.launch(auth, url, mbean, jobName + "=" + entidad, jobsList);

			ArgumentCaptor<JMXConnectionInfo> captor = ArgumentCaptor.forClass(JMXConnectionInfo.class);

			verifyCorrectLaunch(captor);

			assertEquals("El código de error no es el esperado", LauncherExitStatus.OK, status);
		} catch (CheckStatusWrongArgumentsException e) {
			// Aqui no se producirán excepciones
		}

	}

	/**
	 * En este test sólo se monitorizan varios jobs, no se lanza ninguno a
	 * través de JMX
	 */
	@Test
	public void test_OnlyMonitor_Success_NJobMonitoring() {
		try {
			Integer iEntidad = Integer.parseInt(entidad);

			final String job1 = "myjob1";
			final String job2 = "myjob2";
			final String job3 = "myjob3";
			final String job4 = "myjob4";

			final String jobsList = new StringBuilder().append(job1).append(",").append(job2).append(",").append(job3)
					.append(",").append(job4).toString();

			simulaCheckStatus(new RunJobInfo(iEntidad, job1),
					new BatchExecutionData[] { new BatchExecutionData(true, false, true, false) });
			simulaCheckStatus(new RunJobInfo(iEntidad, job2),
					new BatchExecutionData[] { new BatchExecutionData(true, false, true, false) });
			simulaCheckStatus(new RunJobInfo(iEntidad, job3),
					new BatchExecutionData[] { new BatchExecutionData(true, false, true, false) });
			simulaCheckStatus(new RunJobInfo(iEntidad, job4),
					new BatchExecutionData[] { new BatchExecutionData(true, false, true, false) });

			final LauncherExitStatus status = launcher.launch("-", "-", "-", "=" + entidad, jobsList);

			verifyNoLaunch();

			assertEquals("El código de error no es el esperado", LauncherExitStatus.OK, status);
		} catch (CheckStatusWrongArgumentsException e) {
			// Aqui no se producirán excepciones
		}

	}

	/**
	 * En este test sólo se monitorizan varios jobs, no se lanza ninguno a
	 * través de JMX
	 */
	@Test
	public void test_OnlyMonitor_Failure_NJobMonitoring() {
		try {
			Integer iEntidad = Integer.parseInt(entidad);

			final String job1 = "myjob1";
			final String job2 = "myjob2";
			final String job3 = "myjob3";
			final String job4 = "myjob4";

			final String jobsList = new StringBuilder().append(job1).append(",").append(job2).append(",").append(job3)
					.append(",").append(job4).toString();

			simulaCheckStatus(new RunJobInfo(iEntidad, job1),
					new BatchExecutionData[] { new BatchExecutionData(true, false, true, false) });
			simulaCheckStatus(new RunJobInfo(iEntidad, job2),
					new BatchExecutionData[] { new BatchExecutionData(true, true, true, false) });

			final LauncherExitStatus status = launcher.launch("-", "-", "-", "=" + entidad, jobsList);

			verifyNoLaunch();

			assertEquals("El código de error no es el esperado", LauncherExitStatus.ERROR, status);
		} catch (CheckStatusWrongArgumentsException e) {
			// Aqui no se producirán excepciones
		}

	}

	/**
	 * Invoca un job que previamente está parado y finaliza con un error.
	 */
	@Test
	public void test_Launch_Failure() {
		try {
			Integer iEntidad = Integer.parseInt(entidad);

			final String job1 = "myjob1";
			final String job2 = "myjob2";
			final String job3 = "myjob3";
			final String job4 = "myjob4";

			final String jobsList = new StringBuilder().append(job1).append(",").append(job2).append(",").append(job3)
					.append(",").append(job4).toString();

			simulaCheckStatus(new RunJobInfo(iEntidad, job1),
					new BatchExecutionData[] { new BatchExecutionData(true, false, true, false) });
			simulaCheckStatus(new RunJobInfo(iEntidad, job2),
					new BatchExecutionData[] { new BatchExecutionData(true, true, true, false) });

			final LauncherExitStatus status = launcher.launch(auth, url, mbean, jobName + "=" + entidad, jobsList);

			ArgumentCaptor<JMXConnectionInfo> captor = ArgumentCaptor.forClass(JMXConnectionInfo.class);

			verifyCorrectLaunch(captor);

			assertEquals("El código de error no es el esperado", LauncherExitStatus.ERROR, status);
		} catch (CheckStatusWrongArgumentsException e) {
			// Aqui no se producirán excepciones
		}

	}

	/**
	 * Invoca un job que previamente está parado y finaliza con un error.
	 */
	@Test
	public void test_Launch_Failure_NJobMonitoring() {
		try {
			Integer iEntidad = Integer.parseInt(entidad);

			simulateExecutionFailure(iEntidad);

			final LauncherExitStatus status = launcher.launch(auth, url, mbean, jobName + "=" + entidad, jobName);

			ArgumentCaptor<JMXConnectionInfo> captor = ArgumentCaptor.forClass(JMXConnectionInfo.class);

			verifyCorrectLaunch(captor);

			assertEquals("El código de error no es el esperado", LauncherExitStatus.ERROR, status);
		} catch (CheckStatusWrongArgumentsException e) {
			// Aqui no se producirán excepciones
		}

	}

	private void verifyCorrectLaunch(ArgumentCaptor<JMXConnectionInfo> captor) {
		verify(jmxClient).launchJMX(captor.capture());

		assertEquals(auth, captor.getValue().getJmxAuth());
		assertEquals(url, captor.getValue().getJmxUrl());
		assertEquals(mbean, captor.getValue().getJmxMBean());
		assertEquals(jobName + "=" + entidad, captor.getValue().getJmxCall());
	}

	private void verifyNoLaunch() {
		verifyZeroInteractions(jmxClient);

	}

	private void simulateSuccessExecution(Integer iEntidad) throws CheckStatusWrongArgumentsException {
		simulaCheckStatus(new RunJobInfo(iEntidad, jobName),
				new BatchExecutionData[] { new BatchExecutionData(false, false, false, false), // Aún
						// no
						// ha
						// empezado
						new BatchExecutionData(false, false, false, false),
						new BatchExecutionData(true, false, false, false), // Empieza
						// a
						// ejecutarse
						new BatchExecutionData(true, false, false, false),
						new BatchExecutionData(true, false, true, false) }); // Finaliza
	}

	private void simulateExecutionFailure(Integer iEntidad) throws CheckStatusWrongArgumentsException {
		simulaCheckStatus(new RunJobInfo(iEntidad, jobName),
				new BatchExecutionData[] { new BatchExecutionData(false, false, false, false), // Aún
						// no
						// ha
						// empezado
						new BatchExecutionData(false, false, false, false),
						new BatchExecutionData(true, false, false, false), // Empieza
						// a
						// ejecutarse
						new BatchExecutionData(true, false, false, false),
						new BatchExecutionData(true, true, true, false) }); // Finaliza
		// Con
		// errores
	}

	private void simulaCheckStatus(final RunJobInfo runInfo, final BatchExecutionData[] execution)
			throws CheckStatusWrongArgumentsException {

		// Aún no se ha empezado a ejecutar
		OngoingStubbing<BatchExecutionData> stub;
		try {
			stub = when(bmock.getExecutionInfo(eq(runInfo.getEntidad()), eq(runInfo.getJob()), any(Date.class)));

			if (execution != null) {
				for (int i = 0; i < execution.length; i++) {
					stub = stub.thenReturn(execution[i]);
				}
			}
		} catch (CheckStatusRecoverableException e) {
			fail("Excepción inesperada");
			e.printStackTrace();
		}
	}
}
