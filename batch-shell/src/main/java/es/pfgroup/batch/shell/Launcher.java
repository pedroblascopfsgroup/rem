package es.pfgroup.batch.shell;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Date;

import es.pfgroup.monioring.bach.load.CheckStatusApp;
import es.pfgroup.monioring.bach.load.CheckStatusResult;

/**
 * Esta clase lanza de síncrona jobs del batch, esperando que termine su
 * ejecución.
 * 
 * @author bruno
 * 
 * 
 */
public class Launcher {

	private static final int MAX_NOOP_CHECKS = 3;
	public static boolean debugMode = false;

	private JMXClientFacade jmxFacade;

	private CheckStatusApp checkStatus;

	/**
	 * Ejecuta un job del batch.
	 * 
	 * @param args
	 */
	public static void main(String[] args) {

		try {

			Launcher launcher;
			launcher = new Launcher(new JMXClientFacade(),
					CheckStatusApp.createApplication());
			final LauncherExitStatus status = launcher.launch(args);
			System.out.println(status);
			System.exit(status.ordinal());
		} catch (FileNotFoundException e) {
			System.out.println("ERROR: " + e.getMessage());
			System.exit(1);
		} catch (IOException e) {
			System.out.println("ERROR: " + e.getMessage());
			System.exit(1);
		} catch (IllegalArgumentException e) {
			System.out.println("PARAMETROS INCORRECTOS");
			System.out
					.println("Uso: java -jar $JAR_NAME $JMX_AUTH $JMX_URL $JMX_MBEAN $JMX_CALL $JOB_NAME");
			System.exit(1);
		} catch (UserInterruptionNonCheckedException e) {
			System.out.println("SHELL Interrumpida por el usuario");
			System.exit(2);
		} catch (RuntimeException e) {
			System.out.println("ERROR DESCONOCIDO: " + e.getMessage());
			System.exit(1);
		}

	}

	public Launcher(final JMXClientFacade jmxFacade,
			final CheckStatusApp checkStatus) {
		super();
		this.jmxFacade = jmxFacade;
		this.checkStatus = checkStatus;
	}

	/**
	 * Lanza la ejecución de un proceso batch.
	 * 
	 * @param args
	 * @return
	 */
	public final LauncherExitStatus launch(final String... args) {
		final Date startDate = new Date();
		
		try {
			Thread.currentThread().sleep(15000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		if ((args == null) || (args.length != 5)) {
			throw new IllegalArgumentException();
		}

		final JMXConnectionInfo cninfo = new JMXConnectionInfo();
		cninfo.setJmxAuth(args[0]);
		cninfo.setJmxUrl(args[1]);
		cninfo.setJmxMBean(args[2]);
		cninfo.setJmxCall(args[3]);

		final String rawJobList = args[4];

		final String[] jobList = rawJobList.split(",");

		final String jobarg = cninfo.getJmxCall();
		int p = jobarg.indexOf("=");

		final Integer entidad = Integer.parseInt(jobarg.substring(p + 1));

		if (cninfo.hasData()) {
			jmxFacade.launchJMX(cninfo);
		}

		// Mediante estas variables controlamoz la monitorización para cuando tengamos un Job que finalice con NOOP
		int noopchecks = 0; // número de checks después del NOOP
		boolean postNOOPCheck = false; // Flag que indica si debemos hacer checks post-NOOP
		
		for (int i = 0; i < jobList.length; i++) {
			final SynchronizedCheckStatus scheck = new SynchronizedCheckStatus(
					checkStatus, startDate, debugMode);

			final String jobName = jobList[i];

			final CheckStatusResult status = scheck.checkStatus(entidad,
					jobName, postNOOPCheck);

			if (CheckStatusResult.OK.equals(status)) {
				postNOOPCheck = false;
				noopchecks = 0;
				continue;
			} else if (CheckStatusResult.NOOP.equals(status)) {
				postNOOPCheck = true;
				noopchecks = 0;
			}else if (postNOOPCheck){
				/*
				 * Realizamos un check si el job anterior ha finalizado con NOOP
				 */
				if (noopchecks >= MAX_NOOP_CHECKS){
					break;
				}else{
					noopchecks += 1;
					continue;
				}
			}
			else {
				return LauncherExitStatus.ERROR;
			}
		}
		// Si terminamos el bucle ese porque ha iod OK
		return LauncherExitStatus.OK;

	}

}
