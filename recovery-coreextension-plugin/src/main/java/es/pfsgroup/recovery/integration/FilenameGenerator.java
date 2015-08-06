package es.pfsgroup.recovery.integration;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.core.Message;
import org.springframework.integration.file.DefaultFileNameGenerator;

public class FilenameGenerator extends  DefaultFileNameGenerator {
	
	public static final String FILE_TIMESTAMP_FORMAT = "yyyy-MM-dd-HHmmss-SSSSSS";
	
    private final Log logger = LogFactory.getLog(getClass());

	protected String getNewFileName(String originalFileName, Message<?> message) {
		SimpleDateFormat sdf = new SimpleDateFormat(FILE_TIMESTAMP_FORMAT);
		String msgDesc = (message.getHeaders().containsKey(TypePayload.HEADER_MSG_DESC)) 
				? String.format("%s.msg",(String)message.getHeaders().get(TypePayload.HEADER_MSG_DESC))
				: originalFileName;
		String tipo = (message.getHeaders().containsKey(TypePayload.HEADER_MSG_TYPE))
				? (String)message.getHeaders().get(TypePayload.HEADER_MSG_TYPE)
				: "NT";
        String newFileName = String.format("%s.%s.%s",
        		sdf.format(new Date()),
        		tipo,
        		msgDesc);
        return newFileName;
	}

	
	@Override
	public String generateFileName(Message<?> message) {
		
		//File inputFile = (File)message.getPayload();
        String originalFileName = super.generateFileName(message);
        logger.debug(String.format("[INTEGRACION] Renombrando nombre de fichero para mensaje %s", originalFileName));
        
		String newFileName = getNewFileName(originalFileName, message);
        logger.debug(String.format("[INTEGRACION] Nombre de fichero para mensaje %s", newFileName));

        return newFileName;
	}

}
