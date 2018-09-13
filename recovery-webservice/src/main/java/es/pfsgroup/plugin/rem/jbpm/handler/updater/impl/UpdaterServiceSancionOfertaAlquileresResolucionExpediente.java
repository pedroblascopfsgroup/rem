package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;

@Component
public class UpdaterServiceSancionOfertaAlquileresResolucionExpediente implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
        
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresResolucionExpediente.class);
			
    private static final String RESOLUCION_EXPEDIENTE = "resolucionExpediente";
	private static final String FECHA_RESOLUCION = "fechaResolucion";
	private static final String MOTIVO = "motivo";
	private static final String IMPORTE_CONTRAOFERTA = "importeContraoferta";
	
	private static final String CODIGO_T015_RESOLUCION_EXPEDIENTE = "T015_ResolucionExpediente";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoOferta estadoOferta = null;
		for(TareaExternaValor valor :  valores){

			if(RESOLUCION_EXPEDIENTE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				
				if(DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor())) {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_PBC));
					expedienteComercial.setEstado(estadoExpedienteComercial);

					estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_ACEPTADA);
					oferta.setEstadoOferta(estadoOferta);

				}else if(DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.ANULADO));
					expedienteComercial.setEstado(estadoExpedienteComercial);

					estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_RECHAZADA);
					oferta.setEstadoOferta(estadoOferta);

				}else if(DDResolucionComite.CODIGO_CONTRAOFERTA.equals(valor.getValor())) {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.CONTRAOFERTADO));
					expedienteComercial.setEstado(estadoExpedienteComercial);
				}
			}
			
			if(FECHA_RESOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					expedienteComercial.setFechaSancion(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha Sancion Comite.", e);
				}
			}
			
			if(MOTIVO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Filter filtroMotivo = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
				DDMotivoAnulacionExpediente motivoAnulacion = genericDao.get(DDMotivoAnulacionExpediente.class, filtroMotivo);
				expedienteComercial.setMotivoAnulacion(motivoAnulacion);
			}
			
			if(IMPORTE_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				oferta.setImporteContraOferta(Double.parseDouble(valor.getValor()));
			}
		}
		expedienteComercial.setOferta(oferta);
		expedienteComercialApi.update(expedienteComercial);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_RESOLUCION_EXPEDIENTE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
