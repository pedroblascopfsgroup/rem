package es.pfsgroup.plugin.messagebroker.integration;

public class EmptyPayload {
	private static final EmptyPayload instance = new EmptyPayload();

	public static boolean checkEquals(Object payload) {
		return instance.equals(payload);
	}
	
	public static EmptyPayload getInstance(){
		return instance;
	}

	@Override
	public boolean equals(Object obj) {
		return (obj != null) && (obj instanceof EmptyPayload);
	}
}
