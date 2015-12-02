package es.pfsgroup.recovery.integration.file;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.core.Message;
import org.springframework.integration.core.MessageHeaders;
import org.springframework.integration.file.FileHeaders;
import org.springframework.integration.message.ErrorMessage;
import org.springframework.integration.message.MessageBuilder;
import org.springframework.integration.message.MessageHandlingException;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.integration.TypePayload;

public class FileIntegrationAdapter {

	private static final String LINE_SEPARATOR = "---\n";
	private static final String FOLDER_BY_DATE = "yyyy/MM/dd";
	private static final String TAG_PAYLOAD = "PAYLOAD";
	private static final String EXTRA_PATH_ERROR = "error";
	private static final String EXTRA_PATH_LOG = "log";

	private final Set<String> validHeaders = new HashSet<String>();
	protected final Log logger = LogFactory.getLog(getClass());

	private final File folder;
	
	public File getFolder() {
		return folder;
	}

	public FileIntegrationAdapter(File folder) throws IOException {
		this.folder = folder;
		if (!checkFolder()) {
			throw new IOException("[INTEGRACION] No se puede utilizar este componente para integación, mal configurado.");
		}
		
		validHeaders.add(MessageHeaders.ID);
		validHeaders.add(MessageHeaders.TIMESTAMP);
		validHeaders.add(TAG_PAYLOAD);
		validHeaders.add(TypePayload.HEADER_MSG_GROUP);
		validHeaders.add(TypePayload.HEADER_MSG_TYPE);
	}

	private boolean checkFolder() {
		if (folder==null) {
			logger.error("[INTEGRACION] No se ha indicado un directorio válido.");
			return false;
		}
		if (!folder.exists()) {
			folder.mkdirs();
		}
		if (!folder.isDirectory()) {
			logger.error("[INTEGRACION] No puedo leer el directorio de entrada, no es un directorio.");
			return false;
		}
		return true;
	}

	private String getHeaderLine(Message<String> message, String key) {
		String value = "";
		if (message.getHeaders().containsKey(key)) {
			logger.info(String.format("[INTEGRACION] writing key: %s value:%s", key, message.getHeaders().get(key)));
			value=String.format("%s:%s\n", key, message.getHeaders().get(key));
		}
		return value;
	}

	private String createTextFile(Message<String> message) {
		StringBuilder sb = new StringBuilder();
		sb.append(getHeaderLine(message, MessageHeaders.ID));
		sb.append(getHeaderLine(message, MessageHeaders.TIMESTAMP));
		sb.append(getHeaderLine(message, TypePayload.HEADER_MSG_ENTIDAD));
		sb.append(getHeaderLine(message, TypePayload.HEADER_MSG_GROUP));
		sb.append("PAYLOAD:").append(message.getPayload()).append("\n");
		return sb.toString();
	}

	private File moveFile(File file, File destFolder) {
		File dest = null;
		if (file.exists()) {
			if (!destFolder.exists()) {
				destFolder.mkdirs();
			}
			dest = new File(destFolder, file.getName());
			file.renameTo(dest);
		}
		return dest;
	}
	
	private void writeFile(File file, String txt) {
		FileWriter fw = null;
		try {
			fw = new FileWriter(file);
			fw.write(txt);
			fw.flush();
		} catch (IOException ioe) {
			logger.error(String.format("[INTEGRACION] No puedo escribir el fichero %s", file.getAbsolutePath()), ioe);
		} finally {
			if (fw!=null)
				try {
					fw.close();
				} catch (IOException e) {
					logger.error("[INTEGRACION] al escribir contenido de fichero", e);
				}
		}
	}

	private boolean isValidKey(String key) {
    	return (!Checks.esNulo(key) && validHeaders.contains(key));
	}
	
	private Map<String,Object> leerValores(String txt) {
		BufferedReader br = null;
		Map<String,Object> mapValues = new HashMap<String, Object>();
		try {
			br = new BufferedReader(new StringReader(txt));
			// Lee líneas
			String line = null;
			while ( (line = br.readLine()) != null ) {
				if (line.equals(LINE_SEPARATOR)) {
					break;
				}
		    	Pattern pattern = Pattern.compile("(.+?):(.+)");
		    	Matcher matcher = pattern.matcher(line);
		    	if (!matcher.matches()) {
		    		continue;
		    	}
		    	String key = matcher.group(1);
		    	String valor = matcher.group(2);
		    	if (!isValidKey(key)) {
		    		continue;
		    	}
		    	if (key.equals(MessageHeaders.TIMESTAMP)) {
		    		Long lvalor = Long.parseLong(valor);
		    		mapValues.put(key, lvalor);	
		    	} else {
		    		mapValues.put(key, valor);	
		    	}
		    }
		} catch (IOException ioe) {
			logger.warn("[INTEGRACION] No se puede leer el contenido.", ioe);
		} catch (Exception e) {
			logger.warn("[INTEGRACION] Problema transformando contenido de fichero.", e);
		} finally {
			if (br!=null) {
				try {
					br.close();
				} catch (IOException e) {
					logger.warn("No se ha podido cerrar el fichero", e);
				}
			}
		}
		return mapValues;
	}

