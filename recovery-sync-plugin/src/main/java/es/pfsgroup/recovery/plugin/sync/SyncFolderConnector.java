package es.pfsgroup.recovery.plugin.sync;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.sync.SyncConnector;
import es.pfsgroup.commons.sync.SyncMsgConnector;
import es.pfsgroup.commons.sync.SyncTranslator;
import es.pfsgroup.commons.sync.SyncMsgConnector.ConnectorStatus;

public class SyncFolderConnector implements SyncConnector {

	private static final String FILE_ENCODING = "UTF-8";
	private static final String FILE_TIMESTAMP_FORMAT = "yyyymmdd-HHmmss.SSSSSS'.rex'";
	private final SyncTranslator translator;
	private final String path;
	
	public SyncFolderConnector(SyncTranslator translator, String path) {
		this.translator = translator;
		this.path = path;
	}

	@Override
	public void send(SyncMsgConnector message) {
		List<SyncMsgConnector> messageList = new ArrayList<SyncMsgConnector>();
		messageList.add(message);
		send(messageList);
	}

	private void writeToFile(File file, String message) throws IOException, Exception {
		BufferedWriter bufferedWriter = null;
		try {
            FileOutputStream outputStream = new FileOutputStream(file);
            OutputStreamWriter outputStreamWriter = new OutputStreamWriter(outputStream, FILE_ENCODING);
            bufferedWriter = new BufferedWriter(outputStreamWriter);
            bufferedWriter.write(message);
            bufferedWriter.close();
        } catch (IOException e) {
            throw e;
        } finally {
        	if (bufferedWriter!=null) {
        		try {
        			bufferedWriter.close();
        		} catch (Exception ex) { 
        			throw ex;
        		}
        	}
        }
	}
	
	@Override
	public void send(List<SyncMsgConnector> messageList) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(FILE_TIMESTAMP_FORMAT);
		for (SyncMsgConnector message : messageList) {
			String fileName = simpleDateFormat.format(message.getSendDate());
			File baseDirectory = new File(path);
			File file = new File(baseDirectory, fileName);
			
			
			// Serializa el fichero
			String messageToSend = translator.serialize(message);
			
			// Escribe el contenido
			try {
				writeToFile(file, messageToSend);
				message.setSendStatus(ConnectorStatus.OK);
			} catch (IOException ioexception) {
				ioexception.printStackTrace();
				message.setSendStatus(ConnectorStatus.KO);
			} catch (Exception ex) {
				ex.printStackTrace();
				message.setSendStatus(ConnectorStatus.KO);
			}
		}
	}

	
	
	private String readFileContent(File file) throws IOException, Exception {
		StringBuilder sb = new StringBuilder();
		Reader inputStreamReader = null;
        try {
            FileInputStream inputStream = new FileInputStream(file);
            inputStreamReader = new InputStreamReader(inputStream, FILE_ENCODING);
            char buffer[] = new char[255];
            while (inputStreamReader.read(buffer, 0, buffer.length)>0) {
            	sb.append(buffer);
            }
        } catch (IOException e) {
            throw e;
        } finally {
        	if (inputStreamReader!=null) {
        		try {
        			inputStreamReader.close();
        		} catch (Exception ex) { 
        			throw ex;
        		}
        	}
        }
        return sb.toString();
	}
	
	private File[] getFilesInFolder() {
		File dir = new File(path);
		File[] files = dir.listFiles(new FilenameFilter() {
			@Override
			public boolean accept(File dir, String name) {
				return name.matches(".*\\.rex");
			}
		});
		return files;
	}
	
	public void deleteFile(File file) {
		file.delete();
	}
	
	@Override
	public List<SyncMsgConnector> receive() {
		File[] fileList = getFilesInFolder();
		List<SyncMsgConnector> messageList = new ArrayList<SyncMsgConnector>();
		for (File file : fileList) {
			try {
				String messageContent = readFileContent(file);
				SyncMsgConnector message = (SyncMsgConnector)translator.deserialize(messageContent, SyncMsgConnector.class);
				messageList.add(message);
				deleteFile(file);
			} catch (IOException ioexception) {
				ioexception.printStackTrace();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return messageList;
	}
	
	
}
