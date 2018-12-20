--/*
--###########################################
--## AUTOR=DAP
--## FECHA_CREACION=20181114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-XXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Perfilado.
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
  
BEGIN		
	
	REM01.SP_PERFILADO_FUNCIONES('SP_PEF_FUN');        

END;
/
EXIT
