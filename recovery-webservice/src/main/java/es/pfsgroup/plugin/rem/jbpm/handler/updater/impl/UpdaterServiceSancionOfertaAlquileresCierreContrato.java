package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;
import es.pfsgroup.plugin.gestorDocumental.manager.GestorDocumentalMaestroManager;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;

@Component
public class UpdaterServiceSancionOfertaAlquileresCierreContrato implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private GestorDocumentalMaestroManager gestorDocumentalMaestroManager;
	
    @Autowired
	private ApiProxyFactory proxyFactory;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresCierreContrato.class);
    
	private static final String DOCUMENTO_OK = "docOK";
	private static final String FECHA_VALIDACION = "fechaValidacion";
	private static final String N_CONTRATO_PRINEX = "ncontratoPrinex";
	private static final String MAESTRO_ORIGEN_REM= "REM";
	
	private static final String CODIGO_T015_CIERRE_CONTRATO = "T015_CierreContrato";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();

		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(DOCUMENTO_OK.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.FIRMADO_AQLUILER));
				expedienteComercial.setEstado(estadoExpedienteComercial);
				expedienteComercial.setDocumentacionOk(true);
			}
			
			if(FECHA_VALIDACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					expedienteComercial.setFechaValidacion(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha validación.", e);
				}
			}
			
			
			if (!Checks.esNulo(expedienteComercial.getFechaValidacion()) && !Checks.esNulo(expedienteComercial.getDocumentacionOk()) && expedienteComercial.getDocumentacionOk().equals(true)){
				
				List<ActivoOferta> activosOferta = oferta.getActivosOferta();
				
				Filter filtroTipoEstadoAlquiler = genericDao.createFilter(FilterType.EQUALS, "codigo",DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO);
				DDTipoEstadoAlquiler tipoEstadoAlquiler = genericDao.get(DDTipoEstadoAlquiler.class, filtroTipoEstadoAlquiler);
				
				for(ActivoOferta activoOferta : activosOferta){
					Activo activo = activoOferta.getPrimaryKey().getActivo();
					Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, filtroActivo);
					
					if(!Checks.esNulo(activoPatrimonio)){
						activoPatrimonio.setTipoEstadoAlquiler(tipoEstadoAlquiler);
					} else{
						activoPatrimonio = new ActivoPatrimonio();
						activoPatrimonio.setActivo(activo);
						if (!Checks.esNulo(tipoEstadoAlquiler)){
							activoPatrimonio.setTipoEstadoAlquiler(tipoEstadoAlquiler);
						}
					}
					genericDao.save(ActivoPatrimonio.class, activoPatrimonio);
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
			Thread maestroPersona = new Thread( new MaestroDePersonas(expedienteComercial.getId(),usu.getUsername(),oferta.getActivoPrincipal().getCartera().getCodigo()));
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
		return new String[]{CODIGO_T015_CIERRE_CONTRATO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