	public Message<String> transformMsg2file(Message<String> message) {
		String text = createTextFile(message);
		Message<String> messageFinal = MessageBuilder
    			.withPayload(text)
    			.copyHeaders(message.getHeaders())
    			.build();
		return messageFinal;
	}
	
	public Message<String> transformFile2msg(Message<String> message) {
		String text = message.getPayload();
		Map<String,Object> headers = leerValores(text);
		String payload = (String)headers.get(TAG_PAYLOAD);
		headers.remove(TAG_PAYLOAD);
		Message<String> newMessage = MessageBuilder
    			.withPayload(payload)
    			.copyHeaders(message.getHeaders())
    			.copyHeaders(headers)
    			.build();
	    //message.getHeaders().put(FileHeaders.ORIGINAL_FILE, file);
		return newMessage;
	}

	public void writeErrorMsg(ErrorMessage mensaje) {
		logger.info("[INTEGRACION] ::Escritura en DIRECTORIO DE ERROR::");
		MessageHandlingException mensajeError = (MessageHandlingException) mensaje.getPayload();
		
		@SuppressWarnings("unchecked")
		Message<String> mensajeOriginal = (Message<String>)mensajeError.getFailedMessage();
		
		File folderDest = this.getFolder();
		folderDest = new File(folderDest, EXTRA_PATH_ERROR);
		folderDest = new File(folderDest, (String)mensajeOriginal.getHeaders().get(TypePayload.HEADER_MSG_GROUP));
		if (!folderDest.exists()) {
			folderDest.mkdirs();
		}
		
		File finalFile = new File(folderDest, String.format("%s.msg", mensajeOriginal.getHeaders().getId()));
		logger.info("[INTEGRACION] Mensaje con ERROR:");
		String content = createTextFile(mensajeOriginal);
		StringBuilder sb = new StringBuilder();
		sb.append(content)
			.append(LINE_SEPARATOR);
		if (mensajeError.getCause()!=null) {
			sb.append("CAUSA\n")
			.append(mensajeError.getCause().getMessage()).append("\n")
			.append(mensajeError.getCause().getStackTrace()).append("\n");
		}
		sb.append("\n")
			.append(mensajeError.getMessage()).append("\n")
			.append(mensajeError.getStackTrace()).append("\n");
		logger.info("[INTEGRACION] Fichero: " + finalFile.getAbsolutePath());
		writeFile(finalFile, sb.toString());
			
		// Elimina el mensaje original
		if (mensajeOriginal.getHeaders().containsKey(FileHeaders.ORIGINAL_FILE)) {
			File originalFile = (File)mensajeOriginal.getHeaders().get(FileHeaders.ORIGINAL_FILE);
			if (originalFile.exists()) originalFile.delete();
		}
	}

