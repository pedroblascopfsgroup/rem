package es.pfsgroup.recovery.plugin.sync;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

import es.pfsgroup.commons.sync.SyncConnector;
import es.pfsgroup.commons.sync.SyncFramework;
import es.pfsgroup.commons.sync.SyncMsgConnector;
import es.pfsgroup.commons.sync.SyncMsgFactory;
import es.pfsgroup.commons.sync.SyncTranslator;
import es.pfsgroup.commons.sync.SyncMsgConnector.ConnectorStatus;

public class SyncFrameworkDefaultTest {

	SyncFramework framework;
	
	@Before
	public void prepare() {
		SyncTranslator translatorJSON = new SyncJSONTranslator();
		SyncConnector connectorFolder = new SyncFolderConnector(translatorJSON, "/Documentos/borrar/mensajes");
		SyncConnector connectorFolder2 = new SyncFolderConnector(translatorJSON, "/Documentos/borrar/mensajes2");
		List<SyncConnector> listeners = new ArrayList<SyncConnector>();
		List<SyncConnector> connectorList = new ArrayList<SyncConnector>();
		listeners.add(connectorFolder);
		connectorList.add(connectorFolder);
		connectorList.add(connectorFolder2);
		
		SyncMsgFactory<?> factory = new SyncMsgBPMEventFactory(connectorList, translatorJSON);
		List<SyncMsgFactory<?>> factoryList = new ArrayList<SyncMsgFactory<?>>();
		factoryList.add(factory);
		framework = new SyncDefaultFramework(factoryList, listeners);
	}
	
	@Test
	public void testSendAndListen() {
		@SuppressWarnings("unchecked")
		SyncMsgFactory<SyncMsgBPMEvent> msgFactory = (SyncMsgFactory<SyncMsgBPMEvent>)framework.get(SyncMsgBPMEventFactory.MSG_FACTORY_ID);
		SyncMsgBPMEvent event = msgFactory.createMessage();
		event.setCodAsunto("COD_ASUNTO");
		SyncMsgConnector msgConnector = msgFactory.send(event);
		assertEquals(msgConnector.getSendStatus(), ConnectorStatus.OK);
		framework.listen();
	}
	
}
