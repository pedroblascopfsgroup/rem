package es.pfsgroup.recovery.ext.turnadoProcuradores;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.ext.turnadodespachos.DDEstadoEsquemaTurnado;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoConfig;

@Entity
@Table(name = "TUP_ETP_ESQ_TURNADO_PROCU", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class EsquemaTurnadoProcurador implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ETP_ID")
 	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EsquemaTurnadoProcuradorGenerator")
    @SequenceGenerator(name = "EsquemaTurnadoProcuradorGenerator", sequenceName = "S_TUP_ETP_ESQ_TURNADO_PROCU")
    private Long id;

	@Column(name = "ETP_DESCRIPCION")
	private String descripcion;
	

	@Column(name = "ETP_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_EET_ID")
	private DDEstadoEsquemaTurnado estado;

	@Column(name = "ETP_FECHA_INI_VIGENCIA")
	private Date fechaInicioVigencia;

	@Column(name = "ETP_FECHA_FIN_VIGENCIA")
	private Date fechaFinVigencia;
	
    @OneToMany(mappedBy = "esquema", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ETP_ID")
    @OrderBy("codigo ASC")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<EsquemaTurnadoConfig> configuracion;
	
    @Embedded
    private Auditoria auditoria;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public DDEstadoEsquemaTurnado getEstado() {
		return estado;
	}

	public void setEstado(DDEstadoEsquemaTurnado estado) {
		this.estado = estado;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}	
	
	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public Date getFechaInicioVigencia() {
		return fechaInicioVigencia;
	}

	public void setFechaInicioVigencia(Date fechaInicioVigencia) {
		this.fechaInicioVigencia = fechaInicioVigencia;
	}

	public Date getFechaFinVigencia() {
		return fechaFinVigencia;
	}

	public void setFechaFinVigencia(Date fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
		
	}

	public List<EsquemaTurnadoConfig> getConfiguracion() {
		return configuracion;
	}

	public void setConfiguracion(List<EsquemaTurnadoConfig> configuracion) {
		this.configuracion = configuracion;
	}

	/**
	 * Recupera una configuración por el Id. Null en caso de no encontrarla.
	 * 
	 * @param id id de configuración
	 * @return Configuración con el id, null en caso de no encontrarla
	 */
	public EsquemaTurnadoConfig getConfigById(Long id) {
		if (configuracion==null) return null;
		for (EsquemaTurnadoConfig config : configuracion) {
			if (config.getId().equals(id)) return config;
 		}
		return null;
	}
	
	
	/**
	 * Recupera una configuración por el Id. Null en caso de no encontrarla.
	 * 
	 * @param id id de configuración
	 * @return Configuración con el id, null en caso de no encontrarla
	 */
	public EsquemaTurnadoConfig getConfigByCodigo(String codigo) {
		if (configuracion==null) return null;
		for (EsquemaTurnadoConfig config : configuracion) {
			if (config.getCodigo().equals(codigo)) return config;
 		}
		return null;
	}
	/**
	 * Comprueba si este esquema contiene la configuración que se le pasa.
	 * 
	 * @param esquemaTurnadoConfig
	 * @return
	 */
	public boolean contains(EsquemaTurnadoConfig esquemaTurnadoConfig) {
		if (this.configuracion==null || esquemaTurnadoConfig==null) return false;
		for (EsquemaTurnadoConfig config : configuracion) {
			if (config.getTipo()!=null 
					&& esquemaTurnadoConfig.getTipo()!=null
					&& config.getCodigo() != null
					&& esquemaTurnadoConfig.getCodigo() != null
					&& config.getTipo().equals(esquemaTurnadoConfig.getTipo()) 
					&& config.getCodigo().equals(esquemaTurnadoConfig.getCodigo())
				) {
				return true;
			}
		}
		return false;
	} 
	
}
