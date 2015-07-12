package es.pfsgroup.recovery.ext.impl.asunto.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Transient;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;
import org.hibernate.proxy.HibernateProxy;

import es.capgemini.pfs.PluginCoreextensionConstantes;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.pfsgroup.commons.utils.Checks;

@Entity
public class EXTAsunto extends Asunto {

	private static final long serialVersionUID = 2075119525614504409L;
	
	private static final String _GESTOR_DESPACHO = " " + 
	   " select (trim(usu.usu_apellido1) || '-' || trim(usu.usu_apellido2) || '-' || trim(usu.usu_nombre))" + 
	   " from   asu_asuntos a, gaa_gestor_adicional_asunto gaa, " +
       "        usd_usuarios_despachos usd, ${master.schema}.usu_usuarios usu," + 
       "        ${master.schema}.dd_tge_tipo_gestor ddt" +
       " where  a.asu_id = gaa.asu_id  " +
       " and    gaa.usd_id = usd.usd_id" +
       " and    usd.usu_id = usu.usu_id" +
       " and    gaa.dd_tge_id = ddt.dd_tge_id" +
       " and    a.asu_id = ASU_ID";
	
	
	private static final String _DESPACHO_EXTERNO = " " +
	   " select distinct des.des_despacho" +
	   " from   asu_asuntos a, gaa_gestor_adicional_asunto gaa, " +
       "        usd_usuarios_despachos usd, ${master.schema}.usu_usuarios usu," + 
       "        ${master.schema}.dd_tge_tipo_gestor ddt, des_despacho_externo des" +
       " where  a.asu_id = gaa.asu_id  " +
       " and    gaa.usd_id = usd.usd_id" +
       " and    usd.usu_id = usu.usu_id" +
       " and    gaa.dd_tge_id = ddt.dd_tge_id" +
       " and    usd.des_id = des.des_id" +
       " and    ddt.dd_tge_codigo = '" + EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO + "'" +
       " and    a.asu_id = ASU_ID";	   	   	   	 
	
	
	private static final String _GESTOR_DESPACHO_GEXT = _GESTOR_DESPACHO + 
	   " and    ddt.dd_tge_codigo = '" + EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO + "'";
       
	private static final String _GESTOR_DESPACHO_SUP = _GESTOR_DESPACHO + 
	   " and    ddt.dd_tge_codigo = '" + EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR + "'";
		

	@Transient
	private final Log logger = LogFactory.getLog(getClass());

	@OneToMany(mappedBy = "asunto", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "asu_id")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<EXTGestorAdicionalAsunto> gestoresAsunto;
	
	@Formula("(" +
	"				Select SUM(m.mov_pos_viva_no_vencida + m.mov_pos_viva_vencida)" +
	"				from mov_movimientos m" + 
	"				where   (m.cnt_id, ASU_ID) in	" + 
	"						(" +
	"							Select distinct d.cnt_id, a.asu_id " +
	"							from asu_asuntos a, prc_procedimientos p, prc_cex x, cex_contratos_expediente c, cnt_contratos d, ${master.schema}.dd_epr_estado_procedimiento esp" +    
	"							where a.asu_id = p.asu_id" +
	"							and   p.prc_id = x.prc_id and x.cex_id = c.cex_id" +
	"							and   c.cnt_id = d.cnt_id" + 
	"                           and   p.dd_epr_id = esp.dd_epr_id" +
	"							and   p.borrado = 0 and (esp.dd_epr_codigo = '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO + "' or" + 
	"                                                    esp.dd_epr_codigo = '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO + "' or" +
	"                                                    esp.dd_epr_codigo = '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO + "')" + 	
	"						)" +
	"				and m.mov_fecha_extraccion =" +
	"						(select MAX(m2.mov_fecha_extraccion)" +
	"                         from mov_movimientos m2" +
	"                         where m2.cnt_id = m.cnt_id )" +
	          ")")
	private Double saldoTotalPorContratosSQL;
	
	@Formula("(" + 
				  " select sum(abs(prc.prc_saldo_recuperacion)) from prc_procedimientos prc " +
				  " where prc.asu_id = ASU_ID  and prc.borrado = 0 " +
				  " and prc.PRC_PRC_ID is null and prc.dd_epr_id not in ( '" + PluginCoreextensionConstantes.ESTADO_PROCEDIMIENTO_REORGANIZADO + "')" +
				  " group by prc.asu_id" +
			")")
	
