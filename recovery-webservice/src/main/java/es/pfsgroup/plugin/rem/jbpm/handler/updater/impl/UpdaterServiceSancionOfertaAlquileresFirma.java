package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoOcupadoTitulo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;

@Component
public class UpdaterServiceSancionOfertaAlquileresFirma implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
    private ActivoDao activoDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private ActivoAdapter activoAdapter;
        
    @Autowired
    private ApiProxyFactory proxyFactory;
    
    @Autowired
    private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresFirma.class);
    
	private static final String FECHA_FIRMA = "fechaFirma";
	private static final String COMBO_RESULTADO= "comboResultado";
	private static final String FECHA_INICIO = "fechaInicio";
	private static final String FECHA_FIN = "fechaFin";
	
	private static final String CODIGO_T015_FIRMA = "T015_Firma";
	private static final String CODIGO_T015_AGENDAR_FIRMA = "T015_AgendarFechaFirma";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		boolean anular = false;
		boolean modificadoEstadoBC = false;
		String fechaFirma = null;
		boolean fechaOfertaModificada = false;
		
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		DDEstadosExpedienteComercial estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_CIERRE));
		Activo activo =tramite.getActivo();
		Oferta oferta = expedienteComercial.getOferta();
		ActivoSituacionPosesoria sitpos = tramite.getActivo().getSituacionPosesoria();
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		List<ActivoAgrupacionActivo> agrupacionesActivo = activo.getAgrupaciones();
		for(ActivoAgrupacionActivo activoAgrupacionActivo : agrupacionesActivo){
			if(!Checks.esNulo(activoAgrupacionActivo.getAgrupacion()) && !Checks.esNulo(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion())){
				if((DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER).equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())){
					Long idAgrupacion = activoAgrupacionActivo.getAgrupacion().getId();
					Activo activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(idAgrupacion);
					DDSituacionComercial alquiladoParcialmente = genericDao.get(DDSituacionComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_ALQUILADO_PARCIALMENTE));
					activoMatriz.setSituacionComercial(alquiladoParcialmente);
					activoDao.saveOrUpdate(activoMatriz);
				}
			}
		}
		DDSituacionComercial situacionComercial = (DDSituacionComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionComercial.class, DDSituacionComercial.CODIGO_ALQUILADO);
		DDTipoTituloActivoTPA tipoTituloActivoTPA = (DDTipoTituloActivoTPA) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoTituloActivoTPA.class, DDTipoTituloActivoTPA.tipoTituloSi);
			
		
		
		expedienteComercial.setEstado(estadoExpedienteComercial);
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

		for(TareaExternaValor valor :  valores){
			
			if(FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					expedienteComercial.setFechaFirmaContrato(ft.parse(valor.getValor()));
					expedienteComercial.setFechaVenta(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha anulación.", e);
				}
				fechaFirma = valor.getValor();
			}
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(DDSinSiNo.cambioStringtoBooleano(valor.getValor())) && !DDSinSiNo.cambioStringtoBooleano(valor.getValor())) {
				anular = true;
			}
			if(FECHA_INICIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					expedienteComercial.setFechaInicioAlquiler(ft.parse(valor.getValor()));
					oferta.setFechaInicioContrato(ft.parse(valor.getValor()));
					fechaOfertaModificada = true;
				} catch (ParseException e) {
					logger.error("Error insertando Fecha inicio.", e);
				}
			}
			if(FECHA_FIN.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					expedienteComercial.setFechaFinAlquiler(ft.parse(valor.getValor()));
					oferta.setFechaFinContrato(ft.parse(valor.getValor()));
					fechaOfertaModificada = true;
				} catch (ParseException e) {
					logger.error("Error insertando Fecha fin.", e);
				}
			}

		}
		if(!anular) {
			List<ActivoOferta> activosOferta = oferta.getActivosOferta();
			
			Filter filtroTipoEstadoAlquiler = genericDao.createFilter(FilterType.EQUALS, "codigo",DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO);
			DDTipoEstadoAlquiler tipoEstadoAlquiler = genericDao.get(DDTipoEstadoAlquiler.class, filtroTipoEstadoAlquiler);
			
			for(ActivoOferta activoOferta : activosOferta){
				activo = activoOferta.getPrimaryKey().getActivo();
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
				if (!Checks.esNulo(situacionComercial)) {
					activo.setSituacionComercial(situacionComercial);
				}
				
				if (!Checks.esNulo(activo.getSituacionPosesoria())) {
					activo.getSituacionPosesoria().setOcupado(1);
					if(!Checks.esNulo(tipoTituloActivoTPA)) {
						activo.getSituacionPosesoria().setConTitulo(tipoTituloActivoTPA);
					}
					activo.getSituacionPosesoria().setFechaUltCambioTit(new Date());
				}
				if(sitpos!=null && usu!=null) {			
					HistoricoOcupadoTitulo histOcupado = new HistoricoOcupadoTitulo(activo,sitpos,usu,HistoricoOcupadoTitulo.COD_OFERTA_ALQUILER,null);
					genericDao.save(HistoricoOcupadoTitulo.class, histOcupado);					
				}
				
				activoDao.validateAgrupacion(expedienteComercial.getId());
				genericDao.save(ActivoPatrimonio.class, activoPatrimonio);
			}

			
			activoDao.saveOrUpdate(activo);
			activoAdapter.actualizarEstadoPublicacionActivo(activo.getId(),true);

			if(activoDao.isActivoMatriz(activo.getId())){
				ActivoAgrupacion activoAgrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
				List<ActivoAgrupacionActivo> listaActivosAgrupacion = activoAgrupacion.getActivos();
				for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivosAgrupacion) {	
					activoAdapter.actualizarEstadoPublicacionActivo(activoAgrupacionActivo.getActivo().getId());
				}
			}
			
			if(DDCartera.isCarteraBk(activo.getCartera())) {
				estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.FIRMADO));		
				DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO));
				modificadoEstadoBC = true;
				expedienteComercial.setEstado(estadoExpedienteComercial);
				expedienteComercial.setEstadoBc(estadoBc);
			}
		}else {
			estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADO));
			DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO));
			modificadoEstadoBC = true;
			expedienteComercial.setEstado(estadoExpedienteComercial);
			expedienteComercial.setEstadoBc(estadoBc);	
			ofertaApi.finalizarOferta(oferta);
			
		}
		
		if(fechaOfertaModificada) {
			genericDao.save(Oferta.class, oferta);
		}
		expedienteComercialApi.update(expedienteComercial,false);
				
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_FIRMA, CODIGO_T015_AGENDAR_FIRMA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
