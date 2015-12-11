package es.capgemini.devon.utils;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 * @author Nicolás Cornaglia
 */
public class ZipUtils {

    public static void extract(ZipFile zipFile, File toDir) throws IOException {
        extract(zipFile, toDir, ".*");
    }

    /**
     * Extracts a zip file to a specified directory.
     * @param zipFile the zip file to extract
     * @param toDir the target directory
     * @throws java.io.IOException
     */
    public static void extract(ZipFile zipFile, File toDir, String pattern) throws IOException {
        extract(zipFile, toDir, pattern, false);
    }

    /**
     * Extracts a zip file to a specified directory.
     * @param zipFile the zip file to extract
     * @param toDir the target directory
     * @param flatten subdirectories into one directory
     * @throws java.io.IOException
     */
    public static void extract(ZipFile zipFile, File toDir, String pattern, boolean flatten) throws IOException {
        if (!toDir.exists()) {
            toDir.mkdirs();
        }
        try {
            Enumeration entries = zipFile.entries();
            while (entries.hasMoreElements()) {
                ZipEntry zipEntry = (ZipEntry) entries.nextElement();
                if (zipEntry.getName().matches(pattern)) {
                    if (!flatten && zipEntry.isDirectory()) {
                        File dir = new File(toDir, zipEntry.getName());
                        if (!dir.exists()) { // make sure also empty directories get created!
                            dir.mkdirs();
                        }
                    }
                    if (!zipEntry.isDirectory()) extract(zipFile, zipEntry, toDir, flatten);
                }
            }
        } finally {
            zipFile.close();
        }
    }

    /**
     * Extracts an entry of a zip file to a specified directory.
     * 
     * @param zipFile the zip file to extract from
     * @param zipEntry the entry of the zip file to extract
     * @param toDir the target directory
     * @param flatten subdirectories into one directory
     * @throws java.io.IOException
     */
    public static void extract(ZipFile zipFile, ZipEntry zipEntry, File toDir) throws IOException {
        extract(zipFile, zipEntry, toDir, false);
    }

    /**
     * Extracts an entry of a zip file to a specified directory.
     * 
     * @param zipFile the zip file to extract from
     * @param zipEntry the entry of the zip file to extract
     * @param toDir the target directory
     * @throws java.io.IOException
     */
    public static void extract(ZipFile zipFile, ZipEntry zipEntry, File toDir, boolean flatten) throws IOException {
        File file = null;
        if (flatten)
            file = new File(toDir, new File(zipEntry.getName()).getName());
        else
            file = new File(toDir, zipEntry.getName());

        File parentDir = file.getParentFile();
        if (!parentDir.exists()) {
            parentDir.mkdirs();
        }

        BufferedInputStream bis = null;
        BufferedOutputStream bos = null;
        try {
            InputStream istr = zipFile.getInputStream(zipEntry);
            bis = new BufferedInputStream(istr);
            FileOutputStream fos = new FileOutputStream(file);
            bos = new BufferedOutputStream(fos);
            copy(bis, bos);
        } finally {
            if (bis != null) {
                bis.close();
            }
            if (bos != null) {
                bos.close();
            }
        }
    }

    /**
     * Creates a valid ZipEntry name from a file. A valid ZipEntry name is not absolute
     * and uses '/' as file separator not the platform specific one!<br>
     * If the file is absolute the root directory will not appear in the name!<br>
     * The file must not be a root directory!
     * 
     * @param file the file the entry name gets created from. <br>
     * May be an absolute path but must not be a root directory
     * @return a valid ZipEntry name
     */
    public static String createEntryName(File file) {
        String[] allPathNames = getPathNames(file);
        String[] pathNames;
        if (file.isAbsolute()) {
            if (file.getParentFile() != null) {
                pathNames = new String[allPathNames.length - 1];
                System.arraycopy(allPathNames, 1, pathNames, 0, pathNames.length);
            } else {
                throw new IllegalArgumentException("The file must not be a root directory!");
            }
        } else {
            pathNames = allPathNames;
        }
        return join(pathNames, "/");
    }

    public static void copy(InputStream in, OutputStream out) throws IOException {
        int c;

        while ((c = in.read()) != -1) {
            out.write(c);
        }
    }

    public static String[] getPathNames(File path) {
        List pathList = new ArrayList();
        File currentPath = path;
        pathList.add(currentPath.getName());
        while (currentPath.getParentFile() != null) {
            currentPath = currentPath.getParentFile();
            pathList.add(currentPath.getName());
        }
        Collections.reverse(pathList);
        return (String[]) pathList.toArray(new String[pathList.size()]);
    }

    public static String join(String[] strings, String delimiter) {
        return join(strings, false, delimiter, false);
    }

    public static String join(String[] strings, boolean prepend, String delimiter) {
        return join(strings, prepend, delimiter, false);
    }

    public static String join(String[] strings, String delimiter, boolean append) {
        return join(strings, false, delimiter, append);
    }

    public static String join(String[] strings, boolean prepend, String delimiter, boolean append) {
        StringBuffer string = new StringBuffer();
        if (prepend) {
            string.append(delimiter);
        }
        for (int i = 0; i < strings.length; i++) {
            string.append(strings[i]);
            if (i < strings.length - 1) {
                string.append(delimiter);
            }
        }
        if (append) {
            string.append(delimiter);
        }
        return string.toString();
    }

}
