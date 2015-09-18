package es.pfgroup.batch.shell;

import java.util.Date;

import es.pfgroup.monioring.bach.load.BatchExecutionData;
import es.pfgroup.monioring.bach.load.CheckStatusApp;
import es.pfgroup.monioring.bach.load.CheckStatusResult;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusWrongArgumentsException;

/**
 * Realiza una comprobación del status del batch de forma síncrona
 * 
 * @author bruno
 * 
 */
public class SynchronizedCheckStatus {

	private static int interval_ms = 3000;

	public static void setInterval(int i) {
		interval_ms = i;
	}

	private CheckStatusApp app;
	private Date lastDate;

	public SynchronizedCheckStatus(final CheckStatusApp checkStatusApp,
			final Date date) {
		this.app = checkStatusApp;
		this.lastDate = date;
	}

	private class RunnableCheckStatus implements Runnable {

		private int entidad;
		private String job;
		private boolean prevNoop;

		private CheckStatusResult result;

		public CheckStatusResult getResult() {
			return result;
		}

		public RunnableCheckStatus(final int entidad, final String job, final boolean previousNOOP) {
			super();
			this.entidad = entidad;
			this.job = job;
			this.prevNoop = previousNOOP;
		}

		@Override
		public synchronized void run() {
			app.getConfig().setUsePasajeProduccionMark(false);

			try {
				CheckStatusResult localResult = null;
				BatchExecutionData execData;
				do {
					Thread.currentThread().sleep(interval_ms);

					execData = app.getBusinessLogic().getExecutionInfo(entidad,
							job, lastDate);

					if (execData.hasErrors()) {
						localResult = CheckStatusResult.ERROR;
					} else if (execData.hasExecuted()) {
						if (execData.finishWithNOOP()) {
							localResult = CheckStatusResult.NOOP;
						} else {
							localResult = CheckStatusResult.OK;
						}
					}else if (prevNoop && (!execData.isRunning())){
						localResult = CheckStatusResult.NOT_EXECUTED;
					}

				} while (localResult == null);

				this.result = localResult;
				notifyAll();

			} catch (CheckStatusWrongArgumentsException e) {
				throw new IllegalStateException(e);
			} catch (InterruptedException e) {
				throw new UserInterruptionNonCheckedException(e);
			}finally {
				notifyAll();
			}

		}

	}

	public CheckStatusResult checkStatus(final int entidad, final String job, final boolean previousNOOP) {

		final RunnableCheckStatus check = new RunnableCheckStatus(entidad, job, previousNOOP);
		try {
			synchronized (check) {
				new Thread(check).start();
				check.wait();
			}
			return check.getResult();
		} catch (InterruptedException e) {
			throw new UserInterruptionNonCheckedException(e);
		}

	}
}
