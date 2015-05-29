package es.pfsgroup.recovery.plugin.sync;

import java.util.List;

import es.pfsgroup.commons.sync.SyncConnector;
import es.pfsgroup.commons.sync.SyncMsgFactoryBase;
import es.pfsgroup.commons.sync.SyncTranslator;

public class SyncMsgBPMEventFactory extends SyncMsgFactoryBase<SyncMsgBPMEvent> {

	public final static String MSG_FACTORY_ID="00001";
	
	public SyncMsgBPMEventFactory(List<SyncConnector> connectorList, SyncTranslator translator) {
		super(connectorList, translator);
	}

	@Override
	public SyncMsgBPMEvent createMessage() {
		return new SyncMsgBPMEvent();
	}

	@Override
	public String getID() {
		return MSG_FACTORY_ID;
	}

	@Override
	public Class<SyncMsgBPMEvent> getGenericType() {
		return SyncMsgBPMEvent.class;
	}

}
