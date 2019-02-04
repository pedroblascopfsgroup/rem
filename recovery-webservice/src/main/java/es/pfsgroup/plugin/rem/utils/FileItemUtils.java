package es.pfsgroup.plugin.rem.utils;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.Date;
import java.util.Random;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;

public class FileItemUtils {
	
	private static final Object MONITOR = new Object();
	
	private static final Random RANDOM = new Random();
	
	private FileItemUtils(){}
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	public static FileItem fromResource(String resourceName) {
		try{
			if (! Checks.esNulo(resourceName)) {
				URL url = FileItemUtils.class.getClassLoader().getResource(resourceName);
				if (url == null) {
					throw new IllegalStateException("No se ha podido encontrar el recurso: " + resourceName);
				}
				File dest = getTemporaryFile(FilenameUtils.getExtension(resourceName));
				if (dest != null) {
					try {
						FileUtils.copyURLToFile(url, dest);
					} catch (IOException e) {
						throw new IllegalStateException("No se ha podido copiar el recurso " + resourceName + " -> " + dest, e);
					}
					return new FileItem(dest);
				} else {
					throw new IllegalStateException("No se ha podido obtener un fichero temporal.");
				}
				
			} else {
				return null;
			}
		}catch(Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	
	private static File getTemporaryFile(final String extension) {
		synchronized (MONITOR) {
			try {
				String fileExtension = Checks.esNulo(extension) ? ".tmp" : ("." + extension.replaceFirst("\\.", ""));
				String directory = System.getProperty("java.io.tmpdir");
				File file = newRandomFile(directory, fileExtension);
				
				while(file.exists()) {
					MONITOR.wait(1000);
					file = newRandomFile(directory, fileExtension);
				}
				
				return file;
			} catch (InterruptedException e) {
				Thread.currentThread().interrupt();
				return null;
			} finally {
				MONITOR.notifyAll();
			}
		}
	}

	private static File newRandomFile(String directory, String fileExtension) {
		return new File(directory + ("/tmp_" + new Date().getTime() + "_" + RANDOM.nextInt()) + fileExtension);
	}

}
