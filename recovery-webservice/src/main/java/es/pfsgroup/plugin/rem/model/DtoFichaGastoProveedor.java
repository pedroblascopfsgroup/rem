package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de un gasto.
 *  
 * @author Luis Caballero
 *
 */
public class DtoFichaGastoProveedor extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idGasto;
	private Long numGastoHaya;
	private Long numGastoGestoria;
	private String referenciaEmisor;
	private String tipoGastoCodigo;
	private String subtipoGastoCodigo;
	private String nifEmisor;
	private String buscadorNifEmisor;
	private String buscadorNifPropietario;
	private String nombreEmisor;
	private Long idEmisor;
	private String destinatario;
	private String propietario;
	private Date fechaEmision;
	private String periodicidad;
	private String concepto;
	private String nifPropietario;
	private String nombrePropietario;
	private String codigoEmisor;
	private String destinatarioGastoCodigo;
	private boolean autorizado;
	private boolean asignadoATrabajos;
	private boolean asignadoAActivos;
	
	public Long getIdGasto() {
		return idGasto;
	}
	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}
	public Long getNumGastoHaya() {
		return numGastoHaya;
	}
	public void setNumGastoHaya(Long numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}
	public Long getNumGastoGestoria() {
		return numGastoGestoria;
	}
	public void setNumGastoGestoria(Long numGastoGestoria) {
		this.numGastoGestoria = numGastoGestoria;
	}
	public String getReferenciaEmisor() {
		return referenciaEmisor;
	}
	public void setReferenciaEmisor(String referenciaEmisor) {
		this.referenciaEmisor = referenciaEmisor;
	}

	public String getNifEmisor() {
		return nifEmisor;
	}
	public void setNifEmisor(String nifEmisor) {
		this.nifEmisor = nifEmisor;
	}
	public String getBuscadorNifEmisor() {
		return buscadorNifEmisor;
	}
	public void setBuscadorNifEmisor(String buscadorNifEmisor) {
		this.buscadorNifEmisor = buscadorNifEmisor;
	}
	public String getNombreEmisor() {
		return nombreEmisor;
	}
	public void setNombreEmisor(String nombreEmisor) {
		this.nombreEmisor = nombreEmisor;
	}
	public Long getIdEmisor() {
		return idEmisor;
	}
	public void setIdEmisor(Long idEmisor) {
		this.idEmisor = idEmisor;
	}
	public String getDestinatario() {
		return destinatario;
	}
	public void setDestinatario(String destinatario) {
		this.destinatario = destinatario;
	}
	public String getPropietario() {
		return propietario;
	}
	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}
	public Date getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getNifPropietario() {
		return nifPropietario;
	}
	public void setNifPropietario(String nifPropietario) {
		this.nifPropietario = nifPropietario;
	}
	public String getNombrePropietario() {
		return nombrePropietario;
	}
	public void setNombrePropietario(String nombrePropietario) {
		this.nombrePropietario = nombrePropietario;
	}
	public String getCodigoEmisor() {
		return codigoEmisor;
	}
	public void setCodigoEmisor(String codigoEmisor) {
		this.codigoEmisor = codigoEmisor;
	}
	public String getBuscadorNifPropietario() {
		return buscadorNifPropietario;
	}
	public void setBuscadorNifPropietario(String buscadorNifPropietario) {
		this.buscadorNifPropietario = buscadorNifPropietario;
	}
	public String getTipoGastoCodigo() {
		return tipoGastoCodigo;
	}
	public void setTipoGastoCodigo(String tipoGastoCodigo) {
		this.tipoGastoCodigo = tipoGastoCodigo;
	}
	public String getSubtipoGastoCodigo() {
		return subtipoGastoCodigo;
	}
	public void setSubtipoGastoCodigo(String subtipoGastoCodigo) {
		this.subtipoGastoCodigo = subtipoGastoCodigo;
	}
	public String getDestinatarioGastoCodigo() {
		return destinatarioGastoCodigo;
	}
	public void setDestinatarioGastoCodigo(String destinatarioGastoCodigo) {
		this.destinatarioGastoCodigo = destinatarioGastoCodigo;
	}
	public void setAutorizado(boolean autorizado) {
		this.autorizado = autorizado;
		
	}
   	public boolean getAutorizado() {
   		return this.autorizado;
   	}
	public boolean getAsignadoATrabajos() {
		return asignadoATrabajos;
	}
	public void setAsignadoATrabajos(boolean asignadoATrabajos) {
		this.asignadoATrabajos = asignadoATrabajos;
	}
	public boolean getAsignadoAActivos() {
		return asignadoAActivos;
	}
	public void setAsignadoAActivos(boolean asignadoAActivos) {
		this.asignadoAActivos = asignadoAActivos;
	}
}
