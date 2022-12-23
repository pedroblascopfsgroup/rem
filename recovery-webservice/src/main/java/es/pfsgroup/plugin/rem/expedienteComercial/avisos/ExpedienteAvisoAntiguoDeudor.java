package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Service("expedienteAvisoAntiguoDeudor")
public class ExpedienteAvisoAntiguoDeudor implements ExpedienteAvisadorApi {
	
	@Autowired
	OfertaApi ofertaApi;
	
	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
		
		if (expediente.getOferta() != null) {
			List<HistoricoAntiguoDeudor> historicoAntiguoDeudorList = ofertaApi.getHistoricoAntiguoDeudorList(expediente.getOferta().getId());
			
			if (historicoAntiguoDeudorList != null && !historicoAntiguoDeudorList.isEmpty()) {
				HistoricoAntiguoDeudor historicoAntiguoDeudor = historicoAntiguoDeudorList.get(0);
				
				if (historicoAntiguoDeudor.getLocalizable() != null && DDSinSiNo.CODIGO_NO.equals(historicoAntiguoDeudor.getLocalizable().getCodigo())) {
					dtoAviso.setId(String.valueOf(expediente.getId()));
					dtoAviso.setDescripcion("Deudor no localizable");
				}
			}
		}

		return dtoAviso;
	}

}