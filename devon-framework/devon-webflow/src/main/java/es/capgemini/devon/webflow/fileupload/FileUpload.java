package es.capgemini.devon.webflow.fileupload;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.webflow.context.ExternalContext;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.FwkBusinessOperations;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileManager;
import es.capgemini.devon.files.WebFileItem;

/** Este manager es el encargado de realizar la subida de ficheros
 * 
 * sólo se va a permitir una subida de ficheros por sesión, 
 * @author amarinso
 *
 */
@Service(value = FwkBusinessOperations.FILEUPLOAD_SERVICE + "_", overrides = FwkBusinessOperations.FILEUPLOAD_SERVICE)
public class FileUpload {

    /** el nombre del objeto en sesión
    * 
    */
    public static final String FILE_UPLOAD_LISTENER = "fileUploadListener";

    protected static final Log logger = LogFactory.getLog(FileUpload.class);

    @Autowired
    private FileManager fileManager;

    public FileManager getFileManager() {
        return fileManager;
    }

    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }

    private HttpServletRequest getRequest(ExternalContext context) {
        return (HttpServletRequest) context.getNativeRequest();
    }

    private HttpSession getSession(ExternalContext context) {
        return getRequest(context).getSession();
    }

    @BusinessOperation(value = FwkBusinessOperations.FILEUPLOAD_UPLOAD)
    public WebFileItem fileUpload(ExternalContext context) {

        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        ProgressInfo pl = new ProgressInfo();

        //tamaño aproximado del fichero == tamaño de la request
        pl.setMaxSize(getRequest(context).getContentLength());

        //subimos el listener a sesión
        getSession(context).setAttribute(FILE_UPLOAD_LISTENER, pl);
        upload.setProgressListener(pl);

        WebFileItem uploadForm = new WebFileItem();

        try {
            List items = upload.parseRequest(getRequest(context));
            org.apache.commons.fileupload.FileItem fileToUpload = null;
            int maxSize = -1;
            for (Object o : items) {
                org.apache.commons.fileupload.FileItem fit = (org.apache.commons.fileupload.FileItem) o;
                if (fit.isFormField()) {
                    if (logger.isDebugEnabled()) {
                        logger.debug("fileUpload field name=" + fit.getFieldName() + " value=" + fit.getString());
                    }

                    uploadForm.putParameter(fit.getFieldName(), fit.getString());

                    //aquí viene la info del tramaño máximo, se la pasamos al progress listener
                    if ("MAX_FILE_SIZE".equals(fit.getFieldName())) {
                        maxSize = Integer.parseInt(fit.getString());
                        pl.setMaxSize(maxSize);
                    }

                    //aquí viene la info del identificador del upload, se la pasamos al progress listener
                    if ("UPLOAD_IDENTIFIER".equals(fit.getFieldName())) {
                        String uploadIdentifier = fit.getString();
                        pl.setUploadIdentifier(uploadIdentifier);
                    }

                } else {
                    if (logger.isDebugEnabled()) {
                        logger.debug("fileUpload is File fileName=" + fit.getName() + " content-type=" + fit.getContentType() + " size="
                                + fit.getSize());
                    }

                    fileToUpload = fit;

                }
            }

            if (fileToUpload != null) {
                es.capgemini.devon.files.FileItem fi = fileManager.createTemporaryFileItem();
                fi.setFileName(fileToUpload.getName());
                fi.setContentType(fileToUpload.getContentType());
                fi.setLength(fileToUpload.getSize());
                try {
                    fileToUpload.write(fi.getFile());
                    uploadForm.setFileItem(fi);
                    return uploadForm;

                } catch (Exception e) {
                    logger.error(e);
                    throw new FileUploadException(e, "fileupload.error", fi.getFileName());
                }
            }

        } catch (org.apache.commons.fileupload.FileUploadException e) {
            logger.error(e);
            throw new FileUploadException(e, "fileupload.error");
        }

        return null;

    }

    @BusinessOperation(value = FwkBusinessOperations.FILEUPLOAD_GET_PROGRESS_INFO)
    public ProgressInfo getProgressInfo(ExternalContext context) {
        return (ProgressInfo) getSession(context).getAttribute(FILE_UPLOAD_LISTENER);
    }
}
