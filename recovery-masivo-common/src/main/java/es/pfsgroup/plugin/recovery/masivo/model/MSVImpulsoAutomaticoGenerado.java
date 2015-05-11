package es.pfsgroup.plugin.recovery.masivo.model;

import java.io.Serializable;

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

import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

@Entity
@Table(name = "IAG_IMPULSO_AUTO_GENERADO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause="borrado = 0")
public class MSVImpulsoAutomaticoGenerado  implements Serializable, Auditable {

	private static final long serialVersionUID = -6312496169927297316L;

	public static final String RESULTADO_OK = "OK";
	public static final String RESULTADO_ERROR = "ERR";

	@Id
	@Column(name = "IAG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVImpulsoAutomaticoGeneradoGenerator")
	@SequenceGenerator(name = "MSVImpulsoAutomaticoGeneradoGenerator", sequenceName = "S_IAG_IMPULSO_AUTO_GENERADO")
	private Long id;

	@Embedded
	private Auditoria auditoria;

    @JoinColumn(name = "PIA_ID")
	@ManyToOne
    private MSVProcesoImpulsoAutomatico procesoImpulso;
	
	//IAG_RESULTADO VARCHAR2(3), --POSIBLES VALORES 'OK', 'ERR'
	@Column(name = "IAG_RESULTADO")
	private String resultado;
	
    //IAG_DESCRICION_ERROR VARCHAR2(255),
	@Column(name = "IAG_DESCRICION_ERROR")
	private String descripcionError;
	
    //IAG_DOCUMENTO_GENERADO VARCHAR2(255),
	@Column(name = "IAG_DOCUMENTO_GENERADO")
	private String documentoGenerado;
	
    //ADJ_ID NUMBER(16),
    @JoinColumn(name = "ADJ_ID")
	@ManyToOne
    private Adjunto adjunto;
	
    //PRC_ID NUMBER(16),
    @JoinColumn(name = "PRC_ID")
	@ManyToOne
    private Procedimiento procedimiento;
	
    //TEX_ID NUMBER(16),
    @JoinColumn(name = "TEX_ID")
	@ManyToOne
    private TareaExterna tarea;
	
    //DD_PLA_ID NUMBER(16),
    @JoinColumn(name = "DD_PLA_ID")
	@ManyToOne
    private TipoPlaza plaza;
	
    //IAG_CON_PROCURADOR NUMBER(1),
	@Column(name="IAG_CON_PROCURADOR")
	private Boolean conProcurador;
	
    //BPM_IPT_ID NUMBER(16)
    @JoinColumn(name = "BPM_IPT_ID")
	@ManyToOne
	private RecoveryBPMfwkInput input;

    //IAG_CASO_NOVA VARCHAR2(16),
	@Column(name="IAG_CASO_NOVA")
	private String casoNova;
	
	//Cartera
	@Column(name = "IAG_CARTERA")
	private String cartera;

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

	public MSVProcesoImpulsoAutomatico getProcesoImpulso() {
		return procesoImpulso;
	}

	public void setProcesoImpulso(MSVProcesoImpulsoAutomatico procesoImpulso) {
		this.procesoImpulso = procesoImpulso;
	}

	public String getResultado() {
		return resultado;
	}

	public void setResultado(String resultado) {
		this.resultado = resultado;
	}

	public String getDescripcionError() {
		return descripcionError;
	}

	public void setDescripcionError(String descripcionError) {
		this.descripcionError = descripcionError;
	}

	public String getDocumentoGenerado() {
		return documentoGenerado;
	}

	public void setDocumentoGenerado(String documentoGenerado) {
		this.documentoGenerado = documentoGenerado;
	}

	public Adjunto getAdjunto() {
		return adjunto;
	}

	public void setAdjunto(Adjunto adjunto) {
		this.adjunto = adjunto;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public TareaExterna getTarea() {
		return tarea;
	}

	public void setTarea(TareaExterna tarea) {
		this.tarea = tarea;
	}

	public TipoPlaza getPlaza() {
		return plaza;
	}

	public void setPlaza(TipoPlaza plaza) {
		this.plaza = plaza;
	}

	public Boolean getConProcurador() {
		return conProcurador;
	}

	public void setConProcurador(Boolean conProcurador) {
		this.conProcurador = conProcurador;
	}

	public RecoveryBPMfwkInput getInput() {
		return input;
	}

	public void setInput(RecoveryBPMfwkInput input) {
		this.input = input;
	}

	public String getCasoNova() {
		return casoNova;
	}

	public void setCasoNova(String casoNova) {
		this.casoNova = casoNova;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	
}
