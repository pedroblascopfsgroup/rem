package es.pfgroup.monioring.bach.load.persistence.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class CheckStatusFileStreamBuilder {

    public FileInputStream createFileInputStream(final File file) throws IOException {
        if (! file.exists()){
            file.createNewFile();
        }
        return new FileInputStream(file);
    }

}
