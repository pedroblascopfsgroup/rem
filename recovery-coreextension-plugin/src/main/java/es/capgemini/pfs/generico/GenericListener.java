package es.capgemini.pfs.generico;

import java.util.Map;

public interface GenericListener {
	
	void fireEvent(Map<String, Object> map);

}
