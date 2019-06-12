package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;


@Service("expedienteAvisoProblemasURSUS")
public class ExpedienteAvisoProblemasURSUS implements ExpedienteAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(ExpedienteAvisoProblemasURSUS.class);
	
	@Autowired
    private GenericABMDao genericDao;
	
	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
		
		if (!Checks.esNulo(expediente.getOferta()) && !Checks.estaVacio(expediente.getCompradores())) {
			Oferta oferta = expediente.getOferta();
			if (!Checks.esNulo(oferta.getActivosOferta())) {
				List<ActivoOferta> listaActivosOferta = oferta.getActivosOferta();
				for (ActivoOferta listaActivoOferta : listaActivosOferta) {			
					if (!Checks.esNulo(listaActivoOferta.getActivoId())) {
						Long activoOfertaId = listaActivoOferta.getActivoId();
						Activo activo = genericDao.get(Activo.class,genericDao.createFilter(FilterType.EQUALS,"id", activoOfertaId));
						if(DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
							List<CompradorExpediente> listaCompradores = expediente.getCompradores();	
							for (CompradorExpediente listaComprador : listaCompradores) {
								if (!Checks.esNulo(listaComprador.getComprador())) {
									Long compradorId = listaComprador.getComprador();
									Comprador comprador = genericDao.get(Comprador.class,genericDao.createFilter(FilterType.EQUALS,"id", compradorId));
									if (!Checks.esNulo(comprador.getProblemasUrsus()) && comprador.getProblemasUrsus()) {
										dtoAviso.setId(String.valueOf(expediente.getId()));
										dtoAviso.setDescripcion("Problemas URSUS");
									}
								}									
							}								
						}
					}
				}
			}
		}						
		return dtoAviso;
	}
	
}
