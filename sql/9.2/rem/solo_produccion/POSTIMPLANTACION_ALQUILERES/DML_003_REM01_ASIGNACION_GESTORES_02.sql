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

DECLARE

	PL_OUTPUT VARCHAR2(32000 CHAR);

BEGIN		
	
	REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3('SP_AGA_V4', PL_OUTPUT, NULL, 1, '02');   

END;
/
EXIT