	private Double importeEstimado;
		
	@Formula("(" + _GESTOR_DESPACHO_GEXT + ")")
	private String gestorNombreApellidosSQL;
	
	@Formula("(" + _GESTOR_DESPACHO_SUP + ")")
	private String supervisorNombreApellidosSQL;
	
	@Formula("(" + _DESPACHO_EXTERNO + ")")
	private String despachoSQL;
	
	@Column(name = "ASU_ID_EXTERNO")
	private String codigoExterno;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PAS_ID")
	private DDPropiedadAsunto propiedadAsunto;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_GES_ID")
	private DDGestionAsunto gestionAsunto;
	
	@Column(name = "ERROR_ENVIO_CDD")
    private Integer errorEnvioCDD;
	
	
	//private Boolean esMultigestor;

	public String getCodigoExterno() {
		return codigoExterno;
	}

	public void setCodigoExterno(String codigoExterno) {
		this.codigoExterno = codigoExterno;
	}

	public DDPropiedadAsunto getPropiedadAsunto() {
		return propiedadAsunto;
	}

	public void setPropiedadAsunto(DDPropiedadAsunto propiedadAsunto) {
		this.propiedadAsunto = propiedadAsunto;
	}

	public DDGestionAsunto getGestionAsunto() {
		return gestionAsunto;
	}

	public void setGestionAsunto(DDGestionAsunto gestionAsunto) {
		this.gestionAsunto = gestionAsunto;
	}

	public GestorDespacho getGestor(String codigoGestor) {
		if (Checks.estaVacio(gestoresAsunto) || Checks.esNulo(codigoGestor)) {
			return null;
		} else {
			for (EXTGestorAdicionalAsunto gaa : gestoresAsunto) {
				if (codigoGestor.equals(gaa.getTipoGestor().getCodigo())) {
					return gaa.getGestor();
				}
			}
			return null;
		}
	}

	public Map<String, GestorDespacho> getGestoresMap() {
		HashMap<String, GestorDespacho> map = new HashMap<String, GestorDespacho>();
		if (!Checks.estaVacio(gestoresAsunto)) {
			for (EXTGestorAdicionalAsunto gaa : gestoresAsunto) {
				map.put(gaa.getTipoGestor().getCodigo(), gaa.getGestor());
			}
		}
		return map;
	}

	public GestorDespacho getGestor() {
		GestorDespacho gd = getGestorPorTipo();
		if (gd == null) {
			logger.warn("EL ASUNTO " + this.getId()
					+ " NO TIENE GESTOR ASOCIADO");
		}
		return gd;
		
		//return super.getGestor();
	}
	
    // JEM:
	// Con esta funci�n se intenta evitar que haya JSON's que haya que modificar por el cambio
	// introducido para ordenar por gestor/Supervisor/Despacho.
	// S�lo se modifica ListadoAsuntosJSON.jsp para que sea compatible entre las diferentes
	// entidades financieras.
	public List<EXTGestorAdicionalAsunto> getGestoresAsunto()
	{		
		//return (!Checks.estaVacio(gestoresAsunto));
		return gestoresAsunto;
	}

	public GestorDespacho getSupervisor() {
		if (super.getSupervisor() != null) {
			return super.getSupervisor();
		} else {
			return this.getGestor("SUP");
		}
	}

	private GestorDespacho getGestorPorTipo() {
		GestorDespacho gd = getSupervisorPorTipo();
		if (gd == null) {
			logger.warn("EL ASUNTO " + this.getId()
					+ " NO TIENE SUPERVISOR ASOCIADO");
		}
		
		return gd;
	}

	private GestorDespacho getSupervisorPorTipo() {
		if (super.getGestor() != null) {
			return super.getGestor();
		} else {
			return this.getGestor("GEXT");
		}
	}

