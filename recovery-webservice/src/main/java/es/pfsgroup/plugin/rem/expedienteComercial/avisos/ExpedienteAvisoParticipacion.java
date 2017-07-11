package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

@Service("expedienteAvisoParticipacion")
public class ExpedienteAvisoParticipacion implements ExpedienteAvisadorApi {
	protected static final Log logger = LogFactory.getLog(ExpedienteAvisoParticipacion.class);
	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {		
		Oferta oferta = expediente.getOferta();
		Double importeOferta = !Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteContraOferta() : oferta.getImporteOferta();
		Double suma = 0D;
		DtoAviso dto = new DtoAviso();
		try {

			List<ActivoOferta> activosOferta = oferta.getActivosOferta();
			for (ActivoOferta activoOferta : activosOferta) {
				suma += activoOferta.getImporteActivoOferta();
			}
			if(Double.compare(suma, importeOferta) != 0) {
				dto.setId(String.valueOf(expediente.getId()));
				dto.setDescripcion("% participación de activos incorrecto");
			}
		} catch (Exception e) {
			logger.error("error en ExpedienteAvisoParticipacion", e);
		}
		return dto;
	}

}
