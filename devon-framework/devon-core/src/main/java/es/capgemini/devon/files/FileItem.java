package es.capgemini.devon.files;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Serializable;
import java.io.Writer;
import java.util.UUID;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;

/**
 * Representación de un fichero
 *
 * @author Nicolás Cornaglia
 */

public class FileItem implements Serializable {

    private UUID id;
    private File file;
    private String fileName;
    private String contentType;
    private long length;
    private long evictTime;

    public FileItem() {
        this.id = UUID.randomUUID();
    }

    public FileItem(File file) {
        this();
        this.file = file;
    }

    /**
     * Crea un Writer con buffer para la escritura
     * 
     * @return
     * @throws FileException
     */
    public Writer getWriter() throws FileException {
        BufferedWriter out;
        try {
            out = new BufferedWriter(new FileWriter(getFile()));
        } catch (IOException e) {
            throw new FileException(e);
        }
        return out;
    }

    /**
     * Crea un OutputStream con buffer para la escritura
     * 
     * @return
     * @throws FileException
     */
    public OutputStream getOutputStream() {
        OutputStream out;
        try {
            out = new BufferedOutputStream(new FileOutputStream(getFile()));
        } catch (IOException e) {
            throw new FileException(e);
        }
        return out;
    }

    /**
     * @return
     * @throws FileException
     */
    public InputStream getInputStream() throws FileException {
        InputStream in;
        try {
            in = new BufferedInputStream(new FileInputStream(getFile()));
        } catch (IOException e) {
            throw new FileException(e);
        }
        return in;
    }

    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }

    /**
     * @return the id
     */
    public UUID getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(UUID id) {
        this.id = id;
    }

    /**
     * @return the file
     */
    public File getFile() {
        return file;
    }

    /**
     * @param filePath the file to set
     */
    public void setFile(File file) {
        this.file = file;
    }

    /**
     * @return the fileName
     */
    public String getFileName() {
        return fileName;
    }

    /**
     * @param fileName the fileName to set
     */
    public void setFileName(String fileName) {
        String normalized = fileName.replace('\\', File.separatorChar);
        File tmpFile = new File(normalized);
        this.fileName = tmpFile.getName();
    }

    /**
     * @return the contentType
     */
    public String getContentType() {
        return contentType;
    }

    /**
     * @param mimeType the mimeType to set
     */
    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    /**
     * @return the length
     */
    public long getLength() {
        return length;
    }

    /**
     * @param length the length to set
     */
    public void setLength(long length) {
        this.length = length;
    }

    /**
     * @return the evictTime
     */
    public long getEvictTime() {
        return evictTime;
    }

    /**
     * @param time
     */
    public void setEvictTime(long evictTime) {
        this.evictTime = evictTime;
    }

}
