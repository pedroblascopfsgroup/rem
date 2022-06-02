package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;

@Component
public class UpdaterServiceAgendarYFirmarAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private TramiteAlquilerApi tramiteAlquilerApi;
	
    @Autowired
    private ActivoDao activoDao;
    
    @Autowired
    private ActivoApi activoApi;
    
    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
	private ActivoAdapter activoAdapter;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceAgendarYFirmarAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_AGENDAR_Y_FIRMAR = "T018_AgendarYFirmar";
	private static final String FECHA = "fecha";
	
	private static final String COMBO_IRCLROD = "comboIrClRod";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		boolean firmado = false;

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		Activo activo = tramite.getActivo();
		
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoExpedienteBc estadoExpedienteBc = null;
		String fechaFirma = null;
		
		for(TareaExternaValor valor :  valores) {
			if(COMBO_IRCLROD.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					tramiteAlquilerApi.irClRod(expedienteComercial);	
				}else {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.FIRMADO));
					estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					expedienteComercial.setEstadoBc(estadoExpedienteBc);		
					firmado = true;
				}
			}

			if(FECHA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				fechaFirma = valor.getValor();
			}
		}

		if(firmado) {

			if(!Checks.esNulo(activo) && !Checks.esNulo(oferta)) {
				
				List<ActivoOferta> activosOferta = oferta.getActivosOferta();
				
				DDSituacionComercial situacionComercial = (DDSituacionComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionComercial.class, DDSituacionComercial.CODIGO_ALQUILADO);
				Filter filtroTipoEstadoAlquiler = genericDao.createFilter(FilterType.EQUALS, "codigo",DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO);
				DDTipoEstadoAlquiler tipoEstadoAlquiler = genericDao.get(DDTipoEstadoAlquiler.class, filtroTipoEstadoAlquiler);
				
				for(ActivoOferta activoOferta : activosOferta){
					activo = activoOferta.getPrimaryKey().getActivo();
					
					if (!Checks.esNulo(activo.getActivoPublicacion()) && 
							DDTipoComercializacion.CODIGO_VENTA.equals(activo.getActivoPublicacion().getTipoComercializacion().getCodigo())) {
						
						Filter filtroTipoComercializacion = genericDao.createFilter(FilterType.EQUALS, "codigo",DDTipoComercializacion.CODIGO_ALQUILER_VENTA);
						DDTipoComercializacion tipoComercializacion = genericDao.get(DDTipoComercializacion.class, filtroTipoComercializacion);
						
						activo.getActivoPublicacion().setTipoComercializacion(tipoComercializacion);
					}
					
					genericDao.save(ActivoPublicacion.class, activo.getActivoPublicacion());
					
					Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, filtroActivo);
					
					if(!Checks.esNulo(activoPatrimonio)){
						activoPatrimonio.setTipoEstadoAlquiler(tipoEstadoAlquiler);
						activoPatrimonio.setCheckHPM(true);						
					} else {
						activoPatrimonio = new ActivoPatrimonio();
						activoPatrimonio.setActivo(activo);
						if (!Checks.esNulo(tipoEstadoAlquiler)){
							activoPatrimonio.setTipoEstadoAlquiler(tipoEstadoAlquiler);
						}
						activoPatrimonio.setCheckHPM(true);
					}
					
					if (!Checks.esNulo(situacionComercial)) {
						activo.setSituacionComercial(situacionComercial);
					}
					
					genericDao.save(ActivoPatrimonio.class, activoPatrimonio);
				}
			
				activoApi.saveOrUpdate(activo);
				
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
		}
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_AGENDAR_Y_FIRMAR};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
