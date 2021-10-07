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
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;

@Component
public class UpdaterServiceSancionOfertaAlquileresCierreContrato implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    @Autowired
    private ActivoDao activoDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
    @Autowired
	private ApiProxyFactory proxyFactory;
    
    @Autowired
    private ActivoApi activoApi;
    
    @Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresCierreContrato.class);
    
	private static final String DOCUMENTO_OK = "docOK";
	private static final String FECHA_VALIDACION = "fechaValidacion";
	private static final String N_CONTRATO_PRINEX = "ncontratoPrinex";
	private static final String MAESTRO_ORIGEN_REM= "REM";
	
	private static final String CODIGO_T015_CIERRE_CONTRATO = "T015_CierreContrato";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean estadoBcModificado = false;

		
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(DOCUMENTO_OK.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.FIRMADO));
				expedienteComercial.setEstado(estadoExpedienteComercial);
				recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

				expedienteComercial.setDocumentacionOk(true);
				if(oferta.getActivoPrincipal() != null && DDCartera.isCarteraBk(oferta.getActivoPrincipal().getCartera())) {
					DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO));
					expedienteComercial.setEstadoBc(estadoBc);	
					estadoBcModificado = true;
				}

			}
			
			if(FECHA_VALIDACION.equals(valor.getNombre())) {
				try {
					if (!Checks.esNulo(valor.getValor())) {
						expedienteComercial.setFechaValidacion(ft.parse(valor.getValor()));
					} else {
						expedienteComercial.setFechaValidacion(new Date());
					}
				} catch (ParseException e) {
					logger.error("Error insertando Fecha validación.", e);
				}
			}
			
			if(N_CONTRATO_PRINEX.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				oferta.setNumContratoPrinex(valor.getValor());
				expedienteComercial.setNumContratoAlquiler(valor.getValor());
			}
		}
		
		//Llamada a Maestro de Personas
		try {
		if(DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo()) && MAESTRO_ORIGEN_REM.equals(oferta.getOrigen())){
			Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			Thread maestroPersona = new Thread( new MaestroDePersonas(expedienteComercial.getId(),usu.getUsername(),oferta.getActivoPrincipal().getCartera().getDescripcion()));
			maestroPersona.start();
		}
		}catch(Exception e){
			logger.error("Error Maestro persona.", e);
		}
		
		if (!Checks.esNulo(expedienteComercial.getSeguroRentasAlquiler())) {
			expedienteComercialApi.enviarCorreoAsegurador(expedienteComercial.getId());
		}
		
		Activo activo = tramite.getActivo();
		if(!Checks.esNulo(activo)) {
			activoApi.actualizarOfertasTrabajosVivos(activo);
			activoAdapter.actualizarEstadoPublicacionActivo(tramite.getActivo().getId(), false);
			
			if(activoDao.isActivoMatriz(activo.getId())){
				ActivoAgrupacion activoAgrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
				List<ActivoAgrupacionActivo> listaActivosAgrupacion = activoAgrupacion.getActivos();
				for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivosAgrupacion) {	
					activoAdapter.actualizarEstadoPublicacionActivo(activoAgrupacionActivo.getActivo().getId());
				}
			}
		}
		
		if(estadoBcModificado) {
			ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expedienteComercial));
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_CIERRE_CONTRATO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
