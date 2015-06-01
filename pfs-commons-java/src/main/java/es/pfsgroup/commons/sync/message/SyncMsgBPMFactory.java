package es.pfsgroup.commons.sync.message;

import java.util.List;

import es.pfsgroup.commons.sync.SyncConnector;
import es.pfsgroup.commons.sync.SyncMsgFactoryBase;
import es.pfsgroup.commons.sync.SyncTranslator;

public class SyncMsgBPMFactory extends SyncMsgFactoryBase<SyncMsgBPM> {

	public final static String MSG_FACTORY_ID="BPM_MSG";
	
	public SyncMsgBPMFactory(List<SyncConnector> connectorList, SyncTranslator translator) {
		super(connectorList, translator);
	}

	@Override
	public SyncMsgBPM createMessage() {
		return new SyncMsgBPM();
	}

	@Override
	public String getID() {
		return MSG_FACTORY_ID;
	}

	@Override
	public Class<SyncMsgBPM> getGenericType() {
		return SyncMsgBPM.class;
	}

}
