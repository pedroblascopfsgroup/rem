package es.pfsgroup.framework.paradise.fileUpload.adapter;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

@Service
public class UploadAdapter {

	@Autowired
	private GenericABMDao genericDao;	
	@Resource
	Properties appProperties;
	
	public WebFileItem getWebFileItem (HttpServletRequest request) {
		WebFileItem webFileItem = new WebFileItem();
		List<WebFileItem> webFileItemList = getWebMultipleFileItem(request);
		if (webFileItemList != null && !webFileItemList.isEmpty())
			webFileItem = webFileItemList.get(0);
		
		return webFileItem;
	}
	
	@SuppressWarnings("rawtypes")
	public List<WebFileItem> getWebMultipleFileItem (HttpServletRequest request) {
		Boolean crear = true;
		
		List<WebFileItem> webFileItemList = new ArrayList<WebFileItem>();
		MultipartRequest multipartRequest = (MultipartRequest) request;
		Iterator it = multipartRequest.getFileNames();
		
		while (it.hasNext()) {
			MultipartFile multipartFile = multipartRequest.getFile(it.next().toString());
		    WebFileItem webFileItem = new WebFileItem();
		    FileItem fileItem = null;
			File file;		
			
			try {
				
				String rutaFichero = appProperties.getProperty("files.temporaryPath","/tmp")+"/"; 
				if(!Checks.esNulo(multipartFile) && !Checks.esNulo(multipartFile.getOriginalFilename())) {
					file = new File(rutaFichero+multipartFile.getOriginalFilename());
					file.createNewFile(); 
				    FileOutputStream fos = new FileOutputStream(file); 
				    fos.write(multipartFile.getBytes());
				    fos.close();
				
					fileItem = new FileItem(file); 
					fileItem.setContentType(multipartFile.getContentType());
					fileItem.setLength(multipartFile.getSize());
					String fileName = new String(multipartFile.getOriginalFilename().getBytes("ISO-8859-15"), "UTF-8");
					fileItem.setFileName(fileName);
					
					Enumeration<?> parameters = request.getParameterNames();		
					
					while (parameters.hasMoreElements()) {			
						String key = (String) parameters.nextElement();
			
						webFileItem.putParameter(key, new String(request.getParameter(key).getBytes("ISO-8859-15"), "UTF-8"));
					}
				}else {
					crear = false;
				}
			} catch (Exception e) {
				throw new BusinessOperationException(e);
			}
			
			if(crear) {
				webFileItem.setFileItem(fileItem);
				webFileItemList.add(webFileItem);
			}
		}
		
		return webFileItemList;		
	}
	
	public Adjunto saveBLOB (FileItem fileItem) throws Exception {
		
		Adjunto adj = new Adjunto();
		adj.setFileItem(fileItem);
		genericDao.save(Adjunto.class, adj);

		//'adj' son las datos binarios que forman el fichero, mas el identificador de la tabla donde se ha guardado
		return adj;

	}
	
	public FileItem findOneBLOB (Long id) throws Exception {
		
		Adjunto adj = genericDao.get(Adjunto.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		return adj.getFileItem();

	}
	
	

	
}