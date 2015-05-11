package es.pfsgroup.plugin.recovery.nuevoModeloBienes;

import java.io.Serializable;
import java.util.List;

/**
 * Contiene los tabs de un único tipo de bien que se carga mediante fichero de configuración xml
 * @author carlos
 *
 */
public class NMBconfigTabsTipoBien implements Serializable{

	private static final long serialVersionUID = 763861835536268515L;

	private List<String> listaTabs;

	public List<String> getListaTabs() {
		return listaTabs;
	}

	public void setListaTabs(List<String> listaTabs) {
		this.listaTabs = listaTabs;
	}

}
