--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180519
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-751
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    
    PL_OUTPUT VARCHAR2(32000 CHAR);
    SP_OUTPUT VARCHAR2(32000 CHAR);

BEGIN

    #ESQUEMA#.SP_UPG_USER_PERFIL_GESTOR(
        'REMVIP-751'
        , 'golden.tree'
        , NULL
        , 'golden.tree'
        , 'REMGTREE'
        , 'GTREE'
        , 'Despacho Golden Tree'
        , 'HAYAGOLDTREE'
        , 'Gestor de Golden Tree'
        , 'GTREE'
        , 'Gestor de Golden Tree'
        , '12'
        , 1
        , PL_OUTPUT);    
        
    #ESQUEMA#.SP_UPG_USER_PERFIL_GESTOR(
        'REMVIP-751'
        , 'moody.enayetallah'
        , 'menayetallah@goldentree.com'
        , 'golden.tree'
        , 'REMGTREE'
        , 'GTREE'
        , NULL
        , 'HAYAGOLDTREE'
        , NULL
        , NULL
        , NULL
        , '12'
        , 0
        , PL_OUTPUT);
        
    #ESQUEMA#.SP_UPG_USER_PERFIL_GESTOR(
        'REMVIP-751'
        , 'lois.duhourcau'
        , 'lduhourcau@goldentree.com'
        , 'golden.tree'
        , 'REMGTREE'
        , 'GTREE'
        , NULL
        , 'HAYAGOLDTREE'
        , NULL
        , NULL
        , NULL
        , '12'
        , 0
        , PL_OUTPUT);
    
    #ESQUEMA#.SP_PERFILADO_FUNCIONES('REMVIP-751');
     
    #ESQUEMA#.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3 ('REMVIP-751', SP_OUTPUT, NULL, NULL, '02');
    PL_OUTPUT := PL_OUTPUT || SP_OUTPUT || CHR(10);
    
    DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
    
EXCEPTION
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || '[ERROR] Se ha producido un error en la ejecución: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
        ROLLBACK;
        RAISE;
END;
/
EXIT;