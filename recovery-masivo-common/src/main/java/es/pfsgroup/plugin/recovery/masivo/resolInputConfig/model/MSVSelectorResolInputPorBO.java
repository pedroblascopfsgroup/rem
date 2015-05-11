package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model;

import java.io.Serializable;
import java.util.List;

/**
 * Clase que contiene la función de negocio que calculará el tipo de Input
 * correspondiente a un tipo de resolución, junto con la lista de posibles tipos
 * de input
 * 
 * @author pedro
 *
 */
public class MSVSelectorResolInputPorBO implements Serializable {

	private static final long serialVersionUID = -8544347128336052561L;

	private String nombreBO;
	
	private List<String> listaCodigosInput;

	public String getNombreBO() {
		return nombreBO;
	}

	public void setNombreBO(String nombreBO) {
		this.nombreBO = nombreBO;
	}

	public List<String> getListaCodigosInput() {
		return listaCodigosInput;
	}

	public void setListaCodigosInput(List<String> listaCodigosInput) {
		this.listaCodigosInput = listaCodigosInput;
	}
	
}
