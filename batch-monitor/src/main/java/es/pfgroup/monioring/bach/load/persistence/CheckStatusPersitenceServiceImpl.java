package es.pfgroup.monioring.bach.load.persistence;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import es.pfgroup.monioring.bach.load.persistence.utils.CheckStatusFileStreamBuilder;
import es.pfgroup.monioring.bach.load.persistence.utils.ExtendedFileOutputStream;

public class CheckStatusPersitenceServiceImpl implements CheckStatusPersitenceService {

    public static final String DATE_TIME_FORMAT = "dd/MM/yyyy HH:mm";

    public static final String CHECK_STATUS_TIME_PROPERTY = "last.checkstatus.datetime";

    private final CheckStatusPersitentFile persistFile;

    private final CheckStatusFileStreamBuilder fsbuilder;

    public CheckStatusPersitenceServiceImpl(final CheckStatusPersitentFile fileWrapper, CheckStatusFileStreamBuilder fileStreamBuilder) {
        this.persistFile = fileWrapper;
        this.fsbuilder = fileStreamBuilder;
    }

    @Override
    public void saveCheckStatusTime(final Integer entity, final String jobName) {
        Properties p = persistFile.getProperties();
        File f = persistFile.getFile();

        try {
            ExtendedFileOutputStream fos = new ExtendedFileOutputStream(f, false);
            p.setProperty(jobName + "." + entity + "." + CHECK_STATUS_TIME_PROPERTY, new SimpleDateFormat(DATE_TIME_FORMAT).format(new Date()));
            p.store(fos, "Batch Monitor");
        } catch (FileNotFoundException e) {
            // FIXME Gestionar la excepci�n
            e.printStackTrace();
        } catch (IOException e) {
            // FIXME Gestionar la excepci�n
            e.printStackTrace();
        }
    }

    @Override
    public Date getLastCheckStatusTimeOrNull(final Integer entity, final String jobName) {
        Properties p = persistFile.getProperties();
        File f = persistFile.getFile();
        try {
            FileInputStream fis = fsbuilder.createFileInputStream(f);
            p.load(fis);
            String date = p.getProperty(jobName + "." + entity + "." + CHECK_STATUS_TIME_PROPERTY);
            if ((date != null) && (!"".equals(date))) {
                return new SimpleDateFormat(DATE_TIME_FORMAT).parse(date);
            } else {
                return null;
            }
        } catch (FileNotFoundException e) {
            // FIXME Gestionar la excepción
            e.printStackTrace();
            return null;
        } catch (IOException e) {
            // FIXME Gestionar la excepción
            e.printStackTrace();
            return null;
        } catch (ParseException e) {
            // FIXME Gestionar la excepción
            e.printStackTrace();
            return null;
        }
    }

}
