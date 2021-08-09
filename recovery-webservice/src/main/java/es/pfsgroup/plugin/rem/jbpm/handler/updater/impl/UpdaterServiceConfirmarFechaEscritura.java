package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Posicionamiento;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;

@Component
public class UpdaterServiceConfirmarFechaEscritura implements UpdaterService {

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;

	private static final String CODIGO_T017_CONFIRMAR_FECHA_ESCRITURA = "T017_ConfirmarFechaEscritura";
	private static final String COMBO_VALIDACION_BC = "comboValidacionBC";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceConfirmarFechaEscritura.class);

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		String codigoValidacionBC = null;

		for(TareaExternaValor valor :  valores){
			if(COMBO_VALIDACION_BC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				codigoValidacionBC = valor.getValor();
				break;
			}
		}
		
		if(DDMotivosEstadoBC.CODIGO_RECHAZADA_BC.equals(codigoValidacionBC)) {
			ExpedienteComercial eco = expedienteComercialApi.getExpedienteByIdTramite(tramite.getId());
			if(eco != null) {
				Posicionamiento pos = expedienteComercialApi.getUltimoPosicionamiento(eco.getId(), null, false);
				if(pos != null) {
					pos.setFechaFinPosicionamiento(new Date());
					genericDao.save(Posicionamiento.class, pos);
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_CONFIRMAR_FECHA_ESCRITURA };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		// TODO Auto-generated method stub
		
	}

}
