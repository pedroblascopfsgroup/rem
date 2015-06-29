package es.pfsgroup.recovery.integration;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.integration.core.Message;
import org.springframework.integration.file.FileHeaders;

import es.pfsgroup.recovery.integration.bpm.AsuntoPayload;

public class ConsumerActionService extends DataContainerPayloadService<DataContainerPayload> {

	private final File logFolder;
	private final File errorFolder;
	
	public ConsumerActionService(ConsumerManager<DataContainerPayload> consumerManager
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
	protected void doBeforeDispatch(Message<DataContainerPayload> message) {
		AsuntoPayload asuntoPayload = new AsuntoPayload(message.getPayload());
		if (checkInErrorFolder(message)) {
			String asuUUID = asuntoPayload.getGuid();
			throw new IntegrationDataException(String.format("[INTEGRACION] ASU [%s] Asunto ya existe en la cola de errores, NO SE PROCESA.", asuUUID));
		}
	}

	@Override
	protected void doAfterCommit(Message<DataContainerPayload> message) {
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
	protected void doOnError(Message<DataContainerPayload> message) {
		AsuntoPayload asuntoPayload = new AsuntoPayload(message.getPayload());
		if (message.getHeaders().containsKey(FileHeaders.ORIGINAL_FILE)) {
			File file = (File)message.getHeaders().get(FileHeaders.ORIGINAL_FILE);
			if (file.exists()) {
				String uuidAsunto = asuntoPayload.getGuid();
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

	private boolean checkInErrorFolder(Message<DataContainerPayload> message) {
		AsuntoPayload asuntoPayload = new AsuntoPayload(message.getPayload());
		String uuidAsunto = asuntoPayload.getGuid();
		File folderDest = new File(errorFolder, uuidAsunto);
		return folderDest.exists();
	}
	
}
