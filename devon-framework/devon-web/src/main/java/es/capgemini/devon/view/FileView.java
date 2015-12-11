package es.capgemini.devon.view;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.view.AbstractView;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.FileManagerImpl;
import es.capgemini.devon.utils.FileUtils;

/**
 * @author Nicolás Cornaglia
 */
public class FileView extends AbstractView {

    /**
     * @param map 
     * @param request   current HTTP request
     * @param response  HTTP response we are building
     */
    @SuppressWarnings("unchecked")
    @Override
    protected void renderMergedOutputModel(Map model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (logger.isDebugEnabled()) {
            logger.debug("Starting rendering of " + this.getBeanName());
        }

        // Get file
        FileItem fileItem = (FileItem) model.get(FileManagerImpl.FILE_ITEM_KEY);

        response.setHeader("Content-disposition", "inline; filename=" + fileItem.getFileName());
        response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
        response.setHeader("Cache-Control", "max-age=0");
        response.setHeader("Expires", "0");
        response.setHeader("Pragma", "public");
        response.setDateHeader("Expires", 0); //prevents caching at the proxy

        response.setContentType(fileItem.getContentType());

        // Write
        FileUtils.copy(fileItem.getInputStream(), response.getOutputStream());

        if (logger.isDebugEnabled()) {
            logger.debug("End rendering of " + this.getBeanName());
        }
    }
}
