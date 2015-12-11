package es.capgemini.devon.web.fileupload;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.FwkBusinessOperations;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileManager;
import es.capgemini.devon.files.WebFileItem;

/** 
 * Manager es el encargado de realizar la subida de ficheros
 * Permite una sola subida de ficheros por sesión
 *  
 * @author amarinso
 * @author Nicolás Cornaglia
 *
 */
@Service(FwkBusinessOperations.FILEUPLOAD_SERVICE)
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

    @BusinessOperation(FwkBusinessOperations.FILEUPLOAD_UPLOAD)
    public WebFileItem fileUpload(HttpServletRequest request) {

        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        ProgressInfo pl = new ProgressInfo();

        //tamaño aproximado del fichero == tamaño de la request
        pl.setMaxSize(request.getContentLength());

        //subimos el listener a sesión
        request.getSession().setAttribute(FILE_UPLOAD_LISTENER, pl);
        upload.setProgressListener(pl);

        WebFileItem uploadForm = new WebFileItem();

        try {
            List items = upload.parseRequest(request);
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

    @BusinessOperation(FwkBusinessOperations.FILEUPLOAD_GET_PROGRESS_INFO)
    public ProgressInfo getProgressInfo(HttpServletRequest request) {
        return (ProgressInfo) request.getSession().getAttribute(FILE_UPLOAD_LISTENER);
    }
}
