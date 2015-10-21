package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

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
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.recovery.ext.impl.asunto.model.DDPropiedadAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

/**
 * Clase que representa la entidad Subasta.
 * 
 * @author
 * 
 */
@Entity
@Table(name = "SUB_SUBASTA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Subasta implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5987488870796403973L;
	
	@Transient
	private String PROYECTO = "PRODUCTO";
	

	@Id
	@Column(name = "SUB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SubastaGenerator")
	@SequenceGenerator(name = "SubastaGenerator", sequenceName = "S_SUB_SUBASTA")
	private Long id;

	/**
	 * Gonzalo: Se cambia LAZY para EAGER para que se utilice el objeto extendido y no se cree
	 * un proxy para acceder a sus propuiedades. EXTAsunto.
	 * Si se pone Lazy a la hora de acceder a sus propiedades JSON habría que hacer cast 
	 * mediante unproxy a la clase Hijo.
	 * 
	 */
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "ASU_ID")
	private Asunto asunto;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PRC_ID")
	private Procedimiento procedimiento;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TSU_ID")
	private DDTipoSubasta tipoSubasta;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ESU_ID")
	private DDEstadoSubasta estadoSubasta;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_REC_ID")
	private DDResultadoComite resultadoComite;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MSS_ID")
	private DDMotivoSuspSubasta motivoSuspension;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MCS_ID")
	private DDEstadoAsunto estadoAsunto;

	@Column(name = "SUB_NUM_AUTOS")
	private String numAutos;

//	
//	@Column(name = "SUB_TASACION")
//	private boolean tasacion;
//
	
