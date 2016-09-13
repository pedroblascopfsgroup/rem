package es.pfsgroup.plugin.messagebroker;

public class MessageBrokerUtils {

	public static String lowercaseFirstChar(String string) {
		char c[] = string.toCharArray();
		c[0] = Character.toLowerCase(c[0]);
		String name = new String(c);
		return name;
	}
}
