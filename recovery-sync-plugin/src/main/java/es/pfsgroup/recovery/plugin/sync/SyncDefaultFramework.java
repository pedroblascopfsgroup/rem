package es.pfsgroup.recovery.plugin.sync;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.pfsgroup.commons.sync.SyncConnector;
import es.pfsgroup.commons.sync.SyncFramework;
import es.pfsgroup.commons.sync.SyncMsgConnector;
import es.pfsgroup.commons.sync.SyncMsgFactory;

public class SyncDefaultFramework implements SyncFramework {

	private final List<SyncConnector> listenerList;
	private final Map<String, SyncMsgFactory<?>> messageMap;
	
	public SyncDefaultFramework(List<SyncMsgFactory<?>> msgFactoryList, List<SyncConnector> listenerList) {
		this.listenerList = listenerList;
		messageMap = new HashMap<String, SyncMsgFactory<?>>();
		for (SyncMsgFactory<?> factory : msgFactoryList) {
			messageMap.put(factory.getID(), factory);
		}
	}
	
	public SyncMsgFactory<?> get(String key) {
		return messageMap.get(key);
	}
	
	@SuppressWarnings("unused")
	public void listen() {
		for (SyncConnector connector : listenerList) {
			List<SyncMsgConnector> messageList = connector.receive();
			for (SyncMsgConnector message : messageList) {
				SyncMsgFactory<?> factory = this.get(message.getId());
				factory.processMessage(message);
			}
		}
	}
	
}