//	@Column(name = "SUB_INFO_LETRADO")
//	private boolean infoLetrado;

	@Column(name = "SUB_FECHA_SOLICITUD")
	private Date fechaSolicitud;

	@Column(name = "SUB_FECHA_SENYALAMIENTO")
	private Date fechaSenyalamiento;

	@Column(name = "SUB_FECHA_ANUNCIO")
	private Date fechaAnuncio;

	@Column(name = "SUB_COSTAS_LETRADO")
	private Float costasLetrado;
	
	@OneToMany(mappedBy = "subasta", fetch = FetchType.LAZY)
	@OrderBy("id ASC")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<LoteSubasta> lotesSubasta;
	
	@Column(name="DEUDA_JUDICIAL_MIG")
	private Float deudaJudicial;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	@Column(name="SYS_GUID")
	private String guid;
	
	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}
	
	//Atributo que nos dice si alguno de los bienes de la subasta est� embargado
    @Formula(value = " ( select case when ( select count(ls.sub_id) "
    		+ "						from los_lote_subasta ls, lob_lote_bien lb, EMP_NMBEMBARGOS_PROCEDIMIENTOS ep "
    		+ "						where ls.los_id=lb.los_id "
    		+ "							and ep.bie_id=lb.bie_id "
    		+ "							and ls.sub_id=SUB_ID "
    		+ "				) > 0 then 1 "
    		+ "				else 0 "
    		+ "			end "
    		+ "         from dual )")	
    private boolean embargo;   
    
    @Formula(value = " ( select nvl( "
    		     + " ( select sum(bc.bie_car_importe_economico+bc.bie_car_importe_registral) "
    		     + "  from bie_car_cargas bc, los_lote_subasta ls, lob_lote_bien lb "
    		     + "  where bc.bie_id=lb.bie_id "
    		     + "       and ls.los_id=lb.los_id "
    		     + "       and bc.dd_tpc_id= ( "
    		     + "            select tc.dd_tpc_id "
    		     + "            from DD_TPC_TIPO_CARGA tc "
    		     + "            where tc.dd_tpc_codigo='ANT') "
    		     + "       and ls.sub_id=SUB_ID"
    		     + " ),0) "
    		     + " from dual "
    			 + " ) ")    
    private String cargasAnteriores;   
    
    @Formula(value = " ( select nvl( "
    		 	+ " (select sum(ba.BIE_ADJ_IMPORTE_ADJUDICACION) "
    		 	+ " from sub_subasta s, LOS_LOTE_SUBASTA ls, LOB_LOTE_BIEN lb, BIE_BIEN b, BIE_ADJ_ADJUDICACION ba "
    		 	+ " where s.sub_id=ls.sub_id "
    		 	+ "      and ls.los_id=lb.los_id "
  				+ "      and lb.bie_id=b.bie_id "
  				+ "      and b.bie_id=ba.bie_id "
  				+ "      and ls.sub_id=SUB_ID "
  				+ " ),0) "
  				+ " from dual "
  				+ " ) ")	
    private String totalImporteAdjudicado;    
    
    @Formula(value = "(SELECT "
            + "CASE "
            + "WHEN count(*) > 0 "
            + "THEN 0 "
              + "ELSE 1 "
            + "END  "
          + "FROM sub_subasta s "          
          + "WHERE s.SUB_ID = SUB_ID and "
          + "s.dd_rec_id is null )")
	private boolean subastaRevisada;

    @Formula(value = "(select case when (CASE when count(bie.bie_id) = 0 then -1 else count(bie.bie_id) end = ( "
            + " sum( case when los.los_puja_sin_postores is not null and los.los_puja_postores_desde is not null and los.los_puja_postores_hasta is not null and los.los_valor_subasta is not null then 1 else 0 end)) "
            + "  ) then 1 else 0 end "
            + "  from los_lote_subasta los " 
            + "  join lob_lote_bien lob on los.los_id = lob.los_id and los.borrado=0 "
            + "  join bie_bien bie on lob.bie_id = bie.bie_id and bie.borrado=0 " 
            + "  where los.sub_id = SUB_ID)")
    private boolean instrucciones;

    @Formula ( value = "(SELECT CASE WHEN  (CASE when count(bie.bie_id) = 0 then -1 else count(bie.bie_id)*2 end) = (SUM (CASE "
                     + " WHEN (case when val.bie_fecha_valor_tasacion = NULL then SYSDATE else val.bie_fecha_valor_tasacion - 90 end) < SYSDATE "
                     + "      THEN 1 "
                     + "   ELSE 0 "
                     + " END) + SUM (case when val.bie_fecha_valor_tasacion = null then 0 else 1 end)) THEN 1 ELSE 0 END "
          + " FROM los_lote_subasta los JOIN lob_lote_bien LOB ON los.los_id = LOB.los_id "
             + "   JOIN bie_bien bie ON LOB.bie_id = bie.bie_id AND bie.borrado = 0 "
               + " JOIN bie_valoraciones val ON bie.bie_id = val.bie_id AND val.borrado = 0 "
         + " WHERE 1 = 1 AND los.sub_id = SUB_ID AND bie.dd_tbi_id = 1)")
    private boolean tasacion;

    @Formula ( value = "(SELECT CASE WHEN  (CASE when count(bie.bie_id) = 0 then -1 else count(bie.bie_id)*2 end) = (SUM (CASE "
                     + " WHEN (case when val.bie_fecha_valor_tasacion = NULL then SYSDATE else val.bie_fecha_valor_tasacion + 540 end) > SUB_FECHA_SENYALAMIENTO "
                     + "      THEN 1 "
                     + "   ELSE 0 "
                     + " END) + SUM (case when val.bie_fecha_valor_tasacion = null then 0 else 1 end)) THEN 1 ELSE 0 END "
          + " FROM los_lote_subasta los JOIN lob_lote_bien LOB ON los.los_id = LOB.los_id "
             + "   JOIN bie_bien bie ON LOB.bie_id = bie.bie_id AND bie.borrado = 0 "
               + " JOIN bie_valoraciones val ON bie.bie_id = val.bie_id AND val.borrado = 0 "
         + " WHERE 1 = 1 AND los.sub_id = SUB_ID AND bie.dd_tbi_id = 1)")
    private boolean tasacionSAREB;
    
    @Formula ( value = "(SELECT CASE WHEN  (CASE when count(bie.bie_id) = 0 then -1 else count(bie.bie_id)*2 end) = (SUM (CASE "
            + " WHEN (case when val.bie_fecha_valor_tasacion = NULL then SYSDATE else val.bie_fecha_valor_tasacion + 180 end) > SUB_FECHA_SENYALAMIENTO "
            + "      THEN 1 "
            + "   ELSE 0 "
            + " END) + SUM (case when val.bie_fecha_valor_tasacion = null then 0 else 1 end)) THEN 1 ELSE 0 END "
            + " FROM los_lote_subasta los JOIN lob_lote_bien LOB ON los.los_id = LOB.los_id "
            + "   JOIN bie_bien bie ON LOB.bie_id = bie.bie_id AND bie.borrado = 0 "
            + " JOIN bie_valoraciones val ON bie.bie_id = val.bie_id AND val.borrado = 0 "
            + " WHERE 1 = 1 AND los.sub_id = SUB_ID AND bie.dd_tbi_id = 1)")
    private boolean tasacionBANKIA;
    
    @Formula( value = " (select case when ( "
           + " CASE when count(bie.bie_id) = 0 then -1 else count(bie.bie_id)*3 end = ( "
           + "  sum(case when bie.BIE_VIVIENDA_HABITUAL is null then 0 else 1 end) + "
           + "  sum(case when bie.DD_SPO_ID is null or bie.DD_SPO_ID = 0 then 0 else 1 end) + "
           + "  sum(case when adi.BIE_ADI_FFIN_REV_CARGA is null then 0 else 1 end))) then 1 else 0 end "  
           + " FROM los_lote_subasta los  "
           + " join lob_lote_bien lob on los.los_id = lob.los_id AND los.borrado=0 " 
           + " join bie_bien bie on lob.bie_id = bie.bie_id and bie.borrado=0 AND bie.dd_tbi_id = 1 "
           + " join bie_adicional adi on bie.bie_id = adi.bie_id and adi.borrado=0  "
           + " WHERE 1=1 and los.SUB_ID = SUB_ID )")
    private boolean infoLetrado;
    
    public boolean isTasacion(String proyecto) {
		EXTAsunto asunto = (EXTAsunto) this.getAsunto();
		DDPropiedadAsunto propiedad = asunto.getPropiedadAsunto();
		if(Checks.esNulo(proyecto) || PROYECTO.compareTo(proyecto) == 0){		
			return this.isTasacion();
		} else {
			if(propiedad == null){
				return this.isTasacionBANKIA();
			} else if (DDPropiedadAsunto.PROPIEDAD_SAREB.compareTo(propiedad.getCodigo()) == 0){
				return this.isTasacionSAREB();
			} else {
				return this.isTasacionBANKIA();
			}		
		}
	}
    
	public boolean isTasacion() {		
			return this.getTasacion();		
	}

	public void setTasacion(boolean tasacion) {
		this.tasacion = tasacion;
	}

	public boolean getTasacion(){
			return this.tasacion;
//		boolean hayBienes = false;
//		for (LoteSubasta loteSubasta : this.getLotesSubasta()) {			
//			for (Bien bien : loteSubasta.getBienes()) {				
//				if (bien instanceof NMBBien) {
//					hayBienes = true;
//					NMBBien nmbBien = (NMBBien) bien;
//					return checkTasacion(nmbBien);
//				}
//			}						
//		}
//		return (hayBienes) ? true : false; 
	}
	
	public boolean isTasacionSAREB() {
		if(!Checks.esNulo(this.fechaSenyalamiento)){
			return tasacionSAREB;
		}else{
			return false;
		}
	}

	public void setTasacionSAREB(boolean tasacionSAREB) {
		this.tasacionSAREB = tasacionSAREB;
	}

	public boolean isTasacionBANKIA() {
		if(!Checks.esNulo(this.fechaSenyalamiento)){
			return tasacionBANKIA;
		}else{
			return false;
		}
	}

	public void setTasacionBANKIA(boolean tasacionBANKIA) {
		this.tasacionBANKIA = tasacionBANKIA;
	}

	public boolean isInfoLetrado() {
		return this.getInfoLetrado();
	}

	public boolean getInfoLetrado() {
		return this.infoLetrado;
//		boolean hayBienes = false;
//		for (LoteSubasta loteSubasta : this.getLotesSubasta()) {			
//			for (Bien bien : loteSubasta.getBienes()) {
//				if (bien instanceof NMBBien) {
//					hayBienes = true;
//					NMBBien nmbBien = (NMBBien) bien;
//					return checkInfLetrado(nmbBien);
//				}
//			}						
//		}
//		return (hayBienes) ? true : false;
	}
	
	public void setInfoLetrado(boolean infoLetrado) {
		this.infoLetrado = infoLetrado;
	}
		
	public void setEmbargo(boolean embargo) {
		this.embargo = embargo;
	}

	public void setCargasAnteriores(String cargasAnteriores) {
		this.cargasAnteriores = cargasAnteriores;
	}

	public void setTotalImporteAdjudicado(String totalImporteAdjudicado) {
		this.totalImporteAdjudicado = totalImporteAdjudicado;
	}

	public boolean isInstrucciones() {
		return this.getInstrucciones();
	}

	public void setInstrucciones(boolean instrucciones) {
		this.instrucciones = instrucciones;
	}
	
	public boolean getInstrucciones() {
		return this.instrucciones;
//		for (LoteSubasta loteSubasta : this.getLotesSubasta()) {
//			if ((Checks.esNulo(loteSubasta.getInsPujaSinPostores())) || (Checks.esNulo(loteSubasta.getInsPujaPostoresDesde())) || (Checks.esNulo(loteSubasta.getInsPujaPostoresHasta())) || 
//					(Checks.esNulo(loteSubasta.getIns50DelTipoSubasta())) || (Checks.esNulo(loteSubasta.getIns60DelTipoSubasta())) || (Checks.esNulo(loteSubasta.getIns70DelTipoSubasta())) 
//					|| (Checks.esNulo(loteSubasta.getInsValorSubasta()))) {
//				return false;
//			}
//		}
//		return (Checks.estaVacio(this.getLotesSubasta())) ? false : true; 
	}
	
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Asunto getAsunto() {
		return asunto;
	}

	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public DDTipoSubasta getTipoSubasta() {
		return tipoSubasta;
	}

	public void setTipoSubasta(DDTipoSubasta tipoSubasta) {
		this.tipoSubasta = tipoSubasta;
	}

	public DDResultadoComite getResultadoComite() {
		return resultadoComite;
	}

	public void setResultadoComite(DDResultadoComite resultadoComite) {
		this.resultadoComite = resultadoComite;
	}

	public DDMotivoSuspSubasta getMotivoSuspension() {
		return motivoSuspension;
	}

	public void setMotivoSuspension(DDMotivoSuspSubasta motivoSuspension) {
		this.motivoSuspension = motivoSuspension;
	}

	public DDEstadoAsunto getEstadoAsunto() {
		return estadoAsunto;
	}

	public void setEstadoAsunto(DDEstadoAsunto estadoAsunto) {
		this.estadoAsunto = estadoAsunto;
	}

	public String getNumAutos() {
		return numAutos;
	}

	public void setNumAutos(String numAutos) {
		this.numAutos = numAutos;
	}

	public boolean isSubastaRevisada() {
		return this.getSubastaRevisada();
	}
	
	public boolean getSubastaRevisada() {
		return this.subastaRevisada;
	}

	public void setSubastaRevisada(boolean subastaRevisada) {
		this.subastaRevisada = subastaRevisada;
		
	}

	/**
	 * Retorna el atributo auditoria.
	 * 
	 * @return auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * Setea el atributo auditoria.
	 * 
	 * @param auditoria
	 *            Auditoria
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * Retorna el atributo version.
	 * 
	 * @return version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * Setea el atributo version.
	 * 
	 * @param version
	 *            Integer
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}

	public DDEstadoSubasta getEstadoSubasta() {
		return estadoSubasta;
	}

	public void setEstadoSubasta(DDEstadoSubasta estadoSubasta) {
		this.estadoSubasta = estadoSubasta;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaSenyalamiento() {
		return fechaSenyalamiento;
	}

	public void setFechaSenyalamiento(Date fechaSenyalamiento) {
		this.fechaSenyalamiento = fechaSenyalamiento;
	}

	public Date getFechaAnuncio() {
		return fechaAnuncio;
	}

	public void setFechaAnuncio(Date fechaAnuncio) {
		this.fechaAnuncio = fechaAnuncio;
	}
	
	public Float getCostasLetrado() {
		return costasLetrado;
	}

	public void setCostasLetrado(Float costasLetrado) {
		this.costasLetrado = costasLetrado;
	}

	public List<LoteSubasta> getLotesSubasta() {
		return lotesSubasta;
	}

	public void setLotesSubasta(List<LoteSubasta> lotesSubasta) {
		this.lotesSubasta = lotesSubasta;
	}
	
	public boolean getEmbargo() {
		return embargo;
	}	
	
	public String getCargasAnteriores() {
		return cargasAnteriores;
	}	
	
	public String getTotalImporteAdjudicado() {
		return totalImporteAdjudicado;
	}
	
	private Boolean checkTasacion(NMBBien nmbBien) {
		if (Checks.estaVacio(nmbBien.getValoraciones())) {
			return false;
		}
		for (NMBValoracionesBien nmbValoracionesBien : nmbBien.getValoraciones()) {
			if (Checks.esNulo(nmbValoracionesBien.getFechaValorTasacion())) {
				return false;
			} else {
				Date d = new Date();
				Long diferencia = restaFechas(d, nmbValoracionesBien.getFechaValorTasacion());
				if (diferencia.intValue() > 90) {
					return false;
				}
			}
		}
		return true;
	}
	
	private Boolean checkInfLetrado(NMBBien nmbBien) {
		if (Checks.esNulo(nmbBien.getViviendaHabitual())  || Checks.esNulo(nmbBien.getSituacionPosesoria())
				|| Checks.esNulo(nmbBien.getAdicional()) || Checks.esNulo(nmbBien.getAdicional().getFechaRevision()) ) {
			return false;
		}
		return true;
	}
	
	private Long restaFechas(Date fechaMenor, Date fechaMayor) {
		long in = fechaMayor.getTime();
		long fin = fechaMenor.getTime();
		return (fin - in) / (1000 * 60 * 60 * 24);

	}

	public Float getDeudaJudicial() {
		return deudaJudicial;
	}

	public void setDeudaJudicial(Float deudaJudicial) {
		this.deudaJudicial = deudaJudicial;
	}


	/**
	 * Devuelve el contrato con mayor importe asociada al lote.
	 * 
	 * @return
	 */
	public Contrato getContratoGeneral() {
		Procedimiento procedimiento = this.getProcedimiento();
		if (procedimiento==null) return null;
		List<ProcedimientoContratoExpediente> listadoContratos = procedimiento.getProcedimientosContratosExpedientes();
		Contrato maximaOperacion = null;
		Float importeMayor = null;
		for (ProcedimientoContratoExpediente exp_contrato : listadoContratos) {
			Contrato busquedaContrato = exp_contrato.getExpedienteContrato().getContrato();
			Float pVenc = (Checks.esNulo(busquedaContrato.getLastMovimiento().getPosVivaVencida())) ? 0F : busquedaContrato.getLastMovimiento().getPosVivaVencida();
			Float pNoVenc = (Checks.esNulo(busquedaContrato.getLastMovimiento().getPosVivaNoVencida())) ? 0F : busquedaContrato.getLastMovimiento().getPosVivaNoVencida();
			Float sumaPosicion = pVenc + pNoVenc;
			if (importeMayor==null || sumaPosicion>importeMayor) {
				maximaOperacion = busquedaContrato;
				importeMayor = maximaOperacion.getLastMovimiento().getDeudaIrregular();
			}
		}
		return maximaOperacion;
	}
	
}
