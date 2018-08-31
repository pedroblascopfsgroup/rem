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
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionOferta;

@Component
public class UpdaterServiceSancionOfertaAlquileresElevarASancion implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
        
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresElevarASancion.class);
			
    private static final String RESOLUCION_OFERTA = "resolucionOferta";
	private static final String FECHA_SANCION = "fechaSancion";
	private static final String MOTIVO_ANULACION = "motivoAnulacion";
	private static final String COMITE = "comite";
	private static final String REF_CIRCUITO_CLIENTE = "refCircuitoCliente";
	private static final String FECHA_ELEVACION = "fechaElevacion";
	
	private static final String CODIGO_T015_ELEVAR_A_SANCION = "T015_ElevarASancion";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		
		for(TareaExternaValor valor :  valores){

			if(RESOLUCION_OFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Filter filtroResolucionOferta = null;
				
				if(DDResolucionOferta.CODIGO_ELEVAR.equals(valor.getValor())) {
					filtroResolucionOferta = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResolucionOferta.CODIGO_ELEVAR);
				}else if(DDResolucionOferta.CODIGO_ANULAR.equals(valor.getValor())) {
					filtroResolucionOferta = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResolucionOferta.CODIGO_ANULAR);
				}
				
				if(!Checks.esNulo(filtroResolucionOferta)) {
					DDResolucionOferta resolucionOferta = genericDao.get(DDResolucionOferta.class, filtroResolucionOferta);
					//¿Donde se guarda la resolucion de la oferta?
				}
			}
			
			if(FECHA_SANCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					if(!Checks.esNulo(expedienteComercial))
						expedienteComercial.setFechaSancion(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha Sancion Comite.", e);
				}
			}
			
			if(MOTIVO_ANULACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				//¿Donde se guarda el motivo anulacion? 
				//Porque en el funcional pone que es un campo de texto pero en la BBDD sale como id DD_MRO_ID.
			}
			
			if(COMITE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				//¿Donde se guarda el comite?
			}
				
			if(REF_CIRCUITO_CLIENTE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				oferta.setRefCircuitoCliente(valor.getValor());
			}
				
			if(FECHA_ELEVACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				//¿Donde se guarda la fecha elevacion?
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_ELEVAR_A_SANCION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
