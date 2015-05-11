package es.pfsgroup.recovery.batch.tasks;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.util.Assert;

import es.capgemini.devon.batch.BatchException;
import es.capgemini.devon.batch.tasks.DataLoaderTasklet;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.pfs.batch.load.pcr.BatchPCRConstantes;
import es.pfsgroup.recovery.Encriptador;

public class PFSDataLoaderTasklet extends DataLoaderTasklet {
	private static String PATH_TO_SQL_LOADER_KEY = "pathToSqlLoader";
	private static String PATH_TO_CONTROL_FILE_KEY = "controlFile";
	private static String CONNECTION_INFO_KEY = "connectionInfo";

	private String pathToSqlLoader;
	private String connectionInfo;
	private String sqlLoaderParameters;

	@Override
	public ExitStatus executeInternal() {
		int exitVal = 0;

		String pathToSqlLoader = getParameter(PATH_TO_SQL_LOADER_KEY);
		Assert.state(pathToSqlLoader != null, PATH_TO_SQL_LOADER_KEY
				+ " is null");

		String controlFile = getParameter(PATH_TO_CONTROL_FILE_KEY);
		Assert.state(controlFile != null, PATH_TO_CONTROL_FILE_KEY + " is null");

		Assert.state(connectionInfo != null, CONNECTION_INFO_KEY + " is null");

		File logFile = null;

		Resource ctlFile = new FileSystemResource(controlFile);
		try {
			logFile = File.createTempFile("TMP", ".log");

			final File dataFile = searchDataFile(getResource().getFile()
					.getAbsoluteFile());
			final String badFile = dataFile.getAbsolutePath() + ".badfile";
            final String discardFile = dataFile.getAbsolutePath() + ".discardfile";

			/*
			 * String[] commands = new String[] { pathToSqlLoader,
			 * connectionInfo, "control=" + ctlFile.getFile().getAbsolutePath(),
			 * sqlLoaderParameters, "data=" + dataFile, "log=" +
			 * logFile.getAbsolutePath() };
			 */

			String[] commands = new String[] { pathToSqlLoader,
					Encriptador.desencriptarPwUrl(connectionInfo),
					"control=" + ctlFile.getFile().getAbsolutePath(),
					sqlLoaderParameters, "data=" + dataFile,
					"log=" + logFile.getAbsolutePath(), "bad=" + badFile,
					"discard=" + discardFile };

			Process child = Runtime.getRuntime().exec(commands);

			InputStream inStd = child.getInputStream();
			InputStreamReader inStdR = new InputStreamReader(inStd);
			BufferedReader bStd = new BufferedReader(inStdR);

			String line = null;
			while ((line = bStd.readLine()) != null) {
				// System.out.println(line);
			}
			exitVal = child.waitFor();

		} catch (Exception e) {
			EventBatchUtil.getInstance().throwEventErrorChannel(e,
					getSeveridad(), getMessage());
			if (log.isErrorEnabled())
				log.error(e);
			return ExitStatus.FAILED;
		}

		if (exitVal != 0) {
			String errors = null;
			try {
				errors = FileUtils.readFile(logFile);
			} catch (IOException e) {
				errors = e.getMessage();
				if (log.isErrorEnabled())
					log.error(e);
			}
			EventBatchUtil.getInstance().throwEventErrorChannel(
					new BatchException("batch.dataloader.error", errors),
					getSeveridad(), getMessage());
			if (log.isErrorEnabled() && errors != null)
				log.error(errors);
			return ExitStatus.FAILED;
		}

		return ExitStatus.FINISHED;

	}

	private File searchDataFile(File initialFile) throws FileNotFoundException {
		if (initialFile.exists()) {
			return initialFile;
		} else {
			// Intentamos con un txt
			final File txtFile = tryotherfile(initialFile,
					BatchPCRConstantes.TXT);
			if (txtFile.exists()) {
				log.warn("File changed for loading " + initialFile.getName()
						+ " -> " + txtFile.getName());
				return txtFile;
			} else {
				throw new FileNotFoundException(initialFile.getAbsolutePath()
						+ ": No se ha encontrado el fichero");
			}
		}
	}

	private File tryotherfile(final File initialFile, final String extension) {
		final String txtfilepath = initialFile.getAbsolutePath().replaceAll(
				BatchPCRConstantes.CSV, extension);
		return new File(txtfilepath);
	}

	private static Log log = LogFactory.getLog(PFSDataLoaderTasklet.class);

	/**
	 * @return the pathToSqlLoader
	 */
	public String getPathToSqlLoader() {
		return pathToSqlLoader;
	}

	/**
	 * @param pathToSqlLoader
	 *            the pathToSqlLoader to set
	 */
	public void setPathToSqlLoader(String pathToSqlLoader) {
		this.pathToSqlLoader = pathToSqlLoader;
	}

	/**
	 * @return the connectionInfo
	 */
	public String getConnectionInfo() {
		return connectionInfo;
	}

	/**
	 * @param connectionInfo
	 *            the connectionInfo to set
	 */
	public void setConnectionInfo(String connectionInfo) {
		this.connectionInfo = connectionInfo;
	}

	/**
	 * @return the sqlLoaderParameters
	 */
	public String getSqlLoaderParameters() {
		return sqlLoaderParameters;
	}

	/**
	 * @param sqlLoaderParameters
	 *            the sqlLoaderParameters to set
	 */
	public void setSqlLoaderParameters(String sqlLoaderParameters) {
		this.sqlLoaderParameters = sqlLoaderParameters;
	}
}
