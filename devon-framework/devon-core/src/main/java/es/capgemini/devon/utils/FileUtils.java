package es.capgemini.devon.utils;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.util.FileCopyUtils;

import es.capgemini.devon.exception.FrameworkException;

/**
 * @author Nicolás Cornaglia
 */
public class FileUtils {

    private static final Log logger = LogFactory.getLog(FileUtils.class);
    public static String UNIX_SEPARATOR = "/"; // Unix based
    public static final int BUFFER_SIZE = 4096;

    /**
     * Borra un fichero de una carpeta
     * 
     * @param sourcePath
     * @param sourceFile
     * @return
     */
    public static boolean deleteFile(String sourcePath, String sourceFile) {
        return (new File(sourcePath + File.separator + sourceFile)).delete();
    }

    /**
     * Borra un fichero de una carpeta
     * 
     * @param resource
     * @return
     * @throws IOException
     */
    public static boolean deleteFile(Resource resource) throws IOException {
        File file = resource.getFile();
        return deleteFile(file.getParent(), file.getName());
    }

    /**
     * Borra un fichero de una carpeta
     * 
     * @param fullPath
     * @return
     * @throws IOException
     */
    public static boolean deleteFile(String fullPath) throws IOException {
        Resource resource = new FileSystemResource(fullPath);
        return deleteFile(resource);
    }

    /**
     * Deletes all subdirectories under dir.
     * Returns true if all deletions were successful.
     * If a deletion fails, the method stops attempting to delete and returns false.
     * 
     * @param dir the dir base
     * @param deleteBase also delete de dir base
     * @return
     */
    public static boolean deleteDir(File dir, boolean deleteBase) {
        if (dir.isDirectory()) {
            String[] children = dir.list();
            for (int i = 0; i < children.length; i++) {
                boolean success = deleteDir(new File(dir, children[i]), deleteBase);
                if (!success) {
                    return false;
                }
            }
        }

        // The directory is now empty so delete it
        if (deleteBase)
            return dir.delete();
        return true;
    }

    /**
     * @param dir
     */
    public static void deleteDirFiles(File dir) {
        String[] children = dir.list();
        if (children != null) {
            for (int i = 0; i < children.length; i++) {
                (new File(dir.getAbsolutePath() + File.separator + children[i])).delete();
            }
        }
    }

    /**
     * Deletes all files and subdirectories under dir.
     * Returns true if all deletions were successful.
     * If a deletion fails, the method stops attempting to delete and returns false.
     * Also delete de dir base
     * 
     * @param dir
     * @return
     */
    public static boolean deleteDir(File dir) {
        return deleteDir(dir, true);
    }

    /**
     * Mueve un fichero de carpeta
     * 
     * @param sourceFile
     * @param destinationPath
     * @return
     */
    public static boolean moveFile(String sourceFile, String destinationPath) {
        File file = new File(sourceFile);
        return file.renameTo(new File(destinationPath, file.getName()));

    }

    /**
     * Mueve un fichero de carpeta
     * 
     * @param sourcePath
     * @param sourceFileName
     * @param destinationPath
     */
    public static boolean moveFile(String sourcePath, String sourceFileName, String destinationPath) {
        return moveFile(sourcePath + File.separator + sourceFileName, destinationPath);
    }

    /**
     * Reemplaza la extensión de un fichero por otra
     * 
     * @param fileName
     * @param newExtension
     * @return
     */
    public static String replaceExtension(String fileName, String newExtension) {
        return fileName.replaceAll("\\.[^.]*$", "." + newExtension);
    }

    /**
     * Lee un fichero a un String
     * 
     * @param file
     * @return
     * @throws Exception
     */
    public static String readFile(File file) throws IOException {
        return FileCopyUtils.copyToString(new FileReader(file));
    }

    public static Properties readProperties(File file) {
        Properties p = new Properties();
        InputStream semIS = null;
        try {
            semIS = new FileInputStream(file);
            p.load(semIS);
        } catch (IOException e) {
            throw new FrameworkException(e);
        } finally {
            if (semIS != null) {
                try {
                    semIS.close();
                } catch (IOException e) {
                    logger.warn("No se pudo cerrar el fichero " + file.getAbsolutePath());
                }
            }
        }
        return p;
    }

    /**
     * Obtiene una lista de subdirectorios en base a un pattern
     * 
     * @param baseDirectory
     * @param pattern
     * @return
     */
    public static List<String> getDirectoryNames(File baseDirectory, final String pattern) {
        FileFilter fileFilter = new FileFilter() {
            public boolean accept(File file) {
                return file.isDirectory() && file.getName().matches(pattern);
            }
        };
        List<String> dirs = new ArrayList<String>();
        File[] files = baseDirectory.listFiles(fileFilter);
        if (files != null) {
            for (File file : files) {
                dirs.add(file.getName());
            }
        }
        return dirs;
    }

    /**
     * Genera las subcarpetas "baseDirectory/pattern/folder1" y opcionalmente "baseDirectory/pattern/folder1/folder2" 
     */
    public static Map<String, String> generateDirectories(File baseDirectory, final String pattern, String folder1, String folder2) {

        List<String> dirs = getDirectoryNames(baseDirectory, pattern);
        Map<String, String> result = new HashMap<String, String>();
        for (String subDir : dirs) {
            String finalPath = (baseDirectory.getPath() + File.separator + subDir + File.separator + folder1).replace("\\", UNIX_SEPARATOR);
            if (logger.isDebugEnabled()) {
                logger.debug("Generating dir [" + finalPath + "]");
            }
            (new File(finalPath)).mkdirs();
            if (folder2 != null) {
                (new File(finalPath + File.separator + folder2)).mkdirs();
            }
            result.put(subDir, finalPath);
        }
        return result;
    }

    //---------------------------------------------------------------------
    // Copy methods for java.io.InputStream / java.io.OutputStream
    //---------------------------------------------------------------------

    /**
     * Copy the contents of the given InputStream to the given OutputStream.
     * Closes "in" stream when done. Doesn't flush the "out"
     * @param in the stream to copy from
     * @param out the stream to copy to
     * @return the number of bytes copied
     * @throws IOException in case of I/O errors
     */
    public static int copy(InputStream in, OutputStream out) throws IOException {
        try {
            int byteCount = 0;
            byte[] buffer = new byte[BUFFER_SIZE];
            int bytesRead = -1;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
                byteCount += bytesRead;
            }
            //            out.flush();
            return byteCount;
        } finally {
            try {
                in.close();
            } catch (IOException ex) {
            }
            //            try {
            //                out.close();
            //            } catch (IOException ex) {
            //            }
        }
    }

}
