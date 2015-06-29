package es.capgemini.pfs.integration;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.integration.core.Message;
import org.springframework.integration.file.FileHeaders;

public class ConsumerActionService extends DataContainerPayloadService<AsuntoPayload> {

	private final File logFolder;
	private final File errorFolder;
	
	public ConsumerActionService(ConsumerManager<AsuntoPayload> consumerManager
			, String entidadWorkingCode
			, File logFolder
			, File errorFolder) {
		super(consumerManager, entidadWorkingCode);
		this.logFolder = logFolder;
		this.errorFolder = errorFolder;
		if (!logFolder.exists()) {
			logFolder.mkdirs();
		}
	}

	@Override
	protected void doBeforeDispatch(Message<AsuntoPayload> message) {
		if (checkInErrorFolder(message)) {
			String asuUUID = message.getPayload().getGuidAsunto();
			throw new IntegrationDataException(String.format("[INTEGRACION] ASU [%s] Asunto ya existe en la cola de errores, NO SE PROCESA.", asuUUID));
		}
	}

	@Override
	protected void doAfterCommit(Message<AsuntoPayload> message) {
		if (message.getHeaders().containsKey(FileHeaders.ORIGINAL_FILE)) {
			File file = (File)message.getHeaders().get(FileHeaders.ORIGINAL_FILE);
			if (file.exists()) {
				Date msgDate = new Date(message.getHeaders().getTimestamp());
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
				File folderDest = new File(logFolder, sdf.format(msgDate));
				moveFile(file, folderDest);
			}
		}
	}

	@Override
	protected void doOnError(Message<AsuntoPayload> message) {
		if (message.getHeaders().containsKey(FileHeaders.ORIGINAL_FILE)) {
			File file = (File)message.getHeaders().get(FileHeaders.ORIGINAL_FILE);
			if (file.exists()) {
				String uuidAsunto = message.getPayload().getGuidAsunto();
				File timeDest = new File(errorFolder, uuidAsunto);
				moveFile(file, timeDest);
			}
		}
	}

	private void moveFile(File file, File destFolder) {
		if (file.exists()) {
			if (!destFolder.exists()) {
				destFolder.mkdirs();
			}
			File dest = new File(destFolder, file.getName());
			file.renameTo(dest);
		}
	}

	private boolean checkInErrorFolder(Message<AsuntoPayload> message) {
		String uuidAsunto = message.getPayload().getGuidAsunto();
		File folderDest = new File(errorFolder, uuidAsunto);
		return folderDest.exists();
	}
	
}