	/**
	 * Devuelve el saldo total del asunto. Se calcula como la sumatoria del
	 * saldo original vencido de cada uno de los contratos asociados a los
	 * distintos procedimientos asociados a este Asunto.
	 * 
	 * @return el saldo total del Asunto
	 */
	public Double getSaldoTotalPorContratos() {
		double saldo = 0;

		ArrayList<ExpedienteContrato> listaExpc = new ArrayList<ExpedienteContrato>();

		saldo = 0;
		for (Procedimiento p : getProcedimientosContables()) {
			for (ExpedienteContrato exc : p.getExpedienteContratos()) {
				if (!listaExpc.contains(exc)) {
					listaExpc.add(exc);
					saldo += exc.getContrato().getLastMovimiento()
							.getPosVivaVencida();
					saldo += exc.getContrato().getLastMovimiento()
							.getPosVivaNoVencida();
				}
			}
		}
		return saldo;
	}

	public Double getSaldoTotalPorContratosSQL() {

		Double saldo = saldoTotalPorContratosSQL;			
		
		return saldo;
	}
	
	public String getGestorNombreApellidosSQL() {

		String gest = gestorNombreApellidosSQL;			
		
		return gest;
	}
	
	public String getSupervisorNombreApellidosSQL() {

		String sup = supervisorNombreApellidosSQL;			
		
		return sup;
	}
	
	public String getDespachoSQL() {

		String desp = despachoSQL;			
		
		return desp;
	}
	
	/*
	public void setGestoresAsunto(List<EXTGestorAdicionalAsunto> gestoresAsunto)
	{		
		this.gestoresAsunto = gestoresAsunto;

		
		if(gestoresAsunto != null)
		{
			for (EXTGestorAdicionalAsunto gesA : gestoresAsunto) {
				gesA.setAsunto(this);
	        }
		}

	}
	*/
	
	public GestorDespacho getGestorCEXP() {		
			return this.getGestor("GECEXP");		
	}
	
	public GestorDespacho getSupervisorCEXP() {
			return this.getGestor("SUPCEXP");
	}
	
	public GestorDespacho getProcurador() {
		if (super.getProcurador() != null) {
			return super.getProcurador();
		} else {
			return this.getGestor("PROC");
		}
	}

	public void setImporteEstimado(Double importeEstimado) {
		this.importeEstimado = importeEstimado;
	}

	public Double getImporteEstimado() {
		return importeEstimado;
	}
	
	/**
     * Volumen de Riesgo de los procedimientos contenidos en el asunto (suma del principal del procedimiento).
     * @return Float
     */
	@Override
    public Float getVolumenRiesgo() {
		
		Float volumenRiesgo = new Float(0.0f);
		
        for (Procedimiento p : getProcedimientosContables()) {
            	
            if (p.getSaldoRecuperacion() != null)
            	volumenRiesgo += p.getSaldoRecuperacion().floatValue();
        }
        return volumenRiesgo;
    }

	/**
	 * Recupera el último procedimiento del asunto (basado en el ID), considera
	 * el ID más alto como el último. 
	 * 
	 * @param asu
	 * @return
	 */
	public Procedimiento getUltimoProcedimiento() {
		Procedimiento ultimoProc = null;
		List<Procedimiento> lista = this.getProcedimientos();
		if (!Checks.estaVacio(lista)) {
			for (Procedimiento prc : lista) {
				if (ultimoProc == null) {
					ultimoProc = prc;
				} else {
					if (prc.getId() > ultimoProc.getId())
						ultimoProc = prc;
				}
			}
		}
		return ultimoProc;
	}

	/**
	 * @return the errorEnvioCDD
	 */
	public Integer getErrorEnvioCDD() {
		return errorEnvioCDD;
	}

	/**
	 * @param errorEnvioCDD the errorEnvioCDD to set
	 */
	public void setErrorEnvioCDD(Integer errorEnvioCDD) {
		this.errorEnvioCDD = errorEnvioCDD;
	}
	
	@Transient
	public static EXTAsunto instanceOf(Asunto asunto) {
		EXTAsunto extAsunto = null;
		if (asunto==null) return null;
	    if (asunto instanceof HibernateProxy) {
	    	extAsunto = (EXTAsunto) ((HibernateProxy) asunto).getHibernateLazyInitializer()
	                .getImplementation();
	    } else if (asunto instanceof EXTAsunto){
	    	extAsunto = (EXTAsunto) asunto;
		}
		return extAsunto;
	}
}
