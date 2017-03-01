package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;

import es.pfsgroup.plugin.rem.model.dd.DDEstadoDisponibilidadComercial;



/**
 * Gestiona la vista que identifica los condicionantes de disponibilidad de cada activo
 * 
 * @author Daniel Gutiérrez
 *
 */
@Entity
@Table(name = "V_COND_DISPONIBILIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class VCondicionantesDisponibilidad  implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ACT_ID")
    private Long idActivo;

	@Column(name = "RUINA")
	private Boolean ruina;
	
	@Column(name = "PENDIENTE_INSCRIPCION")
	private Boolean pendienteInscripcion;
	
	@Column(name = "OBRANUEVA_SINDECLARAR")
	private Boolean obraNuevaSinDeclarar;
	
	@Column(name = "SIN_TOMA_POSESION_INICIAL")
	private Boolean sinTomaPosesionInicial;
	
	@Column(name = "PROINDIVISO")
	private Boolean proindiviso;
	
	@Column(name = "OBRANUEVA_ENCONSTRUCCION")
	private Boolean obraNuevaEnConstruccion;
	
	@Column(name = "OCUPADO_CONTITULO")
	private Boolean ocupadoConTitulo;
	
	@Column(name = "TAPIADO")
	private Boolean tapiado;
	
	@Column(name = "OTRO")
	private String otro;
	
	@Column(name = "ESTADO_PORTAL_EXTERNO")
	private Boolean portalesExternos;
	
	@Column(name = "OCUPADO_SINTITULO")
	private Boolean ocupadoSinTitulo;
	
	@Column(name = "DIVHORIZONTAL_NOINSCRITA")
	private Boolean divHorizontalNoInscrita;
	
	@Column(name = "ES_CONDICIONADO")
	private Boolean isCondicionado;
	
	@Column(name = "EST_DISP_COM_CODIGO")
	private String estadoCondicionadoCodigo;

	
	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Boolean getRuina() {
		return ruina;
	}

	public void setRuina(Boolean ruina) {
		this.ruina = ruina;
	}

	public Boolean getPendienteInscripcion() {
		return pendienteInscripcion;
	}

	public void setPendienteInscripcion(Boolean pendienteInscripcion) {
		this.pendienteInscripcion = pendienteInscripcion;
	}

	public Boolean getObraNuevaSinDeclarar() {
		return obraNuevaSinDeclarar;
	}

	public void setObraNuevaSinDeclarar(Boolean obraNuevaSinDeclarar) {
		this.obraNuevaSinDeclarar = obraNuevaSinDeclarar;
	}

	public Boolean getSinTomaPosesionInicial() {
		return sinTomaPosesionInicial;
	}

	public void setSinTomaPosesionInicial(Boolean sinTomaPosesionInicial) {
		this.sinTomaPosesionInicial = sinTomaPosesionInicial;
	}

	public Boolean getProindiviso() {
		return proindiviso;
	}

	public void setProindiviso(Boolean proindiviso) {
		this.proindiviso = proindiviso;
	}

	public Boolean getObraNuevaEnConstruccion() {
		return obraNuevaEnConstruccion;
	}

	public void setObraNuevaEnConstruccion(Boolean obraNuevaEnConstruccion) {
		this.obraNuevaEnConstruccion = obraNuevaEnConstruccion;
	}

	public Boolean getOcupadoConTitulo() {
		return ocupadoConTitulo;
	}

	public void setOcupadoConTitulo(Boolean ocupadoConTitulo) {
		this.ocupadoConTitulo = ocupadoConTitulo;
	}

	public Boolean getTapiado() {
		return tapiado;
	}

	public void setTapiado(Boolean tapiado) {
		this.tapiado = tapiado;
	}

	public String getOtro() {
		return otro;
	}

	public void setOtro(String otro) {
		this.otro = otro;
	}

	public Boolean getOcupadoSinTitulo() {
		return ocupadoSinTitulo;
	}

	public void setOcupadoSinTitulo(Boolean ocupadoSinTitulo) {
		this.ocupadoSinTitulo = ocupadoSinTitulo;
	}

	public Boolean getDivHorizontalNoInscrita() {
		return divHorizontalNoInscrita;
	}

	public void setDivHorizontalNoInscrita(Boolean divHorizontalNoInscrita) {
		this.divHorizontalNoInscrita = divHorizontalNoInscrita;
	}
	
	public Boolean getPortalesExternos() {
		return portalesExternos;
	}

	public void setPortalesExternos(Boolean portalesExternos) {
		this.portalesExternos = portalesExternos;
	}
	
	public Boolean getIsCondicionado() {
		return isCondicionado;
	}
	
	public void setIsCondicionado(Boolean isCondicionado) {
		this.isCondicionado = isCondicionado;
	}

	public String getEstadoCondicionadoCodigo() {
		return estadoCondicionadoCodigo;
	}
	
	public void setEstadoCondicionadoCodigo(String estadoCondicionadoCodigo) {
		this.estadoCondicionadoCodigo = estadoCondicionadoCodigo;
	}

}
