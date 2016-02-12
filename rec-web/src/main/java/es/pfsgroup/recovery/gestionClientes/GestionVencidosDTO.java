package es.pfsgroup.recovery.gestionClientes;

import java.io.Serializable;
import java.math.BigDecimal;

import es.capgemini.devon.dto.WebDto;

public class GestionVencidosDTO extends WebDto implements Serializable {
	
	private static final long serialVersionUID = 1L;
	private BigDecimal id;
	private String descripcion;
	private String nombre;
	private String apellido1;
	private String apellido2;
	private BigDecimal codClienteEntidad;
	private String docId;
	private String telefono1;
	private String descripcionSegmento;
	private String descripcionSegmentoEntidad;
	private BigDecimal numContratos;
	private BigDecimal deudaIrregular;
	private BigDecimal riesgoDirectoDanyado;
	private String descripcionEstadoFinanciero;
	private BigDecimal riesgoAutorizado;
	private BigDecimal riesgoDispuesto;
	
	/**
	 * @return the id
	 */
	public BigDecimal getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(BigDecimal id) {
		this.id = id;
	}

	/**
	 * @return the descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}

	/**
	 * @param descripcion the descripcion to set
	 */
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	/**
	 * @return the nombre
	 */
	public String getNombre() {
		return nombre;
	}

	/**
	 * @param nombre the nombre to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	/**
	 * @return the apellido1
	 */
	public String getApellido1() {
		return apellido1;
	}

	/**
	 * @param apellido1 the apellido1 to set
	 */
	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}

	/**
	 * @return the apellido2
	 */
	public String getApellido2() {
		return apellido2;
	}

	/**
	 * @param apellido2 the apellido2 to set
	 */
	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}

	/**
	 * @return the codClienteEntidad
	 */
	public BigDecimal getCodClienteEntidad() {
		return codClienteEntidad;
	}

	/**
	 * @param codClienteEntidad the codClienteEntidad to set
	 */
	public void setCodClienteEntidad(BigDecimal codClienteEntidad) {
		this.codClienteEntidad = codClienteEntidad;
	}

	/**
	 * @return the docId
	 */
	public String getDocId() {
		return docId;
	}

	/**
	 * @param docId the docId to set
	 */
	public void setDocId(String docId) {
		this.docId = docId;
	}

	/**
	 * @return the telefono1
	 */
	public String getTelefono1() {
		return telefono1;
	}

	/**
	 * @param telefono1 the telefono1 to set
	 */
	public void setTelefono1(String telefono1) {
		this.telefono1 = telefono1;
	}

	/**
	 * @return the descripcionSegmento
	 */
	public String getDescripcionSegmento() {
		return descripcionSegmento;
	}

	/**
	 * @param descripcionSegmento the descripcionSegmento to set
	 */
	public void setDescripcionSegmento(String descripcionSegmento) {
		this.descripcionSegmento = descripcionSegmento;
	}

	/**
	 * @return the descripcionSegmentoEntidad
	 */
	public String getDescripcionSegmentoEntidad() {
		return descripcionSegmentoEntidad;
	}

	/**
	 * @param descripcionSegmentoEntidad the descripcionSegmentoEntidad to set
	 */
	public void setDescripcionSegmentoEntidad(String descripcionSegmentoEntidad) {
		this.descripcionSegmentoEntidad = descripcionSegmentoEntidad;
	}

	/**
	 * @return the numContratos
	 */
	public BigDecimal getNumContratos() {
		return numContratos;
	}

	/**
	 * @param numContratos the numContratos to set
	 */
	public void setNumContratos(BigDecimal numContratos) {
		this.numContratos = numContratos;
	}

	/**
	 * @return the deudaIrregular
	 */
	public BigDecimal getDeudaIrregular() {
		return deudaIrregular;
	}

	/**
	 * @param deudaIrregular the deudaIrregular to set
	 */
	public void setDeudaIrregular(BigDecimal deudaIrregular) {
		this.deudaIrregular = deudaIrregular;
	}
	
	/**
	 * obtiene el apellido y el nombre.
	 * 
	 * @return apellido nombre
	 */
	public String getApellidoNombre() {
		String r = "";
		if (apellido1 != null && apellido1.trim().length() > 0) {
			r += apellido1.trim() + " ";
		}
		if (apellido2 != null && apellido2.trim().length() > 0) {
			r += apellido2.trim();
		}
		if (r.trim().length() > 0) {
			r += ", ";
		}
		if (nombre != null && nombre.trim().length() > 0) {
			r += nombre.trim();
		}
		return r;
	}

	/**
	 * @return the riesgoDirectoDanyado
	 */
	public BigDecimal getRiesgoDirectoDanyado() {
		return riesgoDirectoDanyado;
	}

	/**
	 * @param riesgoDirectoDanyado the riesgoDirectoDanyado to set
	 */
	public void setRiesgoDirectoDanyado(BigDecimal riesgoDirectoDanyado) {
		this.riesgoDirectoDanyado = riesgoDirectoDanyado;
	}

	/**
	 * @return the descripcionEstadoFinanciero
	 */
	public String getDescripcionEstadoFinanciero() {
		return descripcionEstadoFinanciero;
	}

	/**
	 * @param descripcionEstadoFinanciero the descripcionEstadoFinanciero to set
	 */
	public void setDescripcionEstadoFinanciero(
			String descripcionEstadoFinanciero) {
		this.descripcionEstadoFinanciero = descripcionEstadoFinanciero;
	}

	/**
	 * @return the riesgoAutorizado
	 */
	public BigDecimal getRiesgoAutorizado() {
		return riesgoAutorizado;
	}

	/**
	 * @param riesgoAutorizado the riesgoAutorizado to set
	 */
	public void setRiesgoAutorizado(BigDecimal riesgoAutorizado) {
		this.riesgoAutorizado = riesgoAutorizado;
	}

	/**
	 * @return the riesgoDispuesto
	 */
	public BigDecimal getRiesgoDispuesto() {
		return riesgoDispuesto;
	}

	/**
	 * @param riesgoDispuesto the riesgoDispuesto to set
	 */
	public void setRiesgoDispuesto(BigDecimal riesgoDispuesto) {
		this.riesgoDispuesto = riesgoDispuesto;
	}

	/**
	 * @return the persona
	 */
	/*public Persona getPersona() {
		return persona;
	}*/
	
	/**
	 * @param persona the persona to set
	 */
/*	public void setPersona(Persona persona) {
		this.persona = persona;
	}*/

	/**
	 * @return the riesgoTotal
	 */
	/*public Double getRiesgoTotal() {
		return riesgoTotal;
	}*/

	/**
	 * @param riesgoTotal the riesgoTotal to set
	 */
	/*public void setRiesgoTotal(Double riesgoTotal) {
		this.riesgoTotal = riesgoTotal;
	}*/

	/**
	 * @return the diasVencidos
	 */
	/*public Integer getDiasVencidos() {
		return diasVencidos;
	}
*/
	/**
	 * @param diasVencidos the diasVencidos to set
	 */
	/*public void setDiasVencidos(Integer diasVencidos) {
		this.diasVencidos = diasVencidos;
	}*/

}
