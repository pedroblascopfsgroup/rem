--/*
--##########################################
--## AUTOR=#AUTOR#
--## FECHA_CREACION=#FECHA#
--## ARTEFACTO=incidencias_produccion
--## VERSION_ARTEFACTO=#RAMA#
--## INCIDENCIA_LINK=#TICKET#
--## PRODUCTO=NO
--## 
--## Finalidad: #DESCRIPCION#
--## VERSIONES:
--##        Generado automáticamente por asistenteDML
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON
SET TIMING ON

DECLARE

	V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';
	V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
	err_num NUMBER;
	err_msg VARCHAR2(2048); 

	V_SQL VARCHAR2(8500 CHAR);
	
 	V_ITEM VARCHAR2(50) := '#TICKET#';

BEGIN 
	
