package es.pfsgroup.plugin.rem.utils;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.Date;
import java.util.Random;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;

public class FileItemUtils {
	
	private static final Object MONITOR = new Object();
	
	private static final Random RANDOM = new Random();
	
	public static FileItem fromResource(String resourceName) {
		
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
					throw new IllegalStateException("No se ha podido copiar el recurso " + resourceName + " -> " + dest);
				}
				return new FileItem(dest);
			} else {
				throw new IllegalStateException("No se ha podido obtener un fichero temporal.");
			}
			
		} else {
			return null;
		}
	}
	
	
	private static File getTemporaryFile(final String extension) {
		synchronized (MONITOR) {
			try {
				String name = "tmp_" + new Date().getTime() + "_" + RANDOM.nextInt();
				
				String fileExtension = Checks.esNulo(extension) ? ".tmp" : ("." + extension.replaceFirst("\\.", ""));
				String pathname = System.getProperty("java.io.tmpdir") + name;
				File file = new File(pathname + fileExtension);
				
				if (file.exists()) {
					Thread.sleep(1000);
					return getTemporaryFile(extension);
				} else {
					return file;
				}
			} catch (InterruptedException e) {
				Thread.currentThread().interrupt();
				return null;
			} finally {
				MONITOR.notifyAll();
			}
		}
	}

}
