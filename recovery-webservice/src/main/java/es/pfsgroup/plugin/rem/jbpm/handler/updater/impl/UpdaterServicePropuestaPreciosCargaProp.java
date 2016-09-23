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
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class UpdaterServicePropuestaPreciosCargaProp implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    private static final String FECHA_SANCION = "fechaSancion";
	private static final String FECHA_CARGA = "fechaCarga";
	private static final String CODIGO_T009_CARGA_PROPUESTA = "T009_SancionCargaPropuesta";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		for(TareaExternaValor valor :  valores){

			//Fecha sancion
			if(FECHA_SANCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				//Guardado adicional Fecha generación propuesta => trabajo.propuesta precios ->  Fecha carga y Fecha Sancion
				try {
					tramite.getTrabajo().getPropuestaPrecio().setFechaSancion(ft.parse(valor.getValor()));
					Auditoria.save(tramite.getTrabajo().getPropuestaPrecio());
				} catch (ParseException e) {
					e.printStackTrace();
				}

			}
			
			//Fecha carga
			if(FECHA_CARGA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				//Guardado adicional Fecha generación propuesta => trabajo.propuesta precios ->  Fecha carga y Fecha Sancion
				try {
					tramite.getTrabajo().getPropuestaPrecio().setFechaCarga(ft.parse(valor.getValor()));
					Auditoria.save(tramite.getTrabajo().getPropuestaPrecio());
				} catch (ParseException e) {
					e.printStackTrace();
				}

			}
			

		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T009_CARGA_PROPUESTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
