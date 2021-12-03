package es.pfsgroup.plugin.rem.activo.catastro;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.CatastroApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.DtoDatosCatastro;

@Service("catastroManager")
public class CatastroManager implements CatastroApi {
	
    @Autowired
	private ActivoDao activoDao;
    
    
	public DtoDatosCatastro getDatosCatastroRem(Long idActivo) {
		DtoDatosCatastro dto = new DtoDatosCatastro();
		Activo activo = activoDao.getActivoById(idActivo);
	
		if(activo != null) {
			ActivoInfoRegistral infoR = activo.getInfoRegistral();
			ActivoInfoComercial infoC = activo.getInfoComercial();
				
			dto.setIdActivo(idActivo);
			dto.setDireccion(activo.getDireccionCompleta());
			dto.setSuperficieConstruida((double)activo.getTotalSuperficieConstruida());			
			//dto.setSuperficieReperComun(superficieReperComun); ¿De donde sale esto?
			dto.setCodigoPostal(activo.getCodPostal());
			dto.setTipoVia(activo.getTipoVia().getCodigo());
			dto.setNombreVia(activo.getNombreVia());
			dto.setNumeroVia(activo.getNumeroDomicilio());
			
			if(infoR != null) {
				dto.setSuperficieParcela((double) infoR.getSuperficieParcela());
			}
			if(infoC != null) {
				dto.setAnyoConstruccion(infoC.getAnyoConstruccion());
			}
		}
		return dto;
	}
		
	
}