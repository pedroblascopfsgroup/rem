package es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * <p>
 * Java class for anonymous complex type.
 * 
 * <p>
 * The following schema fragment specifies the expected content contained within
 * this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;all>
 *         &lt;element name="ID_ACTIVO_ORIGEN" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="ID_ORIGEN" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="ID_ACTIVO_HAYA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *       &lt;/all>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {

})
@XmlRootElement(name = "INPUT")
public class INPUT {

	@XmlElement(name = "ID_ACTIVO_ORIGEN", required = true)
	protected String idActivoOrigen;
	@XmlElement(name = "ID_ORIGEN", required = true)
	protected String idOrigen;
	@XmlElement(name = "ID_ACTIVO_HAYA", required = true)
	protected String idActivoHaya;

	public String getIdActivoOrigen() {
		return idActivoOrigen;
	}

	public void setIdActivoOrigen(String idActivoOrigen) {
		this.idActivoOrigen = idActivoOrigen;
	}

	public String getIdOrigen() {
		return idOrigen;
	}

	public void setIdOrigen(String idOrigen) {
		this.idOrigen = idOrigen;
	}

	public String getIdActivoHaya() {
		return idActivoHaya;
	}

	public void setIdActivoHaya(String idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}

}
