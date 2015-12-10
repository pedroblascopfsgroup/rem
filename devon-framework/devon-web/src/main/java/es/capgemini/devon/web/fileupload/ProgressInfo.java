package es.capgemini.devon.web.fileupload;

import java.io.Serializable;

import org.apache.commons.fileupload.ProgressListener;
import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/** Esta clase sirve como progessListener del fileUpload. Implementa el método update que se llamará cada vez que el objeto Apache FileUpload notifique que ha leído
 * cierta cantidad de bytes
 * 
 * Además sirve para almacenar la información y que el cliente pueda hacer polling para mostrar el progreso en la web
 * 
 * @author amarinso
 *
 */
public class ProgressInfo implements ProgressListener, Serializable {

    private static final long serialVersionUID = 1L;

    private final Log logger = LogFactory.getLog(getClass());

    private String uploadIdentifier = "";
    private int maxSize = 0;
    private long bytesRead = 0;
    private long contentLength = 0;

    private long megabytes = -1;

    @Override
    public void update(long pBytesRead, long pContentLength, int i) {
        long mBytes = pBytesRead / 1000000;
        if (megabytes == mBytes) {
            return;
        }
        megabytes = mBytes;
        if (logger.isTraceEnabled()) {
            logger.trace("We are currently reading item " + i);
            if (pContentLength == -1) {
                logger.trace("So far, " + pBytesRead + " bytes have been read.");
            } else {
                logger.trace("So far, " + pBytesRead + " of " + pContentLength + " bytes have been read.");
            }
        }

        setBytesRead(pBytesRead);
        setContentLength(pContentLength);
    }

    public void setBytesRead(long bytesRead) {
        this.bytesRead = bytesRead;
    }

    public long getBytesRead() {
        return bytesRead;
    }

    public void setContentLength(long contentLength) {
        this.contentLength = contentLength;
    }

    public long getContentLength() {
        return contentLength;
    }

    public void setUploadIdentifier(String uploadIdentifier) {
        this.uploadIdentifier = uploadIdentifier;
    }

    public String getUploadIdentifier() {
        return uploadIdentifier;
    }

    public void setMaxSize(int maxSize) {
        this.maxSize = maxSize;
    }

    public int getMaxSize() {
        return maxSize;
    }

    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }
}
