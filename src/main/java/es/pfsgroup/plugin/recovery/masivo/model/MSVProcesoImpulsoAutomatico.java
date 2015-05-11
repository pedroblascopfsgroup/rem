package es.pfsgroup.plugin.recovery.masivo.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "PIA_PROCESO_IMPULSO_AUTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause="borrado = 0")
public class MSVProcesoImpulsoAutomatico  implements Serializable, Auditable {

	private static final long serialVersionUID = -1601807522667996224L;

	public static final String ESTADO_INICIADO = "INI";
	public static final String ESTADO_FINALIZADO = "FIN";
	public static final String ESTADO_ERROR = "ERR";
	
	@Id
	@Column(name = "PIA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVProcesoImpulsoAutomaticoGenerator")
	@SequenceGenerator(name = "MSVProcesoImpulsoAutomaticoGenerator", sequenceName = "S_PIA_PROCESO_IMPULSO_AUTO")
	private Long id;

	@Embedded
	private Auditoria auditoria;

	//Configuración de Impulso Automático 
    @JoinColumn(name = "CIA_ID")
	@ManyToOne
    private MSVConfImpulsoAutomatico confImpulso;
	
    //FECHAPROCESO TIMESTAMP(6)         NOT NULL,
    @Column(name = "FECHAPROCESO")
    private Date fechaProceso;
    
    //PIA_ESTADO VARCHAR2(3) NOT NULL, -- VALORES: 'INI', 'FIN', 'ERR' 
    @Column(name = "PIA_ESTADO")
    private String estado;
    
    //PIA_FICHERO_RESULTADOS VARCHAR2(255),
    @Column(name = "PIA_FICHERO_RESULTADOS")
    private String ficheroResultados;
    
    //PIA_FICHERO_ERRORES VARCHAR2(255),
    @Column(name = "PIA_FICHERO_ERRORES")
    private String ficheroErrores;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public MSVConfImpulsoAutomatico getConfImpulso() {
		return confImpulso;
	}

	public void setConfImpulso(MSVConfImpulsoAutomatico confImpulso) {
		this.confImpulso = confImpulso;
	}

	public Date getFechaProceso() {
		return fechaProceso;
	}

	public void setFechaProceso(Date fechaProceso) {
		this.fechaProceso = fechaProceso;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public String getFicheroResultados() {
		return ficheroResultados;
	}

	public void setFicheroResultados(String ficheroResultados) {
		this.ficheroResultados = ficheroResultados;
	}

	public String getFicheroErrores() {
		return ficheroErrores;
	}

	public void setFicheroErrores(String ficheroErrores) {
		this.ficheroErrores = ficheroErrores;
	}

}
