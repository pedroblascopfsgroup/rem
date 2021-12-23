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
public class UpdaterServiceCierreContratoNoComercial implements UpdaterService {

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
    @Autowired
	private ApiProxyFactory proxyFactory;
    	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceCierreContratoNoComercial.class);
    
	private static final String DOCUMENTO_OK = "docOK";
	private static final String FECHA_VALIDACION = "fechaValidacion";
	private static final String N_CONTRATO_PRINEX = "ncontratoPrinex";
	private static final String MAESTRO_ORIGEN_REM= "REM";
	
	private static final String CODIGO_T018_CIERRE_CONTRATO = "T018_CierreContrato";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		
		for(TareaExternaValor valor :  valores){
			
			if(DOCUMENTO_OK.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				expedienteComercial.setDocumentacionOk(true);
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

		try {
			if(DDTipoOferta.isTipoAlquilerNoComercial(oferta.getTipoOferta()) && MAESTRO_ORIGEN_REM.equals(oferta.getOrigen())){
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
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_CIERRE_CONTRATO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
