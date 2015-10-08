package es.pfgroup.monioring.bach.load.persistence.utils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

/**
 * Extiende el {@link FileOutputStream} para que devuelva los detales del ficheo
 * en el que se va a escribir.
 * 
 * @author bruno
 * 
 */
public class ExtendedFileOutputStream extends FileOutputStream {

    private final File file;

    public ExtendedFileOutputStream(final File file, final boolean append) throws FileNotFoundException {
        super(file, append);
        this.file = file;
    }

    /**
     * Devuelve el fichero en el que se va a escribir.
     * 
     * @return
     */
    public File getFile() {
        return this.file;
    }

}
