package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.FechaArrasExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;

@Component
public class UpdaterServiceSancionOfertaInstruccionesReserva implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private UvemManagerApi uvemManagerApi;
    
    @Autowired
  	private ActivoTramiteApi activoTramiteApi;
    
    @Autowired
	private ApiProxyFactory proxyFactory;
    
    private static final String FECHA_ENVIO = "fechaEnvio";
    private static final String TIPO_ARRAS = "tipoArras";
    private static final String COMBO_RESULTADO = "comboResultado";
    private static final String MOTIVO_APLAZAMIENTO = "motivoAplazamiento";
    private static final String COMBO_QUITAR = "comboQuitar";
   	private static final String motivoAplazamiento = "Suspensión proceso arras";
   	public static final String CODIGO_T013_INSTRUCCIONES_RESERVA = "T013_InstruccionesReserva";
   	public static final String CODIGO_T017_INSTRUCCIONES_RESERVA = "T017_InstruccionesReserva";
   	public static final String CODIGO_T017 = "T017";
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaInstruccionesReserva.class);
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		boolean estadoBcModificado = false;
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Usuario usuarioLogeado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			FechaArrasExpediente fae = null;
			DDEstadosExpedienteComercial estadoExp = null;
			DDEstadoExpedienteBc estadoBc = null;
				
		
			for(TareaExternaValor valor :  valores){
	
				if(FECHA_ENVIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				{
					Reserva reserva = expediente.getReserva();
					if(!Checks.esNulo(reserva)){
						try {
							reserva.setFechaEnvio(ft.parse(valor.getValor()));
							genericDao.save(Reserva.class, reserva);
						} catch (ParseException e) {
							e.printStackTrace();
						}
					}
				}
				
				if(TIPO_ARRAS.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
					Reserva reserva = expediente.getReserva();
					if(!Checks.esNulo(reserva)){
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
						DDTiposArras tipoArras = (DDTiposArras) genericDao.get(DDTiposArras.class, filtro);						
						reserva.setTipoArras(tipoArras);
						genericDao.save(Reserva.class, reserva);
					}
				}
				
				if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
					if (DDSiNo.SI.equals(valor.getValor())) {						
						estadoExp = genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_AGENDAR_ARRAS));
						estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_ARRAS_APROBADAS));
						expediente.setEstado(estadoExp);
						expediente.setEstadoBc(estadoBc);
						estadoBcModificado = true;
					}
				}
				
				if(MOTIVO_APLAZAMIENTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
					Filter filter = null;
					fae = expedienteComercialApi.getUltimaPropuesta(expediente.getId(),null);
					if (fae != null) {
						DDMotivosEstadoBC motivo = genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_APLAZADA));
						if (motivo != null) {
							fae.setValidacionBC(motivo);
						}
						fae.setMotivoAnulacion(valor.getValor());
						
						genericDao.save(FechaArrasExpediente.class, fae);
					}
				}
				
				if (COMBO_QUITAR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					if (DDSiNo.SI.equals(valor.getValor())) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_PBC_VENTAS);
						estadoExp = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estadoExp);
						
						Filter filtroBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_OFERTA_APROBADA);
						estadoBc = genericDao.get(DDEstadoExpedienteBc.class, filtroBc);
						expediente.setEstadoBc(estadoBc);
						
						genericDao.save(ExpedienteComercial.class, expediente);
						
						Filter filtroReserva = genericDao.createFilter(FilterType.EQUALS,  "expediente.id", expediente.getId());
						Reserva reserva = genericDao.get(Reserva.class, filtroReserva);
						
						if (reserva != null) {
							reserva.getAuditoria().setBorrado(true);
							reserva.getAuditoria().setUsuarioBorrar(usuarioLogeado.getUsername());
							reserva.getAuditoria().setFechaBorrar(new Date());
						}
						
						genericDao.update(Reserva.class, reserva);
						
						fae = expedienteComercialApi.getUltimaPropuesta(expediente.getId(), null);
						if (fae != null) {
							DDMotivosEstadoBC motivoBC = genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_ANULADA));
							fae.setValidacionBC(motivoBC);
						}
						fae.setMotivoAnulacion(motivoAplazamiento);
						
						genericDao.save(FechaArrasExpediente.class, fae);
						
					}
				}
				
				genericDao.save(ExpedienteComercial.class, expediente);
			}
			// LLamada servicio web Bankia para modificaciones según tipo
			// propuesta (MOD3)
			
			if(!Checks.estaVacio(valores) && ofertaAceptada.getActivoPrincipal() != null){
				String codigoTarea = null;
				if(activoTramiteApi.isTramiteVenta(tramite.getTipoTramite())) {
					codigoTarea = UpdaterServiceSancionOfertaInstruccionesReserva.CODIGO_T013_INSTRUCCIONES_RESERVA;
				}else if(activoTramiteApi.isTramiteVentaApple(tramite.getTipoTramite())) {
					codigoTarea = UpdaterServiceSancionOfertaInstruccionesReserva.CODIGO_T017_INSTRUCCIONES_RESERVA;
				}
				
				if( codigoTarea != null && DDCartera.isCarteraBk(ofertaAceptada.getActivoPrincipal().getCartera()) 
					&& !DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
					&& !CODIGO_T017.equals(tramite.getTipoTramite().getCodigo())){
					if (!uvemManagerApi.esTramiteOffline(codigoTarea,expediente)) {
						uvemManagerApi.modificacionesSegunPropuesta(valores.get(0).getTareaExterna());
					}					
					
				}
			}
			
			if(estadoBcModificado) {
				ofertaApi.replicateOfertaFlush(expediente.getOferta());
			}

		}

	}
	
	
	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_INSTRUCCIONES_RESERVA,CODIGO_T017_INSTRUCCIONES_RESERVA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
