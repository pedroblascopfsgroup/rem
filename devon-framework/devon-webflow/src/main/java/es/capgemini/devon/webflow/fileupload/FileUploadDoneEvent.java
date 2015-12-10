package es.capgemini.devon.webflow.fileupload;

import es.capgemini.devon.events.GenericEvent;

/** Este evento notifica la finalización de una operación de upload
 * @author amarinso
 *
 */
public class FileUploadDoneEvent extends GenericEvent {
    private static final long serialVersionUID = 1L;

    private String fileName;

    public static String EXCEPTION_KEY = "exception";

    public FileUploadDoneEvent(String fileName) {
        this.setFileName(fileName);
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileName() {
        return fileName;
    }

}