	public void moveFileWithErrors(ErrorMessage mensaje) {
		logger.info("[INTEGRACION] ::Movemos a DIRECTORIO DE ERROR::");
		
		MessageHandlingException mensajeError = (MessageHandlingException) mensaje.getPayload();

		Message<?> mensajeOriginal = mensajeError.getFailedMessage();
		if (!mensajeOriginal.getHeaders().containsKey(FileHeaders.ORIGINAL_FILE)) {
			logger.error("[INTEGRACION] No se puede mover un fichero que no se ha leído previamente en la cadena.");
			return;
		}
		File originalFile = (File)mensajeOriginal.getHeaders().get(FileHeaders.ORIGINAL_FILE);
		if (originalFile!=null && !originalFile.exists()) {
			logger.error("[INTEGRACION] El fichero original no existe o se ha borrado.");
			return;
		}

		StringBuilder sb = new StringBuilder();
		logger.info("[INTEGRACION] Mensaje con ERROR:");
		logger.info(sb);
		
		sb.append(LINE_SEPARATOR);
		if (mensajeError.getCause()!=null) {
			sb.append("CAUSA\n")
			.append(mensajeError.getCause().getMessage()).append("\n")
			.append(mensajeError.getCause().getStackTrace()).append("\n");
		}
		sb.append("\n")
			.append(mensajeError.getMessage())
			.append(mensajeError.getStackTrace());
		
		File folderDest = this.getFolder();
		folderDest = new File(folderDest, EXTRA_PATH_ERROR);
		folderDest = new File(folderDest, (String)mensajeOriginal.getHeaders().get(TypePayload.HEADER_MSG_GROUP));
		File destFile = moveFile(originalFile, folderDest);
		try {
		    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(destFile, true)));
		    out.println(sb.toString());
		    out.close();
		} catch (IOException e) {
		    logger.error("[INTEGRACION] No se ha podido modificar el fichero para añadirle la excepción", e);
		} finally  {
			logger.info("[INTEGRACION] Fichero: " + destFile.getAbsolutePath());
		}

	}

	public void moveFileCompleted(Message<?> mensaje) {
		logger.info("[INTEGRACION] ::Movemos mensaje a directorio de LOG::");
		if (!mensaje.getHeaders().containsKey(FileHeaders.ORIGINAL_FILE)) {
			logger.error("[INTEGRACION] No se puede mover un fichero que no se ha leído previamente en la cadena.");
			return;
		}
		File originalFile = (File)mensaje.getHeaders().get(FileHeaders.ORIGINAL_FILE);
		if (originalFile!=null && !originalFile.exists()) {
			logger.error("[INTEGRACION] El fichero original no existe o se ha borrado.");
			return;
		}
		
		SimpleDateFormat dateFormat = new SimpleDateFormat(FOLDER_BY_DATE);
		Date msgDate = new Date(mensaje.getHeaders().getTimestamp());
		File folderDest = this.getFolder();
		folderDest = new File(folderDest, EXTRA_PATH_LOG);
		folderDest = new File(folderDest, dateFormat.format(msgDate));
		moveFile(originalFile, folderDest);
		logger.info("[INTEGRACION] Fichero: " + folderDest.getAbsolutePath());
		
	}

	public void writeLogMsgStr(Message<String> mensaje) {
		logger.info("[INTEGRACION] ::Escritura en DIRECTORIO DE LOG_1::");
		if (!checkFolder()) {
			return;
		}

		SimpleDateFormat dateFormat = new SimpleDateFormat(FOLDER_BY_DATE);
		Date msgDate = new Date(mensaje.getHeaders().getTimestamp());
		
		File folderDest = this.getFolder();
		folderDest = new File(folderDest, EXTRA_PATH_LOG);
		folderDest = new File(folderDest, dateFormat.format(msgDate));
		if (!folderDest.exists()) {
			folderDest.mkdirs();
		}

		File finalFile = new File(folderDest, String.format("%s.msg", mensaje.getHeaders().getId()));
		logger.info("[INTEGRACION] Mensaje:");
		String content = createTextFile(mensaje);
		logger.info("[INTEGRACION] Fichero: " + finalFile.getAbsolutePath());
		writeFile(finalFile, content);
		//}
			
		// Elimina el mensaje original
		if (mensaje.getHeaders().containsKey(FileHeaders.ORIGINAL_FILE)) {
			File originalFile = (File)mensaje.getHeaders().get(FileHeaders.ORIGINAL_FILE);
			originalFile.delete();
		}
	}

	public void writeMsgStr(Message<String> mensaje) {
		logger.info("[INTEGRACION] ::Escritura en DIRECTORIO DE LOG_2::");
		if (!checkFolder()) {
			return;
		}

		File folderDest = this.getFolder();
		if (!folderDest.exists()) {
			folderDest.mkdirs();
		}
		
		File finalFile = new File(folderDest, String.format("%s.msg", mensaje.getHeaders().getId()));
		logger.info("[INTEGRACION] Mensaje:");
		String content = createTextFile(mensaje);
		logger.info("[INTEGRACION] Fichero: " + finalFile.getAbsolutePath());
		writeFile(finalFile, content);
			
		// Elimina el mensaje original
		if (mensaje.getHeaders().containsKey(FileHeaders.ORIGINAL_FILE)) {
			File originalFile = (File)mensaje.getHeaders().get(FileHeaders.ORIGINAL_FILE);
			originalFile.delete();
		}
		
	}
	
	public Message<?> checkExistErrorFolder(Message<?> message) {
		if (!message.getHeaders().containsKey(TypePayload.HEADER_MSG_GROUP)) {
			logger.warn("[INTEGRACION] No puedo comprobar porque el mensaje no tiene grupo, no se filtra.");
			return message;
		}
		String groupID = (String)message.getHeaders().get(TypePayload.HEADER_MSG_GROUP);
		File folder = new File(this.folder, EXTRA_PATH_ERROR);
		folder = new File(folder, groupID);
		if (folder.exists()) {
			throw new MessageHandlingException(message, String.format("El mensaje del grupo %s se ha bloqueado por errores previos", groupID));
		}
		return message;
	}
	
}
