package es.capgemini.pfs.asunto.dto;

import java.util.List;

public interface ExtAdjuntoGenericoDto {
	
	String getDescripcion();
	Long getId();
	List getAdjuntosAsList();
	List getAdjuntos();

}
