package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

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
    private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresFirma.class);
    
	private static final String FECHA_FIRMA = "fechaFirma";
	
	private static final String CODIGO_T015_FIRMA = "T015_Firma";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		DDEstadosExpedienteComercial estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_CIERRE));
		Activo activo =tramite.getActivo();
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
		activo.setSituacionComercial(situacionComercial);
		activo.getSituacionPosesoria().setOcupado(1);
		activo.getSituacionPosesoria().setConTitulo(tipoTituloActivoTPA);
		
		expedienteComercial.setEstado(estadoExpedienteComercial);
		
		for(TareaExternaValor valor :  valores){
			
			if(FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					expedienteComercial.setFechaVenta(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha anulación.", e);
				}
			}
		}
		activoDao.saveOrUpdate(activo);
		activoAdapter.actualizarEstadoPublicacionActivo(activo.getId(),true);
		expedienteComercialApi.update(expedienteComercial);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_FIRMA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
