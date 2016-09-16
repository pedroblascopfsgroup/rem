package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.ArrayList;
import java.util.Map;

public class ParamsList extends ArrayList<Map<String, Object>> {

	private static final long serialVersionUID = -3288885651078895102L;

	@Override
	public String toString() {
		if (this.size() <= 3) {
			return super.toString();
		} else {
			return "[... más de 3 elementos ...]";
		}
	}

}
