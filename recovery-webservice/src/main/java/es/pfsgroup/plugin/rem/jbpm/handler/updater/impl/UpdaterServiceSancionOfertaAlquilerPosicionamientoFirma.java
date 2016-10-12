package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

@Component
public class UpdaterServiceSancionOfertaAlquilerPosicionamientoFirma implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
        
    
	private static final String FECHA_INICIO = "fechaInicio";
	private static final String FECHA_FIN = "fechaFin";
	private static final String NUM_CONTRATO = "numContrato";
	
	private static final String CODIGO_T014_POSICIONAMIENTO_FIRMA = "T014_PosicionamientoFirma";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ActivoSituacionPosesoria situacionPosesoria = tramite.getActivo().getSituacionPosesoria();
		Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(tramite.getActivo());
		ExpedienteComercial expedienteComercial = null;
		
		if(!Checks.esNulo(ofertaAceptada))
			expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		
		for(TareaExternaValor valor :  valores){

			//Fecha inicio Oferta Alquiler
			if(FECHA_INICIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				//Guardado adicional Fecha inicio => expediente comercial.fecha inicio y en situacion posesoria.fecha toma posesion
				try {
					if(!Checks.esNulo(situacionPosesoria))
						situacionPosesoria.setFechaTomaPosesion(ft.parse(valor.getValor()));
					
					if(!Checks.esNulo(expedienteComercial))
						expedienteComercial.setFechaInicioAlquiler(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					e.printStackTrace();
				}

			}
			
			//Fecha Fin Oferta Alquiler
			if(FECHA_FIN.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				//Guardado adicional Fecha fin => expediente comercial.fecha fin y en situacion posesoria.fecha revision estado posesorio
				try {
					if(!Checks.esNulo(situacionPosesoria))
						situacionPosesoria.setFechaRevisionEstado(ft.parse(valor.getValor()));
					
					if(!Checks.esNulo(expedienteComercial))
						expedienteComercial.setFechaFinAlquiler(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					e.printStackTrace();
				}

			}
			
			//No. de contrato
			if(NUM_CONTRATO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				if(!Checks.esNulo(expedienteComercial))
					expedienteComercial.setNumContratoAlquiler(Integer.parseInt(valor.getValor()));
			}
			

		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T014_POSICIONAMIENTO_FIRMA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
