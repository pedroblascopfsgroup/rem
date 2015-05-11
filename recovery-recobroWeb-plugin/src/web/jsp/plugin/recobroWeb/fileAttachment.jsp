<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" import="es.capgemini.devon.files.*,es.capgemini.devon.utils.*"%><%
FileItem fileItem = (FileItem) pageContext.findAttribute("fileItem");
 if (fileItem!=null) {
	 
	try { 
		ServletOutputStream salida = response.getOutputStream(); 
			
		response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
		response.setHeader("Cache-Control", "max-age=0");
		response.setHeader("Expires", "0");
		response.setHeader("Pragma", "public");
		response.setDateHeader("Expires", 0); //prevents caching at the proxy
		response.setContentType(fileItem.getContentType());
		
		// Write
		FileUtils.copy(fileItem.getInputStream(), salida);
		salida.flush();
		salida.close();
	} catch (Exception e) { 
		
	}
 }
%>