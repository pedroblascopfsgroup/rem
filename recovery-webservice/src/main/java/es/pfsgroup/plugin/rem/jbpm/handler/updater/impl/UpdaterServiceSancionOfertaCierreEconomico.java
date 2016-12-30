package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;

@Component
public class UpdaterServiceSancionOfertaCierreEconomico implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private TrabajoApi trabajoApi;
    
    @Autowired
    private ActivoApi activoApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
   	private static final String CODIGO_T013_CIERRE_ECONOMICO = "T013_CierreEconomico";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		
			//Expediente se marca a vendido
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO);
			DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
			expediente.setEstado(estado);
			genericDao.save(ExpedienteComercial.class, expediente);
			
			//Finaliza el trámite
			Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
			tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
			genericDao.save(ActivoTramite.class, tramite);
			
			for(ActivoOferta activoOferta : ofertaAceptada.getActivosOferta())
			{
				Activo activo = activoOferta.getPrimaryKey().getActivo();
				
				PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
				perimetro.setAplicaComercializar(0);
				//TODO: Cuando esté el motivo de no comercialización como texto libre, poner el texto: "Vendido".
				genericDao.save(PerimetroActivo.class, perimetro);
				
				//Marcamos el activo como vendido
				Filter filtroSituacionComercial = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_VENDIDO);
				activo.setSituacionComercial(genericDao.get(DDSituacionComercial.class, filtroSituacionComercial));
				
				activo.setBloqueoPrecioFechaIni(new Date());
				
				genericDao.save(Activo.class, activo);
			}
			
			//Rechazamos el resto de ofertas
			List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
			for(Oferta oferta : listaOfertas){
				if(DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo())){
					ofertaApi.rechazarOferta(oferta);
				}
			}
			
			genericDao.save(Oferta.class, ofertaAceptada);
			
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_CIERRE_ECONOMICO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
