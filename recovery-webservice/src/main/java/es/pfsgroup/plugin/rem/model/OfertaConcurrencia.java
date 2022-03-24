package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que gestiona las concurrencias.
 */
@Entity
@Table(name = "OFC_OFERTAS_CONCURRENCIA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class OfertaConcurrencia implements Serializable, Auditable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "OFC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "OfertaConcurrenciaGenerator")
    @SequenceGenerator(name = "OfertaConcurrenciaGenerator", sequenceName = "S_OFC_OFERTAS_CONCURRENCIA")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;

    @Column(name = "OFC_FECHA_DOC")
	private Date fechaDocumentacion;

	@Column(name = "OFC_FECHA_DEPOSITO")
	private Date fechaDeposito;

    @Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public Date getFechaDocumentacion() {
		return fechaDocumentacion;
	}

	public void setFechaDocumentacion(Date fechaDocumentacion) {
		this.fechaDocumentacion = fechaDocumentacion;
	}

	public Date getFechaDeposito() {
		return fechaDeposito;
	}

	public void setFechaDeposito(Date fechaDeposito) {
		this.fechaDeposito = fechaDeposito;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public boolean entraEnTiempoDocumentacion(){
		if(this.oferta != null && this.oferta.getConcurrencia() != null && this.oferta.getConcurrencia()){
			Date fechaTopeOferta = sumarRestarHorasFecha(oferta.getAuditoria().getFechaCrear(), 72);
			Date fechaHoy = new Date();

			int fecha = (int) ((fechaTopeOferta.getTime()-fechaHoy.getTime())/86400000);

			return fecha >= 0;
		}
		return true;
	}

	public boolean entraEnTiempoDeposito(){
		if(this.oferta != null && this.oferta.getConcurrencia() != null && this.oferta.getConcurrencia()){
			Date fechaTopeOferta = sumarRestarHorasFecha(oferta.getAuditoria().getFechaCrear(), 96);
			Date fechaHoy = new Date();

			int fecha = (int) ((fechaTopeOferta.getTime()-fechaHoy.getTime())/86400000);

			return fecha >= 0;
		}
		return true;
	}

	public Date sumarRestarHorasFecha(Date fecha, int horas){
		Calendar calendar = Calendar.getInstance();

		calendar.setTime(fecha); // Configuramos la fecha que se recibe
		calendar.add(Calendar.HOUR, horas);  // numero de horas a añadir, o restar en caso de horas<0

		return calendar.getTime(); // Devuelve el objeto Date con las nuevas horas añadidas
	}


